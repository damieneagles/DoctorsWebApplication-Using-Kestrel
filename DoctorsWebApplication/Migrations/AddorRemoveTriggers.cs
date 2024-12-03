using Microsoft.EntityFrameworkCore.Migrations;
using System.Text;

#nullable disable

namespace DoctorsWebApplication.Migrations
{
    /// <inheritdoc />
    public partial class AddorRemoveTriggers: Migration
    {
        private string GetFileBlock(string fileName)
        {
            string line = null;
            StringBuilder sb = new StringBuilder();

            //Pass the file path and file name to the StreamReader constructor
            StreamReader sr = new StreamReader(fileName);
            //Read the first line of text
            line = sr.ReadLine();
            //Continue to read until you reach end of file
            while (line != null)
            {
                //Read the next line
                line = sr.ReadLine();
                sb.AppendLine(line);
            }
            //close the file
            sr.Close();
            return sb.ToString();
        }

        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            //TRIGGERS need to be done using TSQL script
            string fileString = GetFileBlock("2023DoctorsDatabase_CREATEORALTERTriggers.sql");
            migrationBuilder.Sql(fileString);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            //DROP TRIGGERS on tables in the 2023DoctorsDatabase
            string fileString = GetFileBlock("2023DoctorsDatabase_DROPTriggers.sql");
            migrationBuilder.Sql(fileString);
        }

    }
}
