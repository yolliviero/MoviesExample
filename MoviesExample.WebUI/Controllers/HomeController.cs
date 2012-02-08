using System.Web.Mvc;
namespace MoviesExample.WebUI.Controllers
{    
    public partial class HomeController : Controller
    {                 
		public ActionResult Index()
        {            
            return View();            
        }		
	}
}