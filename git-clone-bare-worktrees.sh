#!/bin/bash

remoteURL=$1
folderName=$2

# Examples of call:
# ./git-clone-bare-worktrees.sh git@github.com:name/repo.git
# => Clones to a ./repo directory
#
# ./git-clone-bare-worktrees.sh git@github.com:name/repo.git my-repo
# => Clones to a ./my-repo directory

if [ -z "$folderName" ]; then
    basename=$(basename "$remoteURL" | sed 's/\.[^.]*$//')
    folderName=$basename
fi

mkdir -p "$folderName"
cd "$folderName" || exit

# Moves all the administrative git files (a.k.a $GIT_DIR) under .bare directory.
#
# Plan is to create worktrees as siblings of this directory.
# Example targeted structure:
# .bare
# main
# new-awesome-feature
# hotfix-bug-12
# ...
git clone --bare "$remoteURL" .bare
echo "gitdir: ./.bare" > .git

# Explicitly sets the remote origin fetch so we can fetch remote branches
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git fetch origin

# Automatically creates a worktree for each branch
git branch -r | while IFS= read -r branch; do
    # Removes the origin/ prefix
    branchName=$(echo "$branch" | sed 's/origin\///')
    # Remove whitespace to clean up the string
    branchName=$(echo "$branchName" | tr -d '[:space:]')
    # Creates a worktree for each branch
    git worktree add --track -B "$branchName" "./$branchName" "origin/$branchName"
done
