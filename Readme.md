# Blogging with Octopress

Installing the octopress package.
```
gem install octopress
```

Creating the blog

```
octopress new octopress-test
```

Launching doc

```
octopress docs
```

Launching the server

```
jekyll clean && jekyll serve --incremental -w
```

Setup deploy

```
octopress deploy init git git@github.com:szines/octopress-test
```

* Change branch to `gh-pages` in project repository, keep `master` for account main page.
* Add `.deploy` to `.gitignore`

Deploy

```
octopress deploy
```
