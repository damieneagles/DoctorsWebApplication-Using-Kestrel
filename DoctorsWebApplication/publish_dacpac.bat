ECHO Copying DACPAC...
IF NOT EXIST ..\DoctorsWebApplication\bin\release\net9.0 ( mkdir ..\DoctorsWebApplication\bin\release\net9.0 )
IF NOT EXIST ..\DoctorsWebApplication\bin\release\net9.0\publish ( mkdir ..\DoctorsWebApplication\bin\release\net9.0\publish )
copy /y ..\DoctorsDatabase\bin\release\doctorsdatabase.dacpac ..\DoctorsWebApplication\bin\release\net9.0
copy /y ..\DoctorsDatabase\bin\release\doctorsdatabase.dacpac ..\DoctorsWebApplication\bin\release\net9.0\publish
