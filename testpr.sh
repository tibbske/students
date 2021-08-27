#!/bin/bash

if ! gh --version > /dev/null 2>&1; then
		echo "GitHub CLI not found. Install from https://cli.github.com/"
		exit 1
fi

if ! gh pr diff $2 | grep -q "_data/semesters/$1"; then
		gh pr comment -b "Your JSON is in the wrong folder, please move it to the $1 folder"
		echo "PR FAILED, JSON in wrong folder."
		exit 1
fi

gh pr checkout $2

if ! npm run test jest > /dev/null 2>&1; then
		gh pr merge -dm $2
		echo "PR PASSED checks"
else
		gh pr comment -b "Please check your JSON, it doesn't appear to be valid. https://jsonlint.com/" $2
		echo "PR FAILED, invalid JSON"
fi

git checkout master
