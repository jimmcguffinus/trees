# Module file for directory tree viewer
function Get-42Tree {
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
        Get-42Tree -RootPath "E:\ChatGPTExportMDs" -StartPath "2024\11\05"
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, Position=0)]
        [ValidateScript({Test-Path $_})]
        [string]$RootPath,
        
        [Parameter(Mandatory=$true, Position=1)]
        [string]$StartPath
    )

    # Get all paths under the root directory
    $paths = Get-ChildItem -Path $RootPath -Recurse -Directory | 
             Select-Object -ExpandProperty FullName

    function New-Tree {
        param ([string[]]$paths, [string]$startFrom)
        $tree = @{}
        
        foreach ($path in $paths) {
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
        param ($tree, [string]$indent = '', [bool]$isLast = $true)
        
        $nodes = @($tree.Keys)
        for ($i = 0; $i -lt $nodes.Count; $i++) {
            $node = $nodes[$i]
            $isLastNode = ($i -eq $nodes.Count - 1)
            
            if ($indent -eq '') {
                Write-Host "$node"
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

    # Main execution
    try {
        $tree = New-Tree -paths $paths -startFrom $StartPath
        Show-Tree -tree $tree
    } catch {
        Write-Error "An error occurred: $_"
    }
}

# Export the function
Export-ModuleMember -Function Get-42Tree 