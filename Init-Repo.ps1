[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.IO.FileInfo]$GitRepoDirectory,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]  
    [ValidateScript( {
            if (-Not ($_ | Test-Path -PathType Leaf) ) {
                throw "The Path argument must be a file. Folder paths are not allowed."
            }

            return $true
        })]
    [System.IO.FileInfo]$AuthorsFile,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]  
    [string] $Trunk,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]  
    [string] $Ignore,
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [System.Uri] $SvnUrl
)

. .\Utils\Git.ps1

if (-Not (Test-Path -Path $GitRepoDirectory)) {
    New-Item -Path $GitRepoDirectory -Type Directory | Out-Null
}

try {
    Init-GitSVN -Trunk $Trunk -Ignore $Ignore -SvnUrl $SvnUrl -RepoDirectory $GitRepoDirectory
    Add-GitConfig -Name "svn.authorsfile" -Value $AuthorsFile.FullName -RepoDirectory $GitRepoDirectory

    Write-Host "Successfully initialized repo." -ForegroundColor Green
}
catch {
    Remove-GitSVNConfigs -RepoDirectory $GitRepoDirectory    
    Write-Error "Failed to initialize repo. Reason: $($_)"
}

