#Git Bump

Utility to bump project version (increment the version number to a new and unique value) with a bunch of options and an interactive mode.

`Git bump` also maintain a `CHANGELOG.md` file to provide a easy log.  

##Getting Started

Given a version number in a __major__.__minor__.__patch__ format, increment the:

* __major__ version when you make incompatible API changes;
* __minor__ version when you add functionality in a backwards-compatible manner or make small changes;
* __patch__ version when you make bug fixes.

##Usage
The base syntax is:
`git bump [OPTIONS] [INCREMENT] [BRANCH]`


So, for example, if you already have version __1.2.3__, bump command:
```
git bump
```
will increment the change log and bump version to __1.3.0__.

As you can see, the default is a __minor__ increment. Otherwise, if you executed in your terminal:
```
git bump major
```
the new version would be __1.2.4__.

###Examples
1. Execute `git bump` in interactive mode, you can use it together with any option:
   ```
    git bump -i
   ```
2. Checkout a new release branch, passing your own new version number:
   ```
    git bump -v 2.9.8 --release
   ```
   A branch named __release/2.9.8__ will be created.

3. Increment patch part, commit, create a new tag and push changes to branch __awesome_features__:
   ```
    git bump --push awesome_features
   ```

For all possibilities execute `git bump -h` in your terminal.   

Go back to [readme](../README.md) for installation steps.
