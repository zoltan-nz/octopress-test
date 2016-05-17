# Blogging with Octopress

## Getting Started

Installing the octopress package.
```
$ gem install octopress
```

Creating the blog

```
$ octopress new octopress-test
```

Launching doc

```
$ octopress docs
```

### Launching server and guard

Launch the two commands in two terminal, or use foreman

```
$ jekyll clean && jekyll serve -w
$ guard
```

```
$ foreman start
```



### Setup deploy

```
$ octopress deploy init git git@github.com:szines/octopress-test
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
build
```

### Deploy

```
jekyll clean && JEKYLL_ENV=production jekyll build
octopress deploy
```

## Customization log

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

```bash
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

### Minify the HTML

* Download compress.html: https://github.com/penibelst/jekyll-compress-html
* Update default.html.

Add robots.txt

### Navigation bar active class management

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

### Livereload
> http://dan.doezema.com/2014/01/setting-up-livereload-with-jekyll/

```ruby
gem 'guard'
gem 'guard-jekyll-plus'
gem 'guard-livereload'
```

Guardfile:

```ruby
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

Insert the following code in the default template header.

```
  {% if jekyll.environment == 'development' %}
    <script>
      var livereloadPath = 'http://' + location.hostname + ':35729/livereload.js';
      var scriptElement = document.createElement('script');
      var thisScript = document.getElementsByTagName('script')[0];
      scriptElement.async = 1;
      scriptElement.src = livereloadPath;
      thisScript.parentNode.insertBefore(scriptElement, thisScript);
    </script>
  {% endif %}
```


### Tweeks with template

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

### Add conditional structure element

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

### Creating a {% faker %} tag for using Faker gem

> http://jekyllrb.com/docs/plugins/#tags

Create a `FakerTag` class in `_plugins`.

```ruby
require 'faker'

module Jekyll
  class FakerTag < Liquid::Tag

    def initialize(tag_name, command, options)
      super
      @class = command.split[0]
      @method = command.split[1]
      @param1 = Integer(command.split[2]) rescue command.split[2]
      @param2 = Integer(command.split[3]) rescue command.split[3]
      @param3 = Integer(command.split[4]) rescue command.split[4]
    end

    def render(context)
      klass = Faker.class_eval(@class)

      if @param2
        return klass.send(@method, @param1, @param2)
      end

      if @param1
        return klass.send(@method, @param1)
      end

      klass.send(@method)
    end
  end
end

Liquid::Template.register_tag('faker', Jekyll::FakerTag)
```

Usage example:

```
Original: Faker::Lorem.paragraph(10)

As a tag:
{% faker Lorem paragraph 10 %}
```

### Fake article generator

Create a `faker_tag.rb` plugin in `_plugins` folder:

```ruby
require 'faker'

module Jekyll
  class FakerTag < Liquid::Tag

    def initialize(tag_name, command, options)
      super
      @class = command.split[0]
      @method = command.split[1]
      @param1 = Integer(command.split[2]) rescue command.split[2]
      @param2 = Integer(command.split[3]) rescue command.split[3]
      @param3 = Integer(command.split[4]) rescue command.split[4]
    end

    def render(context)
      klass = Faker.class_eval(@class)

      if @param2
        return klass.send(@method, @param1, @param2)
      end

      if @param1
        return klass.send(@method, @param1)
      end

      klass.send(@method)
    end
  end
end

Liquid::Template.register_tag('faker', Jekyll::FakerTag)
```

Usage of `faker` helper in template:

```
{% faker Lorem paragraph 10 %}
```

### Category listing page

> https://github.com/shigeya/jekyll-category-archive-plugin

> http://jekyllrb.com/docs/plugins/#generators

> http://jekyllrb.com/docs/variables/

Create a `_plugins` page:

```ruby
module Jekyll

  class CategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
      self.data['category'] = category

      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end
  end

  class CategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'category_index'
        dir = site.config['category_dir'] || 'categories'
        site.categories.each_key do |category|
          site.pages << CategoryPage.new(site, site.source, File.join(dir, category), category)
        end
      end
    end
  end

end
```


Create a layout in `/_layouts/category_index.html`:


```html

---
layout: default
---

<h1>{{page.category | capitalize}} category index</h1>
```

Filter out category index pages from navigation bar:

```ruby
  {% unless my_page.url contains '/categories/' %}
    <li class="{% if page.url == my_page.url %}active{% endif %}"><a href="{{ my_page.url | prepend: site.baseurl }}">{{ my_page.title }}</a></li>
  {% endunless %}
```

List posts on the category index page:

```html
{% for post in site.posts %}
<ul>
  {% if post.categories contains page.category %}
    <li><a href="{{ post.url | prepend: site.baseurl }}">{{post.title}}</a></li>
  {% endif %}
</ul>
{% endfor %}
```

### Markdown on home page

Rename index.html to index.md

Add to `_layouts/home.html`:

```liquid
{% if page.content.size %}

  {{content}}

{% endif %}
```

### Don't forget to add to your project

* CNAME
* .nojekyll

### Debugging

There is a debugger gem for jekyll: `gem 'octopress-debugger'`
More info: [https://github.com/octopress/debugger](https://github.com/octopress/debugger)
