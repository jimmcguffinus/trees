<#
.SYNOPSIS
    Displays directory structures in a tree format similar to tree /a command.

.DESCRIPTION
    Get-42Tree generates a visual tree representation of directory structures using ASCII art.
    It only shows directories (not files) and supports viewing from a specific starting point
    within the directory hierarchy.

.PARAMETER RootPath
    The full path to the root directory where the tree search begins.
    Example: "E:\ChatGPTExportMDs"

.PARAMETER StartPath
    The relative path from RootPath where the tree display should begin.
    Example: "2024\11\05"

.EXAMPLE
    .\Get-42Tree.ps1 -RootPath "E:\ChatGPTExportMDs" -StartPath "2024\11\05"
    
    Output:
    2024
        └───11
            └───05
                └───images

.EXAMPLE
    .\Get-42Tree.ps1 -RootPath "C:\Projects" -StartPath "2024"
    
    Shows all directories under the 2024 folder in the Projects directory.

.NOTES
    File Name      : Get-42Tree.ps1
    Author         : Your Name
    Prerequisite   : PowerShell 5.1 or higher
    Version        : 1.0.0
#>

[CmdletBinding()]
param(
    [Parameter(
        Mandatory=$true,
        Position=0,
        HelpMessage="Enter the full path to the root directory"
    )]
    [ValidateScript({Test-Path $_})]
    [string]$RootPath,
    
    [Parameter(
        Mandatory=$true,
        Position=1,
        HelpMessage="Enter the relative path from root where tree should start"
    )]
    [string]$StartPath
)

# Get all paths under the root directory - modified to only get directories
$paths = Get-ChildItem -Path $RootPath -Recurse -Directory | 
         Select-Object -ExpandProperty FullName

function New-Tree {
    <#
    .SYNOPSIS
        Creates a hierarchical hash table representing the directory structure.
    .DESCRIPTION
        Processes an array of file paths and creates a nested hash table structure
        representing the directory hierarchy starting from a specified path.
    #>
    param (
        [string[]]$paths,
        [string]$startFrom
    )
    
    $tree = @{}
    
    foreach ($path in $paths) {
        # Convert path to relative path starting from startFrom
        $relativePath = $path.Replace($RootPath, '').TrimStart('\')
        if ($relativePath.StartsWith($startFrom)) {
            $parts = $relativePath.Split('\')
            $current = $tree
            foreach ($part in $parts) {
                if (-not $current.ContainsKey($part)) {
                    $current[$part] = @{}
                }
                $current = $current[$part]
            }
        }
    }
    
    return $tree
}

function Show-Tree {
    <#
    .SYNOPSIS
        Displays the directory tree with ASCII art formatting.
    .DESCRIPTION
        Recursively prints the directory structure using ASCII box-drawing characters
        to show the hierarchy relationships between directories.
    #>
    param (
        $tree, 
        [string]$indent = '', 
        [bool]$isLast = $true
    )
    
    $nodes = @($tree.Keys)
    for ($i = 0; $i -lt $nodes.Count; $i++) {
        $node = $nodes[$i]
        $isLastNode = ($i -eq $nodes.Count - 1)
        
        if ($indent -eq '') {
            Write-Host "$node"  # Root node without prefix
        } else {
            $prefix = if ($isLastNode) { '└───' } else { '├───' }
            Write-Host "$indent$prefix$node"
        }
        
        $newIndent = if ($indent -eq '') {
            "    "
        } else {
            if ($isLastNode) {
                "$indent    "
            } else {
                "$indent│   "
            }
        }
        
        Show-Tree -tree $tree[$node] -indent $newIndent -isLast $isLastNode
    }
}

# Create and print the tree
$tree = New-Tree -paths $paths -startFrom $StartPath
Show-Tree -tree $tree

