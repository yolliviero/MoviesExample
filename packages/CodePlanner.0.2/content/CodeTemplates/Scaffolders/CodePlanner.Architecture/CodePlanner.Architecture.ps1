[T4Scaffolding.Scaffolder(Description = "CodePlanner.Architecture - Setup of projects and references in solution.")][CmdletBinding()]
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
# Get Solution and Path
##############################################################
$sln = [System.IO.Path]::GetFilename($dte.DTE.Solution.FullName)
$path = $dte.DTE.Solution.FullName.Replace($sln,'').Replace('\\','\')
$sln = Get-Interface $dte.Solution ([EnvDTE80.Solution2])

##############################################################
# Project Names
##############################################################
$coreProjectName = $rootNamespace + ".Core"
$dataProjectName = $rootNamespace + ".Data"
$serviceProjectName = $rootNamespace + ".Service"
$mvcProjectName = (Get-Project $Project).Name

##############################################################
# Add $rootnamespace.Core project if it does not exist
##############################################################
if(($DTE.Solution.Projects | Select-Object -ExpandProperty Name) -notcontains $coreProjectName){
	Write-Host "Adding new project - " $coreProjectName
	$templatePath = $sln.GetProjectTemplate("ClassLibrary.zip","CSharp")
	$sln.AddFromTemplate($templatePath, $path+$coreProjectName,$coreProjectName)
	$file = Get-ProjectItem "Class1.cs" -Project $coreProjectName
	$file.Remove()	
	$testPath = $path + $coreProjectName + "\Class1.cs"
	Write-Host $testPath
	if(Test-Path $testPath){
		Write-Host "Remove file..."
		Remove-Item $testPath
	}
}

##############################################################
# Add $rootnamespace.Data project if it does not exist
##############################################################
if(($DTE.Solution.Projects | Select-Object -ExpandProperty Name) -notcontains $dataProjectName){
	Write-Host "Adding new project - " $dataProjectName
	$templatePath = $sln.GetProjectTemplate("ClassLibrary.zip","CSharp")
	$sln.AddFromTemplate($templatePath, $path+$dataProjectName,$dataProjectName)
	$file = Get-ProjectItem "Class1.cs" -Project $dataProjectName
	$file.Remove()	
	$testPath = $path + $dataProjectName + "\Class1.cs"
	Write-Host $testPath
	if(Test-Path $testPath){
		Write-Host "Remove file..."
		Remove-Item $testPath
	}
}

##############################################################
# Add $rootnamespace.Service project if it does not exist
##############################################################
if(($DTE.Solution.Projects | Select-Object -ExpandProperty Name) -notcontains $serviceProjectName){
	Write-Host "Adding new project - " $serviceProjectName
	$templatePath = $sln.GetProjectTemplate("ClassLibrary.zip","CSharp")
	$sln.AddFromTemplate($templatePath, $path+$serviceProjectName,$serviceProjectName)
	$file = Get-ProjectItem "Class1.cs" -Project $serviceProjectName
	$file.Remove()	
	$testPath = $path + $serviceProjectName + "\Class1.cs"
	Write-Host $testPath
	if(Test-Path $testPath){
		Write-Host "Remove file..."
		Remove-Item $testPath
	}
}

##############################################################
# Add ref System.ServiceModel To Core
##############################################################
(Get-Project $coreProjectName).Object.References.Add("System.ServiceModel")

##############################################################
# Add ref System.Runtime.Serialization To Core
##############################################################
(Get-Project $coreProjectName).Object.References.Add("System.Runtime.Serialization")

##############################################################
# Add ref in Data To Core
##############################################################
(Get-Project $dataProjectName).Object.References.AddProject((Get-Project $coreProjectName))

##############################################################
# Add ref in Service To Core
##############################################################
(Get-Project $serviceProjectName).Object.References.AddProject((Get-Project $coreProjectName))

##############################################################
# Add ref in Service To Data
##############################################################
(Get-Project $serviceProjectName).Object.References.AddProject((Get-Project $dataProjectName))

##############################################################
# Add ref in MVC To Core
##############################################################
(Get-Project $Project).Object.References.AddProject((Get-Project $coreProjectName))

##############################################################
# Add ref in MVC To Data
##############################################################
(Get-Project $Project).Object.References.AddProject((Get-Project $dataProjectName))

##############################################################
# Add ref in MVC To Service
##############################################################
(Get-Project $Project).Object.References.AddProject((Get-Project $serviceProjectName))

##############################################################
# Install Nuget Packages
##############################################################
#Add or update T4Scaffolding!
if((get-package | Select-Object -ExpandProperty ID) -contains 'T4Scaffolding'){
	Write-Host $Project Looking for update : T4Scaffolding -ForegroundColor DarkGreen
	Update-Package T4Scaffolding -ProjectName $Project
}
else{
	Write-Host $Project Installing : T4Scaffolding -ForegroundColor DarkGreen
	Install-Package T4Scaffolding -ProjectName $Project
}

#Add or update ninject!
if((get-package | Select-Object -ExpandProperty ID) -contains 'Ninject.MVC3'){
	Write-Host $Project Looking for update : Ninject.MVC3 -ForegroundColor DarkGreen
	Update-Package Ninject.MVC3 -ProjectName $Project.Name
}
else{
	Write-Host $Project Installing : Ninject.MVC3 -ForegroundColor DarkGreen
	Install-Package Ninject.MVC3 -ProjectName $Project
}

#Add or update JQueryMobile!
#if((get-package | Select-Object -ExpandProperty ID) -contains 'jquery.mobile'){
#	Write-Host $Project Looking for update : jquery.mobile -ForegroundColor DarkGreen
#	Update-Package jquery.mobile -ProjectName $Project.Name
#}
#else{
#	Write-Host $Project Installing : jquery.mobile -ForegroundColor DarkGreen
#	Install-Package jquery.mobile -ProjectName $Project
#}

#Add or update SQL CE!
if((get-package | Select-Object -ExpandProperty ID) -contains 'EntityFramework.SqlServerCompact'){
	Write-Host $Project Looking for update : Ninject.MVC3 -ForegroundColor DarkGreen
	Update-Package EntityFramework.SqlServerCompact -ProjectName $Project.Name
}
else{
	Write-Host $Project Installing : EntityFramework.SqlServerCompact -ForegroundColor DarkGreen
	Install-Package EntityFramework.SqlServerCompact -ProjectName $Project
}

#Add or update EntityFramework!
if((get-package -ProjectName $coreProjectName | Select-Object -ExpandProperty ID) -contains 'EntityFramework'){
	Write-Host $coreProjectName Looking for update : EntityFramework -ForegroundColor DarkGreen
	Update-Package EntityFramework -ProjectName $coreProjectName
}
else{
	Write-Host $coreProjectName Installing : EntityFramework -ForegroundColor DarkGreen
	Install-Package EntityFramework -ProjectName $coreProjectName
}

if((get-package -ProjectName $dataProjectName | Select-Object -ExpandProperty ID) -notcontains 'EntityFramework'){
	Write-Host $dataProjectName Installing : EntityFramework -ForegroundColor DarkGreen
	Install-Package EntityFramework -ProjectName $dataProjectName
}
else{
	if(((Get-Project $dataProjectName).Object.References | Select-Object -ExpandProperty Name) -notcontains "EntityFramework"){
		Write-Host $dataProjectName Installing : EntityFramework -ForegroundColor DarkGreen
		Install-Package EntityFramework -ProjectName $dataProjectName
	}else{
		Write-Host $dataProjectName Looking for update : EntityFramework -ForegroundColor DarkGreen
		Update-Package EntityFramework -ProjectName $dataProjectName
	}
}

if((get-package -ProjectName $mvcProjectName | Select-Object -ExpandProperty ID) -notcontains 'EntityFramework'){
	Write-Host $mvcProjectName Installing : EntityFramework -ForegroundColor DarkGreen
	Install-Package EntityFramework -ProjectName $mvcProjectName
}
else{
	if(((Get-Project $mvcProjectName).Object.References | Select-Object -ExpandProperty Name) -notcontains "EntityFramework"){
		Write-Host $mvcProjectName Installing : EntityFramework -ForegroundColor DarkGreen
		Install-Package EntityFramework -ProjectName $mvcProjectName
	}else{
		Write-Host $mvcProjectName Looking for update : EntityFramework -ForegroundColor DarkGreen
		Update-Package EntityFramework -ProjectName $mvcProjectName
	}
}

##############################################################
# Add App_Data folder to MVC
##############################################################
$App_Data = $path + $Project + "\App_Data"
if(!(Test-Path $App_Data)){
	Write-Host "Adding App_Data to" $Project
	(Get-Project $Project).ProjectItems.AddFolder("App_Data")
}

#TEST
#Write-Host $path$namespace"\App_Start\EntityFramework.SqlServerCompact.cs"
#$
#$a = $DTE.Solution.FindProjectItem("C:\Dropbox\CodePlanner\CodePlannerDev\CodePlannerDev\App_Start\EntityFramework.SqlServerCompact.cs")
#$a.Open().Document.Activate()
#Write-Host $a.Name
#Write-Host $a.FileCodeModel.Language
#$a.FileCodeModel.CodeElements | ForEach{ Write-Host $_.Name }
#	$namespaces = $a.FileCodeModel.CodeElements | Where-Object{$_.Kind -eq 5}
#	
#	$classes = $namespaces | ForEach{$_.Children}
#	
#	$classes | ForEach{	
#		if(!($_.Name -eq $null)){						
#			
#				Write-Host "Class found"
#				$_.Children | ForEach{
#					if($_.Name -eq "Start"){
#						$edit = $_.EndPoint.CreateEditPoint()
#						$edit.StartOfLine()																	
#						$edit.Insert("Database.SetInitializer(new DropCreateDatabaseIfModelChanges<DataContext>());")
#						Write-Host $edit.GetLines(1,2)
#					}					
#				}						
#		}
#	}	
#
#$DTE.ActiveDocument.Selection.StartOfDocument()
#$DTE.ActiveDocument.Selection.NewLine()
#$DTE.ActiveDocument.Selection.LineUp()
#$DTE.ActiveDocument.Selection.Insert("using CodePlannerDev.Data;")
#$DTE.ExecuteCommand("Edit.FormatDocument")
#$a.Save()	
#	#Write-Host $ret
#	#return $ret
#
#	#DTE.Windows.Item(Constants.vsWindowKindSolutionExplorer).Activate()
#   #DTE.ActiveWindow.Object.GetItem("ScaffoldingDemo\ScaffoldingDemo.Core\Model\Company.cs").Select(vsUISelectionType.vsUISelectionTypeSelect)
#  #DTE.ActiveWindow.Object.DoDefaultAction()
#    #DTE.ActiveDocument.Selection.NewLine()