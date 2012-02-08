[T4Scaffolding.Scaffolder(Description = "Enter a description of CodePlanner.ScaffoldAll here")][CmdletBinding()]
param(        
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false
)

$mvcProjectName = (Get-Project $Project).Properties.Item("DefaultNamespace").Value

$namespaces = $DTE.Documents | ForEach{$_.ProjectItem.FileCodeModel.CodeElements | Where-Object{$_.Kind -eq 5}}	
	
$classes = $namespaces | ForEach{$_.Children}

$StartPageEntities =  @()
	
$classes | ForEach{
	$current = $_
	$_.Bases | ForEach{
		if($_.Name -eq "PersistentEntity"){							
			Scaffold CodePlanner.ScaffoldAll.For $current.Name
			$StartPageEntities += $current.Name		
		}
	}		
}

$entities = $StartPageEntities -join ","
Write-Host $entities
Write-Host Creating new HomeView -ForegroundColor DarkGreen
Add-ProjectItemViaTemplate "Views\Home\Index" -Template HomeView `
	-Model @{ 	
	Entities = $entities; 	
	} `
	-SuccessMessage "Added HomeView at {0}" `
	-TemplateFolders $TemplateFolders -Project $mvcProjectName -CodeLanguage $CodeLanguage -Force:$Force

Write-Host Creating new HomeController -ForegroundColor DarkGreen
Add-ProjectItemViaTemplate "Controllers\HomeController" -Template HomeController `
	-Model @{ 	
	 	Namespace = $mvcProjectName; 
	} `
	-SuccessMessage "Added HomeController at {0}" `
	-TemplateFolders $TemplateFolders -Project $mvcProjectName -CodeLanguage $CodeLanguage -Force:$Force

