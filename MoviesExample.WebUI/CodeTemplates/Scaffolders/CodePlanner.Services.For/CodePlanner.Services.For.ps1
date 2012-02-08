[T4Scaffolding.Scaffolder(Description = "Enter a description of CodePlanner.Services.For here")][CmdletBinding()]
param(   
	[parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)][string]$ModelType,     
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
$serviceProjectName = $rootNamespace + ".Service"

##############################################################
# Add Service - ModelType
##############################################################
$outputPath = $ModelType + "Service"
$namespace = $serviceProjectName
$ximports = $coreProjectName + ".Model," + $coreProjectName + ".Interfaces.Service," + $coreProjectName + ".Interfaces.Data"

Add-ProjectItemViaTemplate $outputPath -Template Service `
	-Model @{ Namespace = $namespace; ClassName = $ModelType; ExtraUsings = $ximports } `
	-SuccessMessage "Added Service at {0}" `
	-TemplateFolders $TemplateFolders -Project $serviceProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $serviceProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# create service interface for modeltype
##############################################################
$outputPath = "Interfaces\Service\I" + $ModelType + "Service"
$namespace = $coreProjectName + ".Interfaces.Service"
$ximports = $coreProjectName + ".Model"

Add-ProjectItemViaTemplate $outputPath -Template IService `
	-Model @{ Namespace = $namespace; ClassName = $ModelType; ExtraUsings = $ximports } `
	-SuccessMessage "Added IService of $ModelType output at {0}" `
	-TemplateFolders $TemplateFolders -Project $coreProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $coreProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# register the service to ninject
##############################################################
Write-Host Registering service I$($ModelType)Service to ninject  -ForegroundColor DarkGreen
Add-CodeToMethod (Get-Project $Project).Name "\App_Start\" "NinjectMVC3.cs" "NinjectMVC3" "RegisterServices" "kernel.Bind<I$($ModelType)Service>().To<$($ModelType)Service>().InRequestScope();"