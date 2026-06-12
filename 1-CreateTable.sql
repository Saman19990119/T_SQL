/****** Object:  StoredProcedure [dbo].[SP_CreateTable]    Script Date: 6/12/2026 2:25:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create proc [dbo].[SP_CreateTable]
as 
begin
IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = 'Calendars' AND schema_id = SCHEMA_ID('dbo'))
    BEGIN
        CREATE TABLE [dbo].[Calendars](
            [Date_ID] [bigint] IDENTITY(1,1) NOT NULL,
            [Shamsi] [varchar](10) NOT NULL,
            [Miladi] [date] NOT NULL,
            CONSTRAINT [PK_Calendars] PRIMARY KEY CLUSTERED 
        ([Date_ID] ASC)
        WITH    (PAD_INDEX = OFF,
                STATISTICS_NORECOMPUTE = OFF,
                IGNORE_DUP_KEY = OFF,
                ALLOW_ROW_LOCKS = ON,
                ALLOW_PAGE_LOCKS = ON,
                OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]) ON [PRIMARY];
    END
    ELSE
        RAISERROR('Table dbo.Calendars already exists.', 16, 1);

    end
GO


