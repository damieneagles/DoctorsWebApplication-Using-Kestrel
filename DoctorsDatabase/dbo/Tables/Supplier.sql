CREATE TABLE [dbo].[Supplier] (
    [SupplierId]   INT              IDENTITY (1, 1) NOT NULL,
    [SupplierName] NVARCHAR (250)   NOT NULL,
    [ModifiedDate] DATETIME         CONSTRAINT [DF_Supplier_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]   NVARCHAR (256)   CONSTRAINT [DF_Supplier_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]  DATETIME         CONSTRAINT [DF_Supplier_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    NVARCHAR (256)   CONSTRAINT [DF_Supplier_CreatedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER CONSTRAINT [DF_Supplier_rowguid] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED ([SupplierId] ASC)
);


GO
-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE     TRIGGER [dbo].[Update_Supplier_Modified]
   ON  dbo.Supplier
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[Supplier] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE SupplierId IN (SELECT  u.SupplierId FROM inserted as u)
END
