CREATE TABLE [dbo].[Doctor] (
    [DoctorId]      INT              IDENTITY (1, 1) NOT NULL,
    [PersonId]      INT              NOT NULL,
    [Title]         NVARCHAR (250)   NOT NULL,
    [Abbreviations] NVARCHAR (250)   NOT NULL,
    [ModifiedDate]  DATETIME         CONSTRAINT [DF_Doctor_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]    NVARCHAR (256)   CONSTRAINT [DF_Doctor_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]   DATETIME         CONSTRAINT [DF_Doctor_CratdedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]     NVARCHAR (256)   CONSTRAINT [DF_Doctor_CradtedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_Doctor_rowguid] DEFAULT (newid()) NOT NULL,
    [GPSurgeryId]   INT              NOT NULL,
    CONSTRAINT [PK_Doctor_1] PRIMARY KEY CLUSTERED ([DoctorId] ASC),
    CONSTRAINT [FK_Doctor_GPSurgery] FOREIGN KEY ([GPSurgeryId]) REFERENCES [dbo].[GPSurgery] ([GPSurgeryId]),
    CONSTRAINT [FK_Doctor_Person] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Doctor]
    ON [dbo].[Doctor]([PersonId] ASC);


GO


-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE     TRIGGER [dbo].[Update_Doctor_Modified]
   ON  [dbo].[Doctor]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[Doctor] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE DoctorId IN (SELECT  u.DoctorId FROM inserted as u)
END
