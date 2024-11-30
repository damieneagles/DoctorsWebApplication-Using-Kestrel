////////////////////////////////////////////////////////////////////////////////////////////////////////
///
/// Written by [Damien Wallace Eagles] @ MyWorkBench
///
////////////////////////////////////////////////////////////////////////////////////////////////////////
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Authentication.Negotiate;
using DoctorsWebApplication.Data;
using Microsoft.SqlServer.Dac;
using Microsoft.SqlServer.Dac.Model;
using Microsoft.AspNetCore.Hosting;
using System.Diagnostics;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using System.Net;

namespace DoctorsWebApplication
{

    public partial class Program
    {
        public static void Main(string[] args)
        {
            //host console
            CreateHostBuilder(args).Build().Run();
        }

        // EF Core uses this method at design time to access the DbContext
        public static IHostBuilder CreateHostBuilder(string[] args)
            => Host.CreateDefaultBuilder(args).ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseContentRoot(Directory.GetCurrentDirectory());
                    webBuilder.UseKestrel();
                    webBuilder.UseStartup<StartUp>();
                    webBuilder.UseUrls();

                }).ConfigureServices((context, services) =>
                {
                    //services.AddHostedService<MyWCFService>();
                });
    }

    public class StartUp
    {
        public StartUp(IConfiguration configuration)
        {
            Configuration = configuration;
        }

#pragma warning disable CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider adding the 'required' modifier or declaring as nullable.
        public static IConfiguration Configuration { get; private set; }
#pragma warning restore CS8618 // Non-nullable field must contain a non-null value when exiting constructor. Consider adding the 'required' modifier or declaring as nullable.

        // This method gets called by the runtime. Use this method to add services to the container.
        public static void ConfigureServices(IServiceCollection services)
        {
            var connectionString = Configuration.GetConnectionString("2023DoctorsDatabaseDefault");

            // Add DbContext to the injection container
            services.AddDbContext<DoctorsDatabase2023Context>(options =>
                        options.UseSqlServer(connectionString));


        }

        #region Make sure the SQL Server database exists using DACPAC if necessary

        public static void MakeSureSQLServerDatabaseExists(bool isProduction, bool canConnect)
        {
            //Sort out database connectivity...
            var connectionString = Configuration.GetConnectionString("2023DoctorsDatabaseDefault") ?? throw new InvalidOperationException("Connection string '2023DoctorsDatabaseDefault' not found.");
            var svc = new DacServices(connectionString);
            string dacpacPath;

            if (isProduction)
            {
                //When published use same directory
                dacpacPath = ".\\DoctorsDatabase.dacpac";
            }
            else
            {
                //When run in IDE in debug use SQL Server Database Project output folder
                dacpacPath = "..\\DoctorsDatabase\\bin\\release\\DoctorsDatabase.dacpac";
            }

            var dacOptions = new DacDeployOptions
            {
                BackupDatabaseBeforeChanges = true,
                CreateNewDatabase = true
            };

            if (!canConnect)
            {
                svc.Deploy(
                    DacPackage.Load(dacpacPath),
                    targetDatabaseName: "aspnet-53bc9b9d-9d6a-45d4-8429-2a2761773502",
                    upgradeExisting: true,
                    options: dacOptions
                    );
            }
        }

        #endregion

        public static void Configure(IApplicationBuilder app, IWebHostEnvironment env, DoctorsDatabase2023Context context)
        {
            var connectionString = Configuration.GetConnectionString("2023DoctorsDatabaseDefault");

            var appBuilder = WebApplication.CreateBuilder();

            //SQL Server database needs to exist.. if not install DACPAC
            MakeSureSQLServerDatabaseExists(env.IsProduction(), context.Database.CanConnect());

            //DI for the local DbContext
            appBuilder.Services.AddDbContext<DoctorsDatabase2023Context>(options => options.UseSqlServer(connectionString));

            //Show message friendly pages on database exceptions
            appBuilder.Services.AddDatabaseDeveloperPageExceptionFilter();

            appBuilder.Services.AddControllersWithViews().AddRazorRuntimeCompilation();

            //Windows Authentication...
            appBuilder.Services.AddAuthentication(NegotiateDefaults.AuthenticationScheme).AddNegotiate();

            appBuilder.Services.AddAuthorization(options =>
            {
                // By default, all incoming requests will be authorized according to the default policy.
                options.FallbackPolicy = options.DefaultPolicy;
            });

            appBuilder.Services.AddRazorPages();

            //Server farm considerations...
            appBuilder.Services.AddDistributedMemoryCache();

            //Run up the web application...
            var App = appBuilder.Build();

            if (App.Environment.IsDevelopment())
            {
                App.UseMigrationsEndPoint();
                App.UseDeveloperExceptionPage();
            }
            else
            {
                App.UseExceptionHandler("/Error");
                App.UseHsts();
            }

            App.UseStaticFiles();
            App.UseRouting();
            App.UseAuthorization();
            App.MapControllerRoute(
                name: "default",
                pattern: "{controller=Home}/{action=Index}/{id?}");

            App.Run();
        }
    }
}
