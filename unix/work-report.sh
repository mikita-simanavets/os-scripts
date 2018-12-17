#!/usr/bin/env bash
###############################################################################
# Print commit hashes from all repositories in the current folder after 1st   #
# day of the current month for the given author. Depth-first search only.     #
# Place this bash script in folder with all your repositories for the current #
# project.                                                                    #
# Usage example:                                                              #
#   $ sh work-report.sh [author]                                              #
#   * author: output of git config user.name                                  #
###############################################################################
if [ $# -eq 0 ]; then
  echo "Argument error: author name is missing"
else
  for repo in `find ./ -name ".git"`;
  do
    cd ${repo}/..;
    git log master --author=$1 --after='$(date +%Y-%m-01T00:00:00Z)' --pretty=format:%H;
    cd ..;
  done
fi
