[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^\d+$")]
    [string]$Revision,
    [Parameter(Mandatory = $true)]
    [ValidateScript( {
            if ( -Not ($_ | Test-Path) ) {
                throw "Folder does not exist"
            }
            if (-Not ($_ | Test-Path -PathType Container) ) {
                throw "The Path argument must be a folder. File paths are not allowed."
            }
            return $true
        })]
    [System.IO.FileInfo]$GitRepoDirectory
)

. .\Utils\Git.ps1

$svnConfigs = Get-GitSVNConfigs -RepoDirectory $GitRepoDirectory

if($svnConfigs.Count -lt 4){
    Write-Error "Failed to fetch from SVN. Reason: The repo '$($GitRepoDirectory.Name)' has not been properly initialized."
    Exit
}

Measure-Command {
    Fetch-GitSVN -Revision $Revision -RepoDirectory $GitRepoDirectory

    Write-Host "Fetch succeeded." -ForegroundColor Green
}