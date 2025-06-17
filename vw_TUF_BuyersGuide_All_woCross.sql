USE [CAN]
GO

/****** Object:  View [dbo].[vw_TUF_BuyersGuide_All_woCross]    Script Date: 6/17/2025 4:35:06 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






ALTER VIEW [dbo].[vw_TUF_BuyersGuide_All_woCross] AS

WITH UniqueTSPARTID AS (
    SELECT DISTINCT
        TSPARTID
    FROM TUF_CATALOG_AAIA
),

ApplicationInfo AS (
    SELECT
        TSPARTID,
        CASE 
            WHEN COUNT(CASE WHEN MAKE = 'UNIVERSAL' THEN 1 END) > 0 THEN 'Universal'
            ELSE STRING_AGG(MAKE + ': ' + ModelInfo, '  / ')
        END AS Application,
        MIN(MinYear) AS MinYear,
        MAX(MaxYear) AS MaxYear
    FROM (
        SELECT
            TSPARTID,
            MAKE,
            STRING_AGG(CONCAT(MODEL, ' (', MinYear, '–', MaxYear, ')'), '; ') AS ModelInfo,
            MIN(MinYear) AS MinYear,
            MAX(MaxYear) AS MaxYear
        FROM (
            SELECT
                TSPARTID,
                MAKE,
                MODEL,
                MIN([Year]) AS MinYear,
                MAX([Year]) AS MaxYear
            FROM TUF_CATALOG_AAIA
            GROUP BY TSPARTID, MAKE, MODEL
        ) AS ModelYearRanges
        GROUP BY TSPARTID, MAKE
    ) AS ModelsGroupedWithYearRanges
    GROUP BY TSPARTID
),

AggregatedBodyType AS (
    SELECT
        BodyInfo.TSPARTID,
        STRING_AGG(
            CASE 
                WHEN BodyRangeSummary.HasMultipleRanges = 0 THEN BodyInfo.BodyInfo
                ELSE CONCAT(BodyInfo.BodyInfo, ' (', BodyInfo.MinYear, '–', BodyInfo.MaxYear, ')')
            END,
            ', '
        ) AS BodyType
    FROM (
        SELECT
            TSPARTID,
            BodyNumDoors + ' Door ' + BodyType AS BodyInfo,
            MIN([Year]) AS MinYear,
            MAX([Year]) AS MaxYear
        FROM TUF_CATALOG_AAIA
        WHERE BodyNumDoors IS NOT NULL AND VehicleType IS NOT NULL
        GROUP BY TSPARTID, BodyNumDoors, BodyType
    ) AS BodyInfo
    JOIN (
        SELECT
            TSPARTID,
            CASE 
                WHEN COUNT(DISTINCT CAST(MinYear AS VARCHAR) + '-' + CAST(MaxYear AS VARCHAR)) > 1 THEN 1
                ELSE 0
            END AS HasMultipleRanges
        FROM (
            SELECT
                TSPARTID,
                BodyNumDoors,
                BodyType,
                MIN([Year]) AS MinYear,
                MAX([Year]) AS MaxYear
            FROM TUF_CATALOG_AAIA
            WHERE BodyNumDoors IS NOT NULL AND VehicleType IS NOT NULL
            GROUP BY TSPARTID, BodyNumDoors, BodyType
        ) AS Ranges
        GROUP BY TSPARTID
    ) AS BodyRangeSummary
        ON BodyInfo.TSPARTID = BodyRangeSummary.TSPARTID
    GROUP BY BodyInfo.TSPARTID, BodyRangeSummary.HasMultipleRanges
),

AggregatedNotes AS (
    SELECT 
        MBC.TSPARTID,
        MBC.MfrBodyCode,
        C.Cmnts AS Comments,
        D.Dtls AS Details,
        TRIM(' || ' FROM
            CASE WHEN MBC.MfrBodyCode IS NOT NULL AND MBC.MfrBodyCode <> '' THEN MBC.MfrBodyCode + ' || ' ELSE '' END +
            CASE WHEN C.Cmnts IS NOT NULL AND C.Cmnts <> '' THEN C.Cmnts + ' || ' ELSE '' END +
            CASE WHEN D.Dtls IS NOT NULL AND D.Dtls <> '' THEN D.Dtls ELSE '' END
        ) AS Notes
    FROM (
        SELECT 
            TSPARTID,
            STRING_AGG(MfrBodyCode, '; ') AS MfrBodyCode
        FROM (
            SELECT DISTINCT 
                TSPARTID, 
                MfrBodyCode
            FROM TUF_CATALOG_AAIA
        ) AS x
        GROUP BY TSPARTID
    ) AS MBC
    LEFT JOIN (
        SELECT 
            TSPARTID,
            STRING_AGG(COMMENTS, '; ') AS Cmnts
        FROM (
            SELECT DISTINCT 
                TSPARTID, 
                COMMENTS
            FROM TUF_CATALOG_AAIA
            WHERE COMMENTS IS NOT NULL
        ) AS y
        GROUP BY TSPARTID
    ) AS C ON MBC.TSPARTID = C.TSPARTID
    LEFT JOIN (
        SELECT 
            TSPARTID,
            STRING_AGG(DETAILS, '; ') AS Dtls
        FROM (
            SELECT DISTINCT 
                TSPARTID, 
                DETAILS
            FROM TUF_CATALOG_AAIA
            WHERE DETAILS IS NOT NULL
        ) AS z
        GROUP BY TSPARTID
    ) AS D ON MBC.TSPARTID = D.TSPARTID

),

AggregatedTerminology AS (
    SELECT
    TSPARTID,
    (
        SELECT STRING_AGG(AAIAPARTTERMINOLOGY, '; ')
        FROM (
            SELECT DISTINCT TSPARTID, AAIAPARTTERMINOLOGY
            FROM TUF_CATALOG_AAIA
        ) AS DistinctTerminology
        WHERE DistinctTerminology.TSPARTID = base.TSPARTID
    ) AS PartTerminology,

    (
        SELECT STRING_AGG(AAIAPOSITION, '; ')
        FROM (
            SELECT DISTINCT TSPARTID, AAIAPOSITION
            FROM TUF_CATALOG_AAIA
        ) AS DistinctPosition
        WHERE DistinctPosition.TSPARTID = base.TSPARTID
    ) AS Position,

    (
        SELECT STRING_AGG(QUANTITY, '; ')
        FROM (
            SELECT DISTINCT TSPARTID, QUANTITY
            FROM TUF_CATALOG_AAIA
        ) AS DistinctQuantity
        WHERE DistinctQuantity.TSPARTID = base.TSPARTID
    ) AS QuantityNeeded

FROM (
    SELECT DISTINCT TSPARTID
    FROM TUF_CATALOG_AAIA
) AS base
)

SELECT 
    UniqueTSPARTID.TSPARTID AS TSPARTID,
    ApplicationInfo.Application AS Application,
    ApplicationInfo.MinYear AS MinYear,
    ApplicationInfo.MaxYear AS MaxYear,
    AggregatedBodyType.BodyType AS BodyType,
	AggregatedTerminology.PartTerminology AS PartTerminology,
	AggregatedTerminology.Position AS Position,
    AggregatedNotes.Notes AS Notes,
	AggregatedTerminology.QuantityNeeded AS QuantityNeeded
FROM UniqueTSPARTID
LEFT JOIN ApplicationInfo 
    ON UniqueTSPARTID.TSPARTID = ApplicationInfo.TSPARTID
LEFT JOIN AggregatedBodyType 
    ON UniqueTSPARTID.TSPARTID = AggregatedBodyType.TSPARTID
LEFT JOIN AggregatedNotes 
    ON UniqueTSPARTID.TSPARTID = AggregatedNotes.TSPARTID
LEFT JOIN AggregatedTerminology
	ON UniqueTSPARTID.TSPARTID = AggregatedTerminology.TSPARTID
GO


