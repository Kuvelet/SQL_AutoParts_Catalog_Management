USE [CAN]
GO

/****** Object:  View [dbo].[vw_TUF_Pivoted_IntMaster_Cond_Aggregated]    Script Date: 6/17/2025 4:36:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_TUF_Pivoted_IntMaster_Cond_Aggregated] AS
WITH UnpivotedCondensed AS (
    SELECT DISTINCT
        TSPARTID,
        CrossName,
        UPPER(REPLACE(REPLACE(REPLACE(CrossingNumber, '-', ''), ' ', ''), '.', '')) AS CrossingNumberCondensed
    FROM vw_TUF_Unpivoted_IntMaster_wMake
),
UnpivotedCondensedAgg AS (
    SELECT
        TSPARTID,
        CrossName,
        STRING_AGG(CrossingNumberCondensed, '; ') AS CrossNumberCondensedAgg
    FROM UnpivotedCondensed
    GROUP BY TSPARTID, CrossName
)
SELECT *
FROM UnpivotedCondensedAgg
PIVOT (
    MAX(CrossNumberCondensedAgg)
    FOR CrossName IN (
        [OEM], [SA], [Sachs], [Mightylift], [FCS], [Stabilus], [Martas], [URO], [TRW],
        [Monroe], [Napa], [QH], [Helmer], [Piston], [Kilen], [Optimal], [Meyle], [MagMar],
        [Ferron], [Febi], [Lip], [AC_Delco], [Decar], [Liftgate], [Bugiad], [Triscan],
        [Les], [FA], [Delphi], [Hans_Pries], [Vierol], [Mapco], [Destek], [Cofap],
        [Air_Kraft], [Arnott], [MonroeEUR], [AMS], [Johns], [Klaxcar], [SYD], [DMA],
        [Auger], [Sampa], [Sem_Plastik], [Stellox], [Orex], [DT_Spare_Parts], [Veka]
    )
) AS PivotedResult;
GO


