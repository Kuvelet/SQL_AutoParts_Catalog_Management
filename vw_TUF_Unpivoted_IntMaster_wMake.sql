USE [CAN]
GO

/****** Object:  View [dbo].[vw_TUF_Unpivoted_IntMaster_wMake]    Script Date: 6/17/2025 4:36:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[vw_TUF_Unpivoted_IntMaster_wMake]
AS
    SELECT DISTINCT 
        Unpivoted.TSPARTID, 
        Unpivoted.CrossName, 
        Unpivoted.CrossingNumber, 
        TUF_IntMaster.Make
    FROM (
        SELECT DISTINCT 
            TSPARTID, 
            CrossName, 
            CrossingNumber
        FROM TUF_IntMaster
        UNPIVOT (
            CrossingNumber FOR CrossName IN (
                [OEM], [SA], [Sachs], [Mightylift], [FCS], [Stabilus], [Martas], [URO], [TRW], 
                [Monroe], [Napa], [QH], [Helmer], [Piston], [Kilen], [Optimal], [Meyle], [MagMar], 
                [Ferron], [Febi], [Lip], [AC_Delco], [Decar], [Liftgate], [Bugiad], [Triscan], 
                [Les], [FA], [Delphi], [Hans_Pries], [Vierol], [Mapco], [Destek], [Cofap], 
                [Air_Kraft], [Arnott], [MonroeEUR], [AMS], [Johns], [Klaxcar], [SYD], [DMA], 
                [Auger], [Sampa], [Sem_Plastik], [Stellox], [Orex], [DT_Spare_Parts], [Veka]
            )
        ) AS A
        WHERE CrossingNumber IS NOT NULL
    ) AS Unpivoted
    LEFT JOIN TUF_IntMaster 
        ON Unpivoted.CrossingNumber = TUF_IntMaster.OEM;
GO


