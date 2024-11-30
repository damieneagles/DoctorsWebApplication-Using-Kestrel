CREATE TABLE [dbo].[PhoneNumber] (
    [PhoneNumberId] INT              IDENTITY (1, 1) NOT NULL,
    [PhoneNumber]   NVARCHAR (50)    NOT NULL,
    [PersonId]      INT              NOT NULL,
    [rowguid]       UNIQUEIDENTIFIER CONSTRAINT [DF_PhoneNumber_rowguid] DEFAULT (newid()) NOT NULL,
    [ModifiedDate]  DATETIME         CONSTRAINT [DF_PhoneNumber_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]    NVARCHAR (256)   CONSTRAINT [DF_PhoneNumber_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreateDate]    DATETIME         CONSTRAINT [DF_PhoneNumber_CreateDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]     NVARCHAR (256)   CONSTRAINT [DF_PhoneNumber_CreatedBy] DEFAULT (suser_name()) NOT NULL,
    CONSTRAINT [PK_PhoneNumber] PRIMARY KEY CLUSTERED ([PhoneNumberId] ASC),
    CONSTRAINT [FK_PhoneNumber_Person] FOREIGN KEY ([PersonId]) REFERENCES [dbo].[Person] ([PersonId])
);


GO

-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE   TRIGGER [dbo].[Update_PhoneNumber_Modified]
   ON  [dbo].[PhoneNumber]
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[PhoneNumber] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE PhoneNumberId IN (SELECT  u.PhoneNumberId FROM inserted as u)
END
