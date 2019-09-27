#!/bin/sh
###############################################################################
# Print commit hashes for the current month from all repositories in a HOME   #
# folder of the git global user.name author                                   #
###############################################################################
for repo in $(find ~ -name ".git")
do
  cd ${repo}/..
  git log remotes/origin/HEAD \
    --author="$(git config --global user.name)" \
    --after="$(date +%Y-%m-01T00:00:00Z)" \
    --pretty='format:%H %an %aI' \
    --reverse
done
