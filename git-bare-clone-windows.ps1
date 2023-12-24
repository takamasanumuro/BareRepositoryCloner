param(
    [string]$remoteURL,
    [string]$folderName = ""
)

Set-StrictMode -Version Latest

# Examples of call:
# git-clone-bare-for-worktrees.ps1 git@github.com:name/repo.git
# => Clones to a .\repo directory
#
# git-clone-bare-for-worktrees.ps1 git@github.com:name/repo.git my-repo
# => Clones to a .\my-repo directory

if (-not $folderName) {
    $basename = [System.IO.Path]::GetFileNameWithoutExtension($remoteURL)
    $folderName = $basename
}

New-Item -ItemType Directory -Force -Path $folderName | Out-Null
Set-Location $folderName

# Moves all the administrative git files (a.k.a $GIT_DIR) under .bare directory.
#
# Plan is to create worktrees as siblings of this directory.
# Example targeted structure:
# .bare
# main
# new-awesome-feature
# hotfix-bug-12
# ...
git clone --bare $remoteURL .bare
"gitdir: ./.bare" | Out-File -FilePath .git

# Explicitly sets the remote origin fetch so we can fetch remote branches
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch origin

#Automatically creates a worktree for each branch
git branch -r | ForEach-Object {
    # Removes the origin/ prefix
    $branchName = $_ -replace "origin/", ""
    #Remove whitespace to clean up the string
    $branchName = $branchName.Trim()
    # Creates a worktree for each branch
    git worktree add --track -B $branchName ./$branchName origin/$branchName
}


