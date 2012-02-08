using MoviesExample.Core.Interfaces.Service;
using MoviesExample.Core.Interfaces.Data;
using MoviesExample.Service;
using MoviesExample.Data;
[assembly: WebActivator.PreApplicationStartMethod(typeof(MoviesExample.WebUI.App_Start.NinjectMVC3), "Start")]
[assembly: WebActivator.ApplicationShutdownMethodAttribute(typeof(MoviesExample.WebUI.App_Start.NinjectMVC3), "Stop")]

namespace MoviesExample.WebUI.App_Start
{
    using System.Reflection;
    using Microsoft.Web.Infrastructure.DynamicModuleHelper;
    using Ninject;
    using Ninject.Web.Mvc;

    public static class NinjectMVC3
    {
        private static readonly Bootstrapper bootstrapper = new Bootstrapper();

        /// <summary>
        /// Starts the application
        /// </summary>
        public static void Start()
        {
            DynamicModuleUtility.RegisterModule(typeof(OnePerRequestModule));
            DynamicModuleUtility.RegisterModule(typeof(HttpApplicationInitializationModule));
            bootstrapper.Initialize(CreateKernel);
        }

        /// <summary>
        /// Stops the application.
        /// </summary>
        public static void Stop()
        {
            bootstrapper.ShutDown();
        }

        /// <summary>
        /// Creates the kernel that will manage your application.
        /// </summary>
        /// <returns>The created kernel.</returns>
        private static IKernel CreateKernel()
        {
            var kernel = new StandardKernel();
            RegisterServices(kernel);
            return kernel;
        }

        /// <summary>
        /// Load your modules or register your services here!
        /// </summary>
        /// <param name="kernel">The kernel.</param>
        private static void RegisterServices(IKernel kernel)
        {
            kernel.Bind<IDatabaseFactory>().To<DatabaseFactory>().InRequestScope();
            kernel.Bind<IUnitOfWork>().To<UnitOfWork>().InRequestScope();
            kernel.Bind<IDirectorRepository>().To<DirectorRepository>().InRequestScope();
            kernel.Bind<IDirectorService>().To<DirectorService>().InRequestScope();
            kernel.Bind<IMovieRepository>().To<MovieRepository>().InRequestScope();
            kernel.Bind<IMovieService>().To<MovieService>().InRequestScope();
        }
    }
}
