# githubby

see all of your code reviews

[![Build Status](https://travis-ci.org/johnpryan/githubby.svg?branch=master)](https://travis-ci.org/johnpryan/githubby)

## features
- add repos to your list
- for each repo, see who needs to review;
- for each repo, see the number of unreviewed commits
- filter by username

A reviewer is detected if they are mentioned in the PR without an FYI 
preceding the mention.

A reviewer is required to review a PR if they haven't
commented with a +1 or +10 since the latest comment

The number of commits required is the largest of the committers tagged (i.e. person A has 2 commits and person B has 4 commits to review, githubby displays 4)


