# Useful scripts for SVN to Git migration

1. Generate authors file
```posh
.\Generate-Authors -SvnRepoDirectory <Path to SVN repo> -Revision "1" -OutFile .\authors-file.txt -UpdateFirst
```

2. Initialize Git Repo
```posh
.\Init-Repo -GitRepoDirectory <Path to git folder> -AuthorsFile <Path to authors file> -Trunk trunk -Ignore "^folder$" -SvnUrl https://contoso.com/svn/Repo
```

3. Fetch
```posh
.\Fetch-SVN -GitRepoDirectory <Path to git folder> -Revision "1"
```

4. Clean up
```posh
.\Remove-Configs -GitRepoDirectory <Path to git folder>
```