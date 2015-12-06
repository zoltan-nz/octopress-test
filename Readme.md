# Blogging with Octopress

## Getting Started

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
jekyll clean && JEKYLL_ENV=production jekyll build
octopress deploy
```

##Customizing

Setup Gemfile

```
bundle init
```

Article about jekyll-assets: 
> http://ixti.net/software/2012/12/30/unleash-mr-hyde-introduction-of-jekyll-assets.html

Add the following gems to Gemfile.

```ruby
gem 'jekyll-assets'
gem 'uglifier'
gem 'sass'
```

Setup `_plugins/bundler.rb`

```ruby
# _plugins/bundler.rb
require "rubygems"
require "bundler/setup"
Bundler.require(:default)
```

Create assets folders

```
mkdir _assets
mkdir _assets/images
mkdir _assets/stylesheets
mkdir _assets/javascripts
```

Download jquery in `javascripts` folder.
Create `app.js` in `_assets/javascripts` folder and add the followings:

```
//= require_tree .
//= require bootstrap-sprockets
```

Copy `_syntax-highlighting.scss` to `_assets/stylesheets` folder.
Copy bootstrap variable file in our assets folder.
Create `app.css.scss` and setup import:

```
@import 'bootstrap-sprockets';
@import 'variables';
@import 'bootstrap';
@import 'syntax-highlighting';
```

Add `stylesheet` and `javascript` tags to `layout.html`

```
{% stylesheet app %}
{% javascript app %}
```

Setup excludes in `_config.yml`

```
exclude: ['Gemfile', 'Gemfile.lock', 'Readme.md']
```

Other great article:
> https://medium.com/design-open/becoming-a-jekyll-god-ef722e93f771#.z1c7pssn5

Minify the HTML

* Download compress.html: https://github.com/penibelst/jekyll-compress-html
* Update default.html.

Add robots.txt

Add active class automatically to navigation bar.
