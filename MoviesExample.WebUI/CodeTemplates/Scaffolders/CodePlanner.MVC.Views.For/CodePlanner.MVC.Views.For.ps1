[T4Scaffolding.Scaffolder(Description = "Enter a description of CodePlanner.MVC.Views.For here")][CmdletBinding()]
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
$mvcProjectName = $namespace
$coreProjectName = $rootNamespace + ".Core"

##############################################################
# Info about ModelType
##############################################################
$foundModelType = Get-ProjectType $ModelType -Project $coreProjectName
if (!$foundModelType) { return }
$primaryKeyName = [string](Get-PrimaryKey $foundModelType.FullName -Project $coreProjectName)

# Get the related entities
if ($foundModelType) { $classRelations = [Array](Get-RelatedEntities $ModelType -Project $coreProjectName) }
if (!$classRelations ) { $classRelations = @() }

##############################################################
# Create the index, create View in the MvcApp
##############################################################

@("Create", "Edit", "Delete", "Details", "Index", "_CreateOrEdit", "_Display") | %{
	$outputPath = "Views\" + $ModelType + "\" + $_
	Write-Host Creating new $ModelType View $_ -ForegroundColor DarkGreen
	Add-ProjectItemViaTemplate $outputPath -Template $_ `
	-Model @{ 	
	Namespace = $namespace; 
	PrimaryKeyName = $primaryKeyName; 
	DataType = [MarshalByRefObject]$foundModelType;	
	DataTypeName = $foundModelType.Name; 
	RelatedEntities = $classRelations; 
	} `
	-SuccessMessage "Added view $_ to $ModelType" `
	-TemplateFolders $TemplateFolders -Project $mvcProjectName -CodeLanguage $CodeLanguage -Force:$Force `
}