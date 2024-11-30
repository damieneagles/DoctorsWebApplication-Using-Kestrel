CREATE TABLE [dbo].[Fee] (
    [FeeId]        INT              IDENTITY (1, 1) NOT NULL,
    [DoctorFee]    MONEY            NOT NULL,
    [BulkBilled]   BIT              NOT NULL,
    [ModifiedDate] DATETIME         CONSTRAINT [DF_Fee_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]   NVARCHAR (256)   CONSTRAINT [DF_Fee_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]  DATETIME         CONSTRAINT [DF_Fee_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    NVARCHAR (256)   CONSTRAINT [DF_Fee_CreatedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER CONSTRAINT [DF_Fee_rowguid] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_Fee] PRIMARY KEY CLUSTERED ([FeeId] ASC)
);


GO
-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE     TRIGGER [dbo].[Update_Fee_Modified]
   ON  dbo.Fee
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[Fee] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE FeeId IN (SELECT  u.FeeId FROM inserted as u)
END
