CREATE TABLE [dbo].[DoctorFee] (
    [DoctorFeeId]  INT              IDENTITY (1, 1) NOT NULL,
    [FeeId]        INT              NOT NULL,
    [DoctorId]     INT              NOT NULL,
    [ModifiedDate] DATETIME         CONSTRAINT [DF_DoctorFee_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]   NVARCHAR (256)   CONSTRAINT [DF_DoctorFee_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]  DATETIME         CONSTRAINT [DF_DoctorFee_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    NVARCHAR (256)   CONSTRAINT [DF_DoctorFee_CreatedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER CONSTRAINT [DF_DoctorFee_rowguid] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_DoctorFee] PRIMARY KEY CLUSTERED ([DoctorFeeId] ASC),
    CONSTRAINT [FK_DoctorFee_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [dbo].[Doctor] ([DoctorId]),
    CONSTRAINT [FK_DoctorFee_Fee] FOREIGN KEY ([FeeId]) REFERENCES [dbo].[Fee] ([FeeId])
);




GO
-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE     TRIGGER [dbo].[Update_DoctorFee_Modified]
   ON  dbo.DoctorFee
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[DoctorFee] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE DoctorFeeId IN (SELECT  u.DoctorFeeId FROM inserted as u)
END
