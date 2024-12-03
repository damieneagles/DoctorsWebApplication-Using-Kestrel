ECHO Copying DACPAC...
IF NOT EXIST $(SolutionDir)DoctorsWebApplication\bin\$(Configuration)\net9.0 ( mkdir $(SolutionDir)DoctorsWebApplication\bin\$(Configuration)\net9.0 )
IF NOT EXIST $(SolutionDir)DoctorsWebApplication\bin\$(Configuration)\net9.0\publish ( mkdir $(SolutionDir)DoctorsWebApplication\bin\$(Configuration)\net9.0\publish )
copy /y $(SolutionDir)DoctorsDatabase\bin\$(Configuration)\doctorsdatabase.dacpac $(SolutionDir)DoctorsWebApplication\bin\$(Configuration)\net9.0
copy /y $(SolutionDir)DoctorsDatabase\bin\$(Configuration)\doctorsdatabase.dacpac $(SolutionDir)DoctorsWebApplication\bin\$(Configuration)\net9.0\publish

