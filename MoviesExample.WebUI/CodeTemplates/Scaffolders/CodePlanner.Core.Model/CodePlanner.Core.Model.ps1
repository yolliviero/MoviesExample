[T4Scaffolding.Scaffolder(Description = "Enter a description of CodePlanner.Model here")][CmdletBinding()]
param(        
    [string]$Project,
	[string]$CodeLanguage,
	[string[]]$TemplateFolders,
	[switch]$Force = $false
)

##############################################################
# NAMESPACE
##############################################################
$namespace = (Get-Project $Project).Properties.Item("DefaultNamespace").Value
$rootNamespace = $namespace
$dotIX = $namespace.LastIndexOf('.')
if($dotIX -gt 0){
	$rootNamespace = $namespace.Substring(0,$namespace.LastIndexOf('.'))
}

##############################################################
# Project Name
##############################################################
$coreProjectName = $rootNamespace + ".Core"

##############################################################
# Add Model Entity - PersistentEntity
##############################################################
$outputPath = "Model\PersistentEntity"
$namespace = $coreProjectName + ".Model"

Add-ProjectItemViaTemplate $outputPath -Template PersistentEntity `
	-Model @{ Namespace = $namespace;  } `
	-SuccessMessage "Added PersistentEntity at {0}" `
	-TemplateFolders $TemplateFolders -Project $coreProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $coreProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()