[T4Scaffolding.Scaffolder(Description = "CodePlanner.Interfaces - Adds the generic interfaces for data and services")][CmdletBinding()]
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
# Add Data Interface - IRepository
##############################################################
$outputPath = "Interfaces\Data\IRepository"
$namespace = $coreProjectName + ".Interfaces.Data"

Add-ProjectItemViaTemplate $outputPath -Template IRepository `
	-Model @{ Namespace = $namespace; } `
	-SuccessMessage "Added IRepository at {0}" `
	-TemplateFolders $TemplateFolders -Project $coreProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $coreProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# Add Data Interface - IUnitOfWork
##############################################################
$outputPath = "Interfaces\Data\IUnitOfWork"
$namespace = $coreProjectName + ".Interfaces.Data"

Add-ProjectItemViaTemplate $outputPath -Template IUnitOfWork `
	-Model @{ Namespace = $namespace; } `
	-SuccessMessage "Added IUnitOfWork at {0}" `
	-TemplateFolders $TemplateFolders -Project $coreProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $coreProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# Add Data Interface - IDatabaseFactory
##############################################################
$outputPath = "Interfaces\Data\IDatabaseFactory"
$namespace = $coreProjectName + ".Interfaces.Data"

Add-ProjectItemViaTemplate $outputPath -Template IDatabaseFactory `
	-Model @{ Namespace = $namespace; } `
	-SuccessMessage "Added IDatabaseFactory at {0}" `
	-TemplateFolders $TemplateFolders -Project $coreProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $coreProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# Add Data Interface - IDataContext
##############################################################
$outputPath = "Interfaces\Data\IDataContext"
$namespace = $coreProjectName + ".Interfaces.Data"
$ximports = $coreProjectName + ".Model"

Add-ProjectItemViaTemplate $outputPath -Template IDataContext `
	-Model @{ Namespace = $namespace; ExtraUsings = $ximports} `
	-SuccessMessage "Added IDataContext at {0}" `
	-TemplateFolders $TemplateFolders -Project $coreProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $coreProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# Add Service Interface - IService
##############################################################
$outputPath = "Interfaces\Service\IService"
$namespace = $coreProjectName + ".Interfaces.Service"

Add-ProjectItemViaTemplate $outputPath -Template IService `
	-Model @{ Namespace = $namespace; } `
	-SuccessMessage "Added IService at {0}" `
	-TemplateFolders $TemplateFolders -Project $coreProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $coreProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()