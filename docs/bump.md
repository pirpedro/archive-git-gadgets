# Git Bump

Utility to bump project version (increment the version number to a new and unique value) with a bunch of options and an interactive mode.

`Git bump` also maintain a `CHANGELOG.md` file to provide an easy project log.

## Getting Started

Initialize `git bump` in your repository.
```
git bump init
```

Given a version number in a __major__.__minor__.__patch__ format, increment the:

*   __major__ version when you make incompatible API changes;
*   __minor__ version when you add functionality in a backwards-compatible manner or make small changes;
*   __patch__ version when you make bug fixes.

## Commands

-   `version`   - default command, can be ommited.
-   `track`     - monitore files in git repository that contains the version pattern and need to be updated when bump is executed.
-   `tag`       - create or update current version tag.
-   `revert-to` - revert branch to a specific version.

### 1. version

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

#### Examples
1.  Execute `git bump` in interactive mode, you can use it together with any option:
    ```
    git bump -i
    ```
2.  Checkout a new branch, passing your own new version number:
    ```
    git bump --version=2.9.8 --branch
    ```
    A branch named __v2.9.8__ will be created.

3.  Current version is __0.7.9__, create a new branch and don't create tag:
    ```
     git bump --branch=feature- --no-tag
    ```
    Created and checkout branch __feature-0.8.0__.

### 2. track

Keep track of files that needs to be updated when version number is bumped.

#### Examples
After initiliaze git bump, create a new file with your current version number (let's suppose __0.1.0__) and stag it.
```
echo '0.1.0' > new_file && git add new_file
```
Now bump version number and check that `new_file` now contains __0.2.0__ as the version file.
```
git bump && cat new_file
```

`git bump track` without args will find and prompt for you all files in the repository that contains the current version number and are candidates to be tracked.

To stop tracking a file, just run: `git bump track -d new_file`.

### 3. tag

Use `git bump tag` to create or update current version tag.

It will create or point the current version tag to the last commit made.

### 4. revert-to

Implementing.....

For all possibilities execute `git bump [command] -h` in your terminal.

Go back to [readme](../README.md) for installation steps.
