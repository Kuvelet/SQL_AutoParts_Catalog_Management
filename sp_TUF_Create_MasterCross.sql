USE [CAN]
GO
/****** Object:  StoredProcedure [dbo].[sp_TUF_Create_MasterCross]    Script Date: 6/17/2025 4:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_TUF_Create_MasterCross]
AS
BEGIN
    SET NOCOUNT ON;

    -- Drop the MasterCross table if it already exists
    IF OBJECT_ID('dbo.TUF_MasterCross', 'U') IS NOT NULL
        DROP TABLE dbo.TUF_MasterCross;

    -- Create the MasterCross table with fresh data
    WITH RankedCrosses AS (
        SELECT 
            TSPARTID,
            CrossName,
            CrossingNumber,
            ROW_NUMBER() OVER (PARTITION BY TSPARTID, CrossName ORDER BY CrossingNumber) AS rn
        FROM vw_TUF_Unpivoted_IntMaster_wMake
        WHERE CrossingNumber IS NOT NULL
    )
    SELECT *,
        UPPER(REPLACE(REPLACE(REPLACE(OEM, '-', ''), ' ', ''), '.', '')) AS OEM_Condensed
    INTO dbo.TUF_MasterCross
    FROM RankedCrosses
    PIVOT (
        MAX(CrossingNumber)
        FOR CrossName IN (
            [OEM], [SA], [Sachs], [MightyLift], [FCS], [Stabilus],
            [AC_Delco], [AMS], [Auger], [Bugiad], [Cofap], [Decar], [Delphi], [Destek], [DMA],
            [DT_Spare_Parts], [FA], [Febi], [Ferron], [Hans_Pries], [Helmer], [Johns], [Kilen],
            [Klaxcar], [Les], [Liftgate], [Lip], [MagMar], [Mapco], [Martas], [Meyle], [Monroe],
            [MonroeEUR], [Napa], [Optimal], [Orex], [Piston], [QH], [Sampa], [Sem_Plastik],
            [Stellox], [SYD], [Triscan], [TRW], [URO], [Veka], [Vierol]
        )
    ) AS Pivoted
    ORDER BY TSPARTID, rn;
END
