USE [CAN]
GO
/****** Object:  StoredProcedure [dbo].[sp_TUF_Create_BuyersGuide]    Script Date: 6/17/2025 4:37:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[sp_TUF_Create_BuyersGuide]
AS
BEGIN

    -- Check if table exists and drop it if necessary
    IF OBJECT_ID('dbo.TUF_BuyersGuide', 'U') IS NOT NULL
        DROP TABLE dbo.TUF_BuyersGuide;

    -- Create new TS_BuyersGuide table
    SELECT
        b.TSPARTID,
        b.Application,
        b.MinYear,
        b.BodyType,
        b.PartTerminology,
        b.Position,
        b.Notes,
        b.QuantityNeeded,
        p.OEM AS OEM_Cond,
        p.SA,
        p.Sachs,
        p.Mightylift,
        p.FCS,
        p.Stabilus
    INTO dbo.TUF_BuyersGuide
    FROM vw_TUF_BuyersGuide_All_woCross AS b
    LEFT JOIN vw_TUF_Pivoted_IntMaster_Cond_Aggregated AS p
        ON b.TSPARTID = p.TSPARTID;

END