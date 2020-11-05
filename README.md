# Useful scripts for SVN to Git migration

1. Generate authors file
<code></code><code>PowerShell
.\Generate-Authors -SvnRepoDirectory <Path to SVN repo> -Revision "1" -OutFile .\authors-file.txt -UpdateFirst
</code><code></code>

2. Initialize Git Repo
```ps1
.\Init-Repo -GitRepoDirectory <Path to git folder> -AuthorsFile <Path to authors file> -Trunk trunk -Ignore "^folder$" -SvnUrl https://contoso.com/svn/Repo
```

3. Fetch
```ps1
.\Fetch-SVN -GitRepoDirectory <Path to git folder> -Revision "1"
```

4. Clean up
```ps1
.\Remove-Configs -GitRepoDirectory <Path to git folder>
```
