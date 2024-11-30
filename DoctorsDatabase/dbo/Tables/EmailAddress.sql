CREATE TABLE [dbo].[EmailAddress] (
    [EmailAddressId] INT              IDENTITY (1, 1) NOT NULL,
    [EmailAddress]   NVARCHAR (250)   NOT NULL,
    [PersonId]       INT              NOT NULL,
    [ModifiedDate]   DATETIME         CONSTRAINT [DF_EmailAddress_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]     NVARCHAR (256)   CONSTRAINT [DF_EmailAddress_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]    DATETIME         CONSTRAINT [DF_EmailAddress_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]      NVARCHAR (256)   CONSTRAINT [DF_EmailAddress_CreatedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]        UNIQUEIDENTIFIER CONSTRAINT [DF_EmailAddress_rowguid] DEFAULT (newid()) NOT NULL,
    CONSTRAINT [PK_EmailAddress] PRIMARY KEY CLUSTERED ([EmailAddressId] ASC),
    CONSTRAINT [FK_EmailAddress_Person] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
);


GO

-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE   TRIGGER [dbo].[Update_EmailAddress_Modified]
   ON  [dbo].[EmailAddress]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[EmailAddress] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE EmailAddressId IN (SELECT  u.EmailAddressId FROM inserted as u)
END
