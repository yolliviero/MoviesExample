[T4Scaffolding.Scaffolder(Description = "Enter a description of CodePlanner.Data.Repository.For here")][CmdletBinding()]
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
$dataProjectName = $rootNamespace + ".Data"
$dataProject = Get-Project $dataProjectName

##############################################################
# Add Data Repository - ModelType
##############################################################
$outputPath = $ModelType + "Repository"
$namespace = $dataProjectName
$ximports = $coreProjectName + ".Model," + $coreProjectName + ".Interfaces.Data"

Add-ProjectItemViaTemplate $outputPath -Template Repository `
	-Model @{ Namespace = $namespace; ClassName = $ModelType; ExtraUsings = $ximports } `
	-SuccessMessage "Added Repository at {0}" `
	-TemplateFolders $TemplateFolders -Project $dataProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $dataProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# create repository interface for modeltype
##############################################################
$outputPath = "Interfaces\Data\I" + $ModelType + "Repository"
$namespace = $coreProjectName + ".Interfaces.Data"
$ximports = $coreProjectName + ".Model"

Add-ProjectItemViaTemplate $outputPath -Template IRepository `
	-Model @{ Namespace = $namespace; ClassName = $ModelType; ExtraUsings = $ximports } `
	-SuccessMessage "Added IRepository of $ModelType output at {0}" `
	-TemplateFolders $TemplateFolders -Project $coreProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $coreProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# Register the entity in the DbContext
##############################################################
$pluralName = Get-PluralizedWord $ModelType

$class = Get-ProjectType "DataContext" -Project $dataProjectName
$propertyToAdd = "public DbSet<" + $ModelType + "> " + $pluralName + "{ get; set; }"
$projPath = $dataProject.FullName.Replace($dataProjectName + '.csproj', 'DataContext.cs')
$checkForThis = "public DbSet<" + $ModelType + ">"
$propExists = $false
$file = $projPath
Get-Content $file | foreach-Object {  if($_.Contains($checkForThis)){ $propExists = $true }
}

if(!$propExists){	Add-ClassMember $class $propertyToAdd	}

$file = Get-ProjectItem "DataContext.cs" -Project $dataProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()

##############################################################
# Register the repsoitory to ninject
##############################################################
Write-Host Registering service I$($ModelType)Repository to ninject  -ForegroundColor DarkGreen
Add-CodeToMethod (Get-Project $Project).Name "\App_Start\" "NinjectMVC3.cs" "NinjectMVC3" "RegisterServices" "kernel.Bind<I$($ModelType)Repository>().To<$($ModelType)Repository>().InRequestScope();"