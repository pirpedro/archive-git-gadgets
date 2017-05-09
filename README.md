# Git Gadgets

A set of useful git subcommands.

## Getting started

For a fast way to run this project, first clone to your local machine.
```
cd ~ && git clone https://github.com/pirpedro/git-gadgets
```

Then run the Makefile
```
cd git-gadgets && sudo make install
```

### Prerequisites

To make `git gadgets` commands works as real git subcommands it's necessary to include them in your `PATH` environment variable and give execution permission.

### Installing

If you want to install the development mode, download the [installer](https://raw.githubusercontent.com/pirpedro/git-gadgets/develop/contrib/installer) script and run it.
```
chmod +x installer && sudo ./installer install develop
```
or in just a single line:
```
curl -L https://raw.githubusercontent.com/pirpedro/git-gadgets/develop/contrib/installer | sudo bash /dev/stdin install develop
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
