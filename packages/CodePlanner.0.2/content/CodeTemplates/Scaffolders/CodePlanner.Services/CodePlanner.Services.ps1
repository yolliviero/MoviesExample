[T4Scaffolding.Scaffolder(Description = "Enter a description of CodePlanner.Services here")][CmdletBinding()]
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
$serviceProjectName = $rootNamespace + ".Service"

##############################################################
# Add Service Service - BaseService
##############################################################
$outputPath = "BaseService"
$namespace = $serviceProjectName
$ximports = $coreProjectName + ".Model," + $coreProjectName + ".Interfaces.Data," + $coreProjectName + ".Interfaces.Service"

Add-ProjectItemViaTemplate $outputPath -Template BaseService `
	-Model @{ Namespace = $namespace; ExtraUsings = $ximports } `
	-SuccessMessage "Added BaseService at {0}" `
	-TemplateFolders $TemplateFolders -Project $serviceProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $serviceProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()