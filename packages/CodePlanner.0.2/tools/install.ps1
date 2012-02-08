param($installPath, $toolsPath, $package, $project)

#check version and edition
if($DTE.Edition -eq "Express"){
	Write-Host "Sorry, You cant use an Express verison with CodePlanner"
	return
}

$defaultProject = Get-Project
if($defaultProject.Type -ne "C#"){
	Write-Host "Sorry, CodePlanner is only available for C#"
	return
}

$proj = [System.IO.Path]::GetFilename($defaultProject.FullName)
$path = $defaultProject.FullName.Replace($proj,'').Replace('\\','\')


$namespace = (Get-Project).Properties.Item("DefaultNamespace").Value
$rootNamespace = $namespace
$dotIX = $namespace.LastIndexOf('.')
if($dotIX -gt 0){
	$rootNamespace = $namespace.Substring(0,$namespace.LastIndexOf('.'))
}

#Default layout to layout folder...
[System.IO.File]::Copy("$($installPath)\content\CodeTemplates\_Layout.cshtml","$($path)\Views\Shared\_Layout.cshtml",$true);
#EditorTemplate Shared Views folder...
[System.IO.Directory]::CreateDirectory("$($path)\Views\Shared\EditorTemplates");
[System.IO.File]::Copy("$($installPath)\content\CodeTemplates\EditorTemplates\DateTime.cshtml","$($path)\Views\Shared\EditorTemplates\DateTime.cshtml",$true);

Scaffold CodePlanner.Architecture

Scaffold CodePlanner.Core.Model
Scaffold CodePlanner.Core.Interfaces
Scaffold CodePlanner.Data
Scaffold CodePlanner.Services


$DTE.ExecuteCommand("Build.BuildSolution")
Start-Sleep -Seconds 3
Add-CodeToMethod $defaultProject.Name "\App_Start\" "EntityFramework.SqlServerCompact.cs" "EntityFramework_SqlServerCompact" "Start" "Database.SetInitializer(new DropCreateDatabaseIfModelChanges<DataContext>());"
Add-Namespace $defaultProject.Name "\App_Start\" "EntityFramework.SqlServerCompact.cs" "$($rootNamespace).Data"

Add-CodeToMethod $defaultProject.Name "\App_Start\" "NinjectMVC3.cs" "NinjectMVC3" "RegisterServices" "kernel.Bind<IDatabaseFactory>().To<DatabaseFactory>().InRequestScope();"
Add-CodeToMethod $defaultProject.Name "\App_Start\" "NinjectMVC3.cs" "NinjectMVC3" "RegisterServices" "kernel.Bind<IUnitOfWork>().To<UnitOfWork>().InRequestScope();"
Add-Namespace $defaultProject.Name "\App_Start\" "NinjectMVC3.cs" "$($rootNamespace).Data"
Add-Namespace $defaultProject.Name "\App_Start\" "NinjectMVC3.cs" "$($rootNamespace).Service"
Add-Namespace $defaultProject.Name "\App_Start\" "NinjectMVC3.cs" "$($rootNamespace).Core.Interfaces.Data"
Add-Namespace $defaultProject.Name "\App_Start\" "NinjectMVC3.cs" "$($rootNamespace).Core.Interfaces.Service"

Write-Host "Check out 'ReadMe.txt' if you are new to CodePlanner"