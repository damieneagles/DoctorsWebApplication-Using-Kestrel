CREATE TABLE [dbo].[Drug] (
    [DrugId]          INT              IDENTITY (1, 1) NOT NULL,
    [CommonName]      NVARCHAR (250)   NOT NULL,
    [MedicalName]     NVARCHAR (250)   NOT NULL,
    [QuantityInStock] INT              NOT NULL,
    [ReorderQuantity] INT              NOT NULL,
    [ModifiedDate]    DATETIME         CONSTRAINT [DF_PrescribedDrug_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]      NVARCHAR (250)   CONSTRAINT [DF_PrescribedDrug_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]     DATETIME         CONSTRAINT [DF_PrescribedDrug_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       NVARCHAR (256)   CONSTRAINT [DF_PrescribedDrug_CreatedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]         UNIQUEIDENTIFIER CONSTRAINT [DF_PrescribedDrug_rowguid] DEFAULT (newid()) NOT NULL,
    [RetailPrice]     MONEY            NOT NULL,
    [WholeSalePrice]  MONEY            NOT NULL,
    CONSTRAINT [PK_PrescribedDrug] PRIMARY KEY CLUSTERED ([DrugId] ASC)
);


GO
-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE     TRIGGER [dbo].[Update_Drug_Modified]
   ON  dbo.Drug
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[Drug] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE DrugId IN (SELECT  u.DrugId FROM inserted as u)
END
