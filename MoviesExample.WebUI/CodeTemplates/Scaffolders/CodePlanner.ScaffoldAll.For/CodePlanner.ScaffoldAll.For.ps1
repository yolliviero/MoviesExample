[T4Scaffolding.Scaffolder(Description = "Enter a description of CodePlanner.ScaffoldAll.For here")][CmdletBinding()]
param(        
	[parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][string]$ModelType,
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false
)

Scaffold CodePlanner.Data.Repository.For $ModelType
Scaffold CodePlanner.Services.For $ModelType
Scaffold CodePlanner.MVC.Controller.For $ModelType
Scaffold CodePlanner.MVC.Views.For $ModelType
#Write-Host "Register in App_Start\NinjectMVC3.cs" -ForegroundColor DarkRed
#Write-Host "kernel.Bind<I$($ModelType)Service>().To<$($ModelType)Service>().InRequestScope();" -ForegroundColor DarkGreen 
#Write-Host "kernel.Bind<I$($ModelType)Repository>().To<$($ModelType)Repository>().InRequestScope();" -ForegroundColor DarkGreen