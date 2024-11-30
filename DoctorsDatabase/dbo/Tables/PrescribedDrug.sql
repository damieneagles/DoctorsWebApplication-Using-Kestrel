CREATE TABLE [dbo].[PrescribedDrug] (
    [PrescribedDrugId] INT              IDENTITY (1, 1) NOT NULL,
    [DrugId]           INT              NOT NULL,
    [PatientId]        INT              NOT NULL,
    [DoctorId]         INT              NOT NULL,
    [ModifiedDate]     DATETIME         NOT NULL,
    [ModifiedBy]       NVARCHAR (256)   NOT NULL,
    [CreatedDate]      DATETIME         NOT NULL,
    [CreatedBy]        NVARCHAR (256)   NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_PrescribedDrug_1] PRIMARY KEY CLUSTERED ([PrescribedDrugId] ASC),
    CONSTRAINT [FK_PrescribedDrug_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [dbo].[Doctor] ([DoctorId]),
    CONSTRAINT [FK_PrescribedDrug_Drug] FOREIGN KEY ([DrugId]) REFERENCES [dbo].[Drug] ([DrugId]),
    CONSTRAINT [FK_PrescribedDrug_Patient] FOREIGN KEY ([PatientId]) REFERENCES [dbo].[Patient] ([PatientId])
);


GO
-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE     TRIGGER [dbo].[Update_PrescribedDrug_Modified]
   ON  dbo.PrescribedDrug
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[PrescribedDrug] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE PrescribedDrugId IN (SELECT  u.PrescribedDrugId FROM inserted as u)
END
