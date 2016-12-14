#Git Bump

Utility to bump project version (increment the version number to a new and unique value) with a bunch of options and an interactive mode.

`Git bump` also maintain a `CHANGELOG.md` file to provide an easy project log.  

##Getting Started

Given a version number in a __major__.__minor__.__patch__ format, increment the:

* __major__ version when you make incompatible API changes;
* __minor__ version when you add functionality in a backwards-compatible manner or make small changes;
* __patch__ version when you make bug fixes.

##Usage
The base syntax is:
`git bump [COMMAND][OPTIONS]`

Check if git bump is already initialized
```
git bump init
```
It will configure some options for further usage.

###Commands

####1. version

More important than anything, `git bump version` upgrade version number in version file (optionnaly in all files that have it), update changelog file and create a new __tag__.

So, for example, if you already have version __1.2.3__, bump command:
```
git bump
```
(Note: `git bump` is an alias to `git bump version` command)
will increment the change log and bump version to __1.3.0__.

As you can see, the default is a __minor__ increment. Otherwise, if you executed in your terminal:
```
git bump patch
```
the new version would be __1.2.4__.

####Examples
1. Execute `git bump` in interactive mode, you can use it together with any option:
   ```
    git bump -i
   ```
2. Checkout a new branch, passing your own new version number:
   ```
    git bump --version=2.9.8 --branch
   ```
   A branch named __v2.9.8__ will be created.

3. Current version is __0.7.9__, create a new branch and don't create tag:
   ```
    git bump --branch=feature- --no-tag
   ```
   Created and checkout branch __feature-0.8.0__.

####2. tag

Use `git tag` to create or update current version tag.

####3. revert-to

Implementing.....



For all possibilities execute `git bump [command] -h` in your terminal.   

Go back to [readme](../README.md) for installation steps.
