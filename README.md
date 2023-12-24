Powershell / Bash script to clone a bare repository and automatically set up a worktree for each existing branch.
The use of worktrees allow you to checkout to a different branch by simply navigating to the folder associated with it
instead of having to perform laborsome git stash, checkout and pop operations. Furthermore the bare repository is
being used as a central hub for all the individual worktrees. This is to prevent individual cloning of each branch,
which would lead to individual version control for each folder. This would not be optimal as those repositories
would not be synchronized with each other, hence the solution.

To use it grab the script and place it on any folder that is contained within the PATH environment of your operation system
or create a new directory and insert it into the environment variables. Then call the script by using:

git-bare-clone-windows [REPOSITORY-URL] [OPTIONAL-FOLDER-NAME]
git-bare-clone-linux [REPOSITORY-URL] [OPTIONAL-FOLDER-NAME]
