[CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'High' )]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [ValidateScript( {
            if (-Not ($_ | Test-Path)) {
                throw "Path '$_' does not exit."
            }
        
            if (($_ | Test-Path -PathType Container)) {
                if (-Not ( $_ | Join-Path -ChildPath ".git" | Test-Path -PathType Container)) {
                    throw "Path '$_' is a valid git repository."
                }
            }
    
            return $true
        })]
    [System.IO.FileInfo]$GitRepoDirectory
)

. .\Utils\Git.ps1

if ($PSCmdlet.ShouldProcess("SVN configs", "delete")) {
    Remove-GitSVNConfigs -RepoDirectory $GitRepoDirectory
}else{
    Write-Warning "Operation aborted by user."
}