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

**Launching server and guard**

Launch the two commands in two terminal, or use foreman

```
jekyll clean && jekyll serve -w
guard
```

```
foreman start
```



### Setup deploy

```
octopress deploy init git git@github.com:szines/octopress-test
```

* Change branch to `gh-pages` in project repository, keep `master` for account main page.
* Add `.deploy` to `.gitignore`

`.gitignore` content:

```
_site
.sass-cache
.asset-cache
.jekyll-metadata
.deploy
```


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

```sass
//= require_tree .
//= require bootstrap-sprockets
```

Copy `_syntax-highlighting.scss` to `_assets/stylesheets` folder.
Copy bootstrap variable file in our assets folder.
Create `app.css.scss` and setup import:

```sass
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
exclude: ['Gemfile', 'Gemfile.lock', 'Readme.md', 'Guardfile', '.asset-cache', '.sass-cache', '.deploy']
```

Other great article:
> https://medium.com/design-open/becoming-a-jekyll-god-ef722e93f771#.z1c7pssn5

###Minify the HTML

* Download compress.html: https://github.com/penibelst/jekyll-compress-html
* Update default.html.

Add robots.txt

###Navigation bar active class management

Add active class automatically to navigation bar.

```html
<!-- ./_includes/navigation.html -->
<div class="collapse navbar-collapse" id="main-navbar">
  <ul class="nav navbar-nav">
    <li class="{% if page.url == '/' %}active{% endif %}"><a href="{{ '/' | prepend: site.baseurl }}">Home</a></li>
    {% for my_page in site.pages %}
    	{% if my_page.title %}
      	<li class="{% if page.url == my_page.url %}active{% endif %}"><a href="{{ my_page.url | prepend: site.baseurl }}">{{ my_page.title }}</a></li>
       {% endif %}
    {% endfor %}
  </ul>
</div>
```

###Livereload
> http://dan.doezema.com/2014/01/setting-up-livereload-with-jekyll/

```
gem 'guard'
gem 'guard-jekyll-plus'
gem 'guard-livereload'
```

Guardfile:

```
ignore /.asset-cache/,/.deploy/,/_site/,/.sass-cache/,/.idea/

guard 'jekyll-plus' do
  watch /.*/
end

guard 'livereload' do
  watch /.*/
end
```

Launch guard to activate livereload:

```
guard
```
###Adding Foreman to launch jekyll and guard together

Gemfile:
```
gem 'foreman'
```

Procfile:
```
jekyll: jekyll clean && jekyll serve -w
guard: guard
```

###Tweeks with template

* Creating a `home.html` in `_includes` folder
* Move homepage content to `home.html`

Update `index.html`:
```
---
layout: default
---

{% include home.html %}
```

###Blog structure and style

> * Bootstrap examples: http://getbootstrap.com/examples/blog/#
* Html: view-source:http://getbootstrap.com/examples/blog/#
* CSS: http://getbootstrap.com/examples/blog/blog.css

Style update:
```css
html {
  overflow-y: scroll;
}

.blog-masthead {
  -webkit-box-shadow: inset 0 -2px 5px rgba(0,0,0,.1);
          box-shadow: inset 0 -2px 5px rgba(0,0,0,.1);
}
```

* Update navlink-default variables in bootstrap `_variables.scss`

```
Purple: #3b2f63
Pink: #ff0066
Red: #e25351
```

###Add conditional structure element

For example, conditionally showing blog-header.

Add a variable to `_config.yml`

```
show_header: false
```

Use this variable in the template.

```html
{% if site.show_header %}

<div class="blog-header">
  <h1 class="blog-title">{{site.title}}</h1>
  <p class="lead blog-description">{{site.description}}</p>
</div>

{% endif %}
```