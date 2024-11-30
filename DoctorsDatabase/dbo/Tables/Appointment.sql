CREATE TABLE [dbo].[Appointment] (
    [AppointmentId]    INT              IDENTITY (1, 1) NOT NULL,
    [StartAppointment] DATETIME         NOT NULL,
    [EndAppointment]   DATETIME         NOT NULL,
    [DoctorId]         INT              NOT NULL,
    [PatientId]        INT              NOT NULL,
    [ModifiedDate]     DATETIME         CONSTRAINT [DF_Appointment_ModifiedDate] DEFAULT (getdate()) NOT NULL,
    [ModifiedBy]       NVARCHAR (256)   CONSTRAINT [DF_Appointment_ModifiedBy] DEFAULT (suser_name()) NOT NULL,
    [CreatedDate]      DATETIME         CONSTRAINT [DF_Appointment_CreatedDate] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]        NVARCHAR (256)   CONSTRAINT [DF_Appointment_CreatedBy] DEFAULT (suser_name()) NOT NULL,
    [rowguid]          UNIQUEIDENTIFIER CONSTRAINT [DF_Appointment_rowguid] DEFAULT (newid()) NOT NULL,
    [Room]             INT              NOT NULL,
    [Floor]            INT              NOT NULL,
    CONSTRAINT [PK_Appointment] PRIMARY KEY CLUSTERED ([AppointmentId] ASC),
    CONSTRAINT [FK_Appointment_Doctor] FOREIGN KEY ([DoctorId]) REFERENCES [dbo].[Doctor] ([DoctorId]),
    CONSTRAINT [FK_Appointment_Patient] FOREIGN KEY ([PatientId]) REFERENCES [dbo].[Patient] ([PatientId])
);




GO
-- =============================================
-- Author:		Damien Eagles
-- Create date: 22/4/2023
-- Description:	When the record is modified update the date and who did it.
-- =============================================
CREATE     TRIGGER [dbo].[Update_Appointment_Modified]
   ON  dbo.Appointment
   AFTER UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	-- Insert statements for trigger here
	UPDATE dbo.[Appointment] SET ModifiedDate = GETDATE(), ModifiedBy = SUSER_NAME()
	WHERE AppointmentId IN (SELECT  u.AppointmentId FROM inserted as u)
END
