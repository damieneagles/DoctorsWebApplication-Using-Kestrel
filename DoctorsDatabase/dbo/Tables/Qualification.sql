CREATE TABLE [dbo].[Qualification] (
    [QualificationId] INT              IDENTITY (1, 1) NOT NULL,
    [Qualification]   NVARCHAR (250)   NOT NULL,
    [Specialisation]  NVARCHAR (250)   NOT NULL,
    [Institution]     NVARCHAR (250)   NOT NULL,
    [ModifiedDate]    DATETIME         CONSTRAINT [DF_Qualification_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]      NVARCHAR (256)   CONSTRAINT [DF_Qualification_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]     DATETIME         CONSTRAINT [DF_Qualification_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       NVARCHAR (256)   CONSTRAINT [DF_Qualification_CreatedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]         UNIQUEIDENTIFIER CONSTRAINT [DF_Qualification_rowguid] DEFAULT (newid()) NOT NULL,
    [DoctorId]        INT              NOT NULL,
    CONSTRAINT [PK_Qualification] PRIMARY KEY CLUSTERED ([QualificationId] ASC),
    CONSTRAINT [FK_Qualification_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [dbo].[Doctor] ([DoctorId])
);






GO


-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE     TRIGGER [dbo].[Update_Qualification_Modified]
   ON  [dbo].[Qualification]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[Qualification] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE QualificationId IN (SELECT  u.QualificationId FROM inserted as u)
END
