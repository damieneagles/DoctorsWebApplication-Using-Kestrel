CREATE TABLE [dbo].[Patient] (
    [PatientId]    INT              IDENTITY (1, 1) NOT NULL,
    [PersonId]     INT              NOT NULL,
    [TagId]        NVARCHAR (50)    NOT NULL,
    [Room]         INT              NOT NULL,
    [Floor]        INT              NOT NULL,
    [DoctorId]     INT              NOT NULL,
    [ModifiedDate] DATETIME         CONSTRAINT [DF_Patient_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]   NVARCHAR (256)   CONSTRAINT [DF_Patient_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]  DATETIME         CONSTRAINT [DF_Patient_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    NVARCHAR (256)   CONSTRAINT [DF_Patient_CreatedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER CONSTRAINT [DF_Patient_rowguid] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_Patient_1] PRIMARY KEY CLUSTERED ([PatientId] ASC),
    CONSTRAINT [FK_Patient_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [dbo].[Doctor] ([DoctorId]),
    CONSTRAINT [FK_Patient_Person] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
);




GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Patient]
    ON [dbo].[Patient]([PersonId] ASC);


GO


-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE     TRIGGER [dbo].[Update_Patient_Modified]
   ON  [dbo].[Patient]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[Patient] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE PatientId IN (SELECT  u.PatientId FROM inserted as u)
END
