. .\Utils\Process.ps1

function Update-SVN([System.IO.FileInfo]$RepoDirectory){
    $cmd = Execute-SVN -ArgumentList "update" -RepoDirectory $RepoDirectory

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }
}

function Get-SVNLogs {
    param (
        [Parameter(Mandatory = $false)]
        [ValidatePattern("^\d+$")]
        [string]$Revision = "1",
        [Parameter(Mandatory = $true)]
        [System.IO.FileInfo]$RepoDirectory
    )
    
    $cmd = Execute-SVN -ArgumentList "log -r$($Revision):HEAD --quiet" -RepoDirectory $RepoDirectory

    if ($cmd.ExitCode -gt 0) {
        throw "$($cmd.StandardError)"
    }

    $output = $cmd.StandardOutput

    $logs = @(
        if (![string]::IsNullOrWhiteSpace($output)) { 
            $output -split "\n" | Where-Object { $_ -like 'r*'}
        }
    )

    return $logs
}

function Execute-SVN([string]$ArgumentList, [System.IO.FileInfo]$RepoDirectory) {
    Execute-Command -FilePath "svn" -ArgumentList $ArgumentList -WorkingDirectory $RepoDirectory
}