CREATE TABLE [dbo].[Person] (
    [PersonId]     INT              IDENTITY (1, 1) NOT NULL,
    [FirstName]    NVARCHAR (250)   NOT NULL,
    [MiddleName]   NVARCHAR (250)   NULL,
    [LastName]     NVARCHAR (250)   NOT NULL,
    [rowguid]      UNIQUEIDENTIFIER CONSTRAINT [DF_Person_rowguid] DEFAULT (newid()) NOT NULL,
    [ModifiedDate] DATETIME         CONSTRAINT [DF_Person_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]   NVARCHAR (256)   CONSTRAINT [DF_Person_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]  DATETIME         CONSTRAINT [DF_Person_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    NVARCHAR (256)   CONSTRAINT [DF_Person_CreatedBy] DEFAULT (suser_name()) NOT NULL,
    [DateOfBirth]  DATETIME         NOT NULL,
    CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED ([PersonId] ASC)
);


GO
-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE   TRIGGER [dbo].[Update_Person_Modified]
   ON  dbo.Person
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[Person] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE PersonId IN (SELECT  u.PersonId FROM inserted as u)
END
