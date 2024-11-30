CREATE TABLE [dbo].[Address] (
    [AddressId]    INT              IDENTITY (1, 1) NOT NULL,
    [PersonId]     INT              NOT NULL,
    [AddressLine1] NVARCHAR (250)   NOT NULL,
    [AddressLine2] NVARCHAR (250)   NULL,
    [State]        NVARCHAR (250)   NOT NULL,
    [PostCode]     NVARCHAR (50)    NOT NULL,
    [City]         NVARCHAR (50)    NULL,
    [Country]      NVARCHAR (50)    NOT NULL,
    [ModifiedDate] DATETIME         CONSTRAINT [DF_Address_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]   NVARCHAR (250)   CONSTRAINT [DF_Address_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]  DATETIME         CONSTRAINT [DF_Address_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    NVARCHAR (250)   CONSTRAINT [DF_Address_CreatedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER CONSTRAINT [DF_Address_rowguid] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_Address] PRIMARY KEY CLUSTERED ([AddressId] ASC),
    CONSTRAINT [FK_Address_Person] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
);


GO

-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE   TRIGGER [dbo].[Update_Address_Modified]
   ON  [dbo].[Address]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[Address] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE AddressId IN (SELECT  u.AddressId FROM inserted as u)
END
