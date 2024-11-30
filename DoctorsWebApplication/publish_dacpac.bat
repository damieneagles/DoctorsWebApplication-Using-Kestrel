ECHO Copying DACPAC...
cd C:\[Solutions]\[2023DoctorsWebApplication]\DoctorsWebApplication - Using Kestrel
xcopy /e /y /-I DoctorsDatabase\bin\release\DoctorsDatabase.dacpac DoctorsWebApplication\bin\Release\net9.0\publish\DoctorsDatabase.dacpac

