[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact = 'High')]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript( {
            if(-Not ($_|Test-Path)){
                throw "Path '$_' does not exit."
            }
        
            if (-Not ($_ | Test-Path -PathType Container) ) {
                throw "The Path argument must be a folder. File paths are not allowed."
            }

            return $true
        })]
    [System.IO.FileInfo]$SvnRepoDirectory,
    [Parameter(Mandatory = $false)]
    [ValidatePattern("^\d+$")]
    [string]$Revision = "1",
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]  
    [System.IO.FileInfo]$OutFile,
    [Parameter(Mandatory = $false)]
    [switch]
    $UpdateFirst = $false
)

. .\Utils\SVN.ps1

if($UpdateFirst){
    try {
        Update-SVN -RepoDirectory $SvnRepoDirectory
    }
    catch {
        Write-Warning "Failed to update repo. Reason: $($_)"
        Write-Warning "Authors file may not contain all authors."
    }
}

if((Test-Path -Path $OutFile) -and -not $PSCmdlet.ShouldProcess($OutFile.Name, "overwrite")){
    Write-Warning "Operation aborted by user."
    Exit
}

$logs = Get-SVNLogs -RepoDirectory $SvnRepoDirectory -Revision $Revision

if($logs.Count -gt 0){
    $logs | ForEach-Object { "{0} = {0} <{0}>" -f ($_ -split '\|')[1].Trim() } | Sort-Object -Unique | Out-File -FilePath $OutFile -Encoding utf8NoBOM -Force
    Write-Host "Authors file is located at: $($OutFile.FullName)" -ForegroundColor Green
}else{
    Write-Warning "No logs found."
}