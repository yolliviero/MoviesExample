using System.Linq;
using System.Web.Mvc;
using MoviesExample.Core.Model;
using MoviesExample.Core.Interfaces.Service;
namespace MoviesExample.WebUI.Controllers
{    
    public partial class MovieController : Controller
    {         
        protected IMovieService MovieService;
		
		protected IDirectorService DirectorService;
				
		public MovieController(IMovieService movieService, IDirectorService directorService)
        {
            this.MovieService = movieService;
		this.DirectorService = directorService;
        }	        					
		
		public ActionResult Index()
        {            
            return View(this.MovieService.GetAll().OrderBy(x => x.Title));            
        }		

		public ActionResult MovieToDirector(int id)
        {
            var entities = this.MovieService.Find(p => p.DirectorId == id);
            return View("Index",entities);
        }
		
		
		public ActionResult Details(int id)
        {
			ViewBag.PossibleDirector = this.DirectorService.GetAll();
            var entity = this.MovieService.GetById(id);
            return View(entity);
        }
		
		public ActionResult Delete(int id)
        {
            var entity = this.MovieService.GetById(id);
            return View(entity);
        }

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            var entity = this.MovieService.GetById(id);
            this.MovieService.Delete(entity);
            return RedirectToAction("Index");
        }

        public ActionResult Create()
        {       
			ViewBag.PossibleDirector = this.DirectorService.GetAll();
            return View();
        }

        /// <summary>
        /// Save a new entity
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult Create(Movie entity)
        {
            try
            {
				if(this.ModelState.IsValid){
                	this.MovieService.SaveOrUpdate(entity);
                	return RedirectToAction("Index");
				}
			ViewBag.PossibleDirector = this.DirectorService.GetAll();
				return View(entity);
            }
            catch
            {
			ViewBag.PossibleDirector = this.DirectorService.GetAll();
			
                return View();
            }            
        }

        public ActionResult Edit(int id)
        {
			ViewBag.PossibleDirector = this.DirectorService.GetAll();
            var entity = this.MovieService.GetById(id);
            return View(entity);
        }

        [HttpPost]
        public ActionResult Edit(Movie entity)
        {
            try
            {
				if(this.ModelState.IsValid){	                
                	this.MovieService.SaveOrUpdate(entity);
                	return RedirectToAction("Index");
				}
			ViewBag.PossibleDirector = this.DirectorService.GetAll();
				
				return View(entity);
            }
            catch
            {
			ViewBag.PossibleDirector = this.DirectorService.GetAll();
			
                return View();
            }
        }               
    }
}
