using System.Linq;
using System.Web.Mvc;
using MoviesExample.Core.Model;
using MoviesExample.Core.Interfaces.Service;
namespace MoviesExample.WebUI.Controllers
{    
    public partial class DirectorController : Controller
    {         
        protected IDirectorService DirectorService;
		
		
		public DirectorController(IDirectorService directorService)
        {
            this.DirectorService = directorService;
        }	        					
		
		public ActionResult Index()
        {            
            return View(this.DirectorService.GetAll().OrderBy(x => x.Name));            
        }		

		
		
		public ActionResult Details(int id)
        {
            var entity = this.DirectorService.GetById(id);
            return View(entity);
        }
		
		public ActionResult Delete(int id)
        {
            var entity = this.DirectorService.GetById(id);
            return View(entity);
        }

        [HttpPost, ActionName("Delete")]
        public ActionResult DeleteConfirmed(int id)
        {
            var entity = this.DirectorService.GetById(id);
            this.DirectorService.Delete(entity);
            return RedirectToAction("Index");
        }

        public ActionResult Create()
        {       
            return View();
        }

        /// <summary>
        /// Save a new entity
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        [HttpPost]
        public ActionResult Create(Director entity)
        {
            try
            {
				if(this.ModelState.IsValid){
                	this.DirectorService.SaveOrUpdate(entity);
                	return RedirectToAction("Index");
				}
				return View(entity);
            }
            catch
            {
			
                return View();
            }            
        }

        public ActionResult Edit(int id)
        {
            var entity = this.DirectorService.GetById(id);
            return View(entity);
        }

        [HttpPost]
        public ActionResult Edit(Director entity)
        {
            try
            {
				if(this.ModelState.IsValid){	                
                	this.DirectorService.SaveOrUpdate(entity);
                	return RedirectToAction("Index");
				}
				
				return View(entity);
            }
            catch
            {
			
                return View();
            }
        }               
    }
}
