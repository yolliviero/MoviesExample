[T4Scaffolding.Scaffolder(Description = "Enter a description of CodePlanner.MVC.Controller.For here")][CmdletBinding()]
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
$mvcProjectName = $namespace
$serviceProjectName = $rootNamespace + ".Service"

##############################################################
# Create the controller in the MvcApp
##############################################################
# Ensure we have a controller name, plus a model type if specified
$foundModelType = Get-ProjectType $ModelType -Project $coreProjectName
if (!$foundModelType) { return }
$primaryKeyName = [string](Get-PrimaryKey $foundModelType.FullName -Project $coreProjectName)

# Get the related entities
if ($foundModelType) { $classRelations = [Array](Get-RelatedEntities $ModelType -Project $coreProjectName) }
if (!$classRelations ) { $classRelations = @() }

$outputPath = "Controllers\" + $ModelType + "Controller"
$ximports = $coreProjectName + ".Model," + $coreProjectName + ".Interfaces.Service" 
$pluralname = Get-PluralizedWord $foundModelType.Name

Write-Host Creating new $($ModelType)Controller -ForegroundColor DarkGreen
Add-ProjectItemViaTemplate $outputPath -Template Controller `
	-Model @{ 	
	Namespace = $mvcProjectName; 
	PrimaryKeyName = $primaryKeyName; 
	DataType = [MarshalByRefObject]$foundModelType;	
	DataTypeName = $foundModelType.Name; 
	RelatedEntities = $classRelations;
	ExtraUsings = $ximports;
	PluralName = $pluralname;
	} `
	-SuccessMessage "Added Controller of $ModelType output at {0}" `
	-TemplateFolders $TemplateFolders -Project $mvcProjectName -CodeLanguage $CodeLanguage -Force:$Force

$file = Get-ProjectItem "$($outputPath).cs" -Project $mvcProjectName
$file.Open()
$file.Document.Activate()
$DTE.ActiveDocument.Save()