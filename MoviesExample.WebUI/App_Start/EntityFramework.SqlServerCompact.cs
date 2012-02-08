using MoviesExample.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;

[assembly: WebActivator.PreApplicationStartMethod(typeof(MoviesExample.WebUI.App_Start.EntityFramework_SqlServerCompact), "Start")]

namespace MoviesExample.WebUI.App_Start
{
    public static class EntityFramework_SqlServerCompact
    {
        public static void Start()
        {
            Database.DefaultConnectionFactory = new SqlCeConnectionFactory("System.Data.SqlServerCe.4.0");
            Database.SetInitializer(new DropCreateDatabaseIfModelChanges<DataContext>());
        }
    }
}
