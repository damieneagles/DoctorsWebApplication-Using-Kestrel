CREATE TABLE [dbo].[GPSurgery] (
    [GPSurgeryId]      INT              IDENTITY (1, 1) NOT NULL,
    [SurgeryName]      NVARCHAR (250)   NOT NULL,
    [StartConsultDate] DATETIME         NOT NULL,
    [EndConsultDate]   DATETIME         NOT NULL,
    [CurrentFlag]      BIT              NOT NULL,
    [ModifiedDate]     DATETIME         CONSTRAINT [DF_DoctorsSurgery_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]       NVARCHAR (256)   CONSTRAINT [DF_DoctorsSurgery_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]      DATETIME         CONSTRAINT [DF_DoctorsSurgery_CratdedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        NVARCHAR (256)   CONSTRAINT [DF_DoctorsSurgery_CratdedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER CONSTRAINT [DF_DoctorsSurgery_rowguid] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_DoctorsSurgery] PRIMARY KEY CLUSTERED ([GPSurgeryId] ASC)
);


GO
-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE     TRIGGER [dbo].[Update_GPSurgery_Modified]
   ON  dbo.GPSurgery
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[GPSurgery] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE GPSurgeryId IN (SELECT  u.GPSurgeryId FROM inserted as u)
END
