CREATE TABLE [dbo].[AppointmentPayment] (
    [AppointmentPaymentId] INT              IDENTITY (1, 1) NOT NULL,
    [AppointmentId]        INT              NOT NULL,
    [DoctorFeeId]          INT              NOT NULL,
    [ModifiedDate]         DATETIME         CONSTRAINT [DF_AppointmentPayment_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]           NVARCHAR (256)   CONSTRAINT [DF_AppointmentPayment_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]          DATETIME         CONSTRAINT [DF_AppointmentPayment_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]            NVARCHAR (256)   CONSTRAINT [DF_Table_1_CradtedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]              UNIQUEIDENTIFIER CONSTRAINT [DF_AppointmentPayment_rowguid] DEFAULT (newid()) NOT NULL,
    [PaymentDate]          DATETIME         NOT NULL,
    CONSTRAINT [PK_AppointmentPayment] PRIMARY KEY CLUSTERED ([AppointmentPaymentId] ASC),
    CONSTRAINT [FK_AppointmentPayment_Appointment] FOREIGN KEY ([AppointmentId]) REFERENCES [dbo].[Appointment] ([AppointmentId]),
    CONSTRAINT [FK_AppointmentPayment_DoctorFee] FOREIGN KEY ([DoctorFeeId]) REFERENCES [dbo].[DoctorFee] ([DoctorFeeId])
);


GO
-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE       TRIGGER [dbo].[Update_AppointmentPayment_Modified]
   ON  dbo.AppointmentPayment
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[AppointmentPayment] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE AppointmentPaymentId IN (SELECT  u.AppointmentPaymentId FROM inserted as u)
END
