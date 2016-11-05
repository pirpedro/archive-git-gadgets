#Git Flow

A simple [git flow concept](http://nvie.com/posts/a-successful-git-branching-model/) implementation.

##Getting Started

You can manage __feature__, __release__ and __hotfix__ branches.
For each flow you can __start__, __finish__ and __push__ changes
in branch.

##Usage
The base syntax is:
`git flow [FLOW] [ACTION] [BRANCH_NAME]`

1. Start a new feature with name __ticket127__:
   ```
   > git flow feature start
   Branch feature/ticket127 created.
   ```
2. Create a new hotfix while in version __1.7.8__:
   ```
   > git flow hotfix start
   Branch hotfix/1.7.9 created.
   ```
   To bump version, `git flow` uses [`git bump`](bump.md).
3. Finish work in branch __release/2.3.6__:
   ```
   > git flow release finish
   Merge changes to develop branch.
   Tag 'v2.3.6' created.
   Merge changes to master branch.
   ```

For all possibilities execute `git bump -h` in your terminal.

Go back to [readme](../README.md) for installation steps.
