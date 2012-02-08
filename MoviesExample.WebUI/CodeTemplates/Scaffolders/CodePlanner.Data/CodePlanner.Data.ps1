[T4Scaffolding.Scaffolder(Description = "Enter a description of CodePlanner.Data here")][CmdletBinding()]
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
$dataProjectName = $rootNamespace + ".Data"
#$dataProjectNamespace = (Get-Project $dataProjectName).Properties.Item("DefaultNamespace").Value

##############################################################
# Add Data Repository - BaseRepository
##############################################################
$outputPath = "BaseRepository"
$namespace = $dataProjectName
$ximports = $coreProjectName + ".Model," + $coreProjectName + ".Interfaces.Data"

Add-ProjectItemViaTemplate $outputPath -Template BaseRepository `
	-Model @{ Namespace = $namespace; ExtraUsings = $ximports } `
	-SuccessMessage "Added BaseRepository at {0}" `
	-TemplateFolders $TemplateFolders -Project $dataProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $dataProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# Add Data UOW - UnitOfWork
##############################################################
$outputPath = "UnitOfWork"
$namespace = $dataProjectName
$ximports = $coreProjectName + ".Model," + $coreProjectName + ".Interfaces.Data"

Add-ProjectItemViaTemplate $outputPath -Template UnitOfWork `
	-Model @{ Namespace = $namespace; ExtraUsings = $ximports } `
	-SuccessMessage "Added UnitOfWork at {0}" `
	-TemplateFolders $TemplateFolders -Project $dataProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $dataProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# Add Data DatabaseFactory - DatabaseFactory
##############################################################
$outputPath = "DatabaseFactory"
$namespace = $dataProjectName
$ximports = $coreProjectName + ".Interfaces.Data"

Add-ProjectItemViaTemplate $outputPath -Template DatabaseFactory `
	-Model @{ Namespace = $namespace; ExtraUsings = $ximports } `
	-SuccessMessage "Added DatabaseFactory at {0}" `
	-TemplateFolders $TemplateFolders -Project $dataProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $dataProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# Add Data DataContext - DataContext
##############################################################
$outputPath = "DataContext"
$namespace = $dataProjectName
$ximports = $coreProjectName + ".Model," + $coreProjectName + ".Interfaces.Data"

Add-ProjectItemViaTemplate $outputPath -Template DataContext `
	-Model @{ Namespace = $namespace; ExtraUsings = $ximports } `
	-SuccessMessage "Added DataContext at {0}" `
	-TemplateFolders $TemplateFolders -Project $dataProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $dataProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()