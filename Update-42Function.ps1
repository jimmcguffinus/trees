function Update-42Function {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)]
        [string]$ScriptPath = "$(Get-Location)\Invoke-42Git.ps1"
    )

    $functionsPath = "$HOME\Documents\PowerShell\Functions"
    
    # Verify script exists
    if (-not (Test-Path $ScriptPath)) {
        Write-Error "❌ Script not found: $ScriptPath"
        return
    }

    # Create Functions directory if it doesn't exist
    if (-not (Test-Path $functionsPath)) {
        New-Item -ItemType Directory -Path $functionsPath -Force
        Write-Host "📁 Created Functions directory: $functionsPath" -ForegroundColor Cyan
    }

    # Copy the script to Functions directory
    Copy-Item $ScriptPath -Destination $functionsPath -Force
    Write-Host "📝 Updated function: $ScriptPath" -ForegroundColor Green

    # Reload the function
    . "$functionsPath\$(Split-Path $ScriptPath -Leaf)"
    Write-Host "🔄 Reloaded function successfully!" -ForegroundColor Magenta
} 