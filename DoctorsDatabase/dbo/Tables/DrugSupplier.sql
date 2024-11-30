CREATE TABLE [dbo].[DrugSupplier] (
    [DrugSupplierId] INT              IDENTITY (1, 1) NOT NULL,
    [SupplierId]     INT              NOT NULL,
    [DrugId]         INT              NOT NULL,
    [RRP]            MONEY            NOT NULL,
    [WholeSalePrice] MONEY            NOT NULL,
    [ModifiedDate]   DATETIME         NOT NULL,
    [ModifiedBy]     NVARCHAR (256)   NOT NULL,
    [CreatedDate]    DATETIME         NOT NULL,
    [CreatedBy]      NVARCHAR (256)   NOT NULL,
    [rowguid]        UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT [PK_DrugSupplier] PRIMARY KEY CLUSTERED ([DrugSupplierId] ASC),
    CONSTRAINT [FK_DrugSupplier_Drug] FOREIGN KEY ([DrugId]) REFERENCES [dbo].[Drug] ([DrugId]),
    CONSTRAINT [FK_DrugSupplier_Supplier] FOREIGN KEY ([SupplierId]) REFERENCES [dbo].[Supplier] ([SupplierId])
);


GO
-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE     TRIGGER [dbo].[Update_DrugSupplier_Modified]
   ON  dbo.DrugSupplier
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[DrugSupplier] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE DrugSupplierId IN (SELECT  u.DrugSupplierId FROM inserted as u)
END
