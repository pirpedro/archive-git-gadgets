# Git Gadgets

A set of useful git subcommands.

## Getting started

First clone this project to your local machine.
```
cd ~ && git clone git@github.com:pirpedro/git-gadgets.git
```

### Prerequisites

To make `git gadgets` commands works as real git subcommands it's necessary to include them in your `PATH` environment variable and give execution permission.

### Installing
Adding `git gadgets` commands in `PATH`
```
export PATH=$PATH:~/git-gadgets/bin
```
Giving execution permission for all scripts
```
sudo chmod +x ~/git-gadgets/bin/*
```

### Usage

See [command list](docs/commands.md) for each extension information.

We introduce an alternative initialization command to help the initial configuration of `git gadgets` and some extensions:

```
git gadgets init
```
Don't be afraid if you didn't initialize any extension. You can do that later.

#### Example
You can use any of `git gadgets` commands like

`git [git_gadgets_command] [options]`

For example:
```
git stats --long-current-branch
```
shows the name of your current branch.



## Commands
-   [`git activity`](docs/activity.md) - show the last activities in all branchs in an easy format.
-   [`git bump`](docs/bump.md) - utility to bump project version with a bunch of options and an interactive mode.
-   [`git flow`](docs/flow.md) - a simple [git flow concept](http://nvie.com/posts/a-successful-git-branching-model/) implementation.
-   [`git stats`](docs/stats.md) - a bunch of useful git environment outputs.

##Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-awesome-feature`
3. Commit your changes: `git commit -am 'Add some awesome feature'`
4. Push to the branch: `git push origin my-new-awesome-feature`
5. Submit a pull request and let us see it :smiley:
