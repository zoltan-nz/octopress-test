---
layout: page
---

# Jekyll Tutorial - Building a static page from scratch

### Basic setups

* Create a new empty folder
* Initialize git

* Create a new source branch.


    git checkout -b source

* Create `.gitignore`


    $ touch .gitignore

    .idea
    .sass-cache
    .jekyll-metadata
    .deploy
    .asset-cache
    build

* Check ruby, bundle, etc...

* Setup bundle


    bundle init

* Add `jekyll` to `Gemfile`


    gem 'jekyll'

* Update the bundle


    $ bundle update

* Create a `_config.yml`

* Setup source and destination folders in `_config.yml`

        source: 'content'
        destination: 'build'

* Create `content/index.md`


    ---
    ---
    # Home page
    ## Subtitle

* Launch `jekyll serve --watch`
* Open the page `http://localhost:4000`
* Remove the first two `---` lines and change the content, reload the page in the browser, it isn't updating. So we always need that two `---` lines.
* Check, that `jekyll` created a `build` folder. The generated content will be saved in this folder always. The default folder name is `_site`, but we modified it above to `build` in `_config.yml`.

* Cleaning the `build` folder

    $ jekyll clean

### First layout

* Create a `_layouts` folder


    $ mkdir _layouts

* Create a `default.html` in `_layouts`.


    $ cd _layouts
    $ touch default.html

    <!doctype html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
    </head>
    <body>
    
        {{ content }}
    
    </body>
    </html>

* Step back to the project root folder with `cd ..` and launch jekyll server with `jekyll s`

### Assets management

* Add the following gems to Gemfile.

```ruby
# Assets management
gem 'jekyll-assets'
gem 'uglifier'
gem 'sass'

# Bootstrap and font awesome
gem 'bootstrap-sass'
gem 'font-awesome-sass'
```

* Add a custom plugin directory settings in `_config.yml`

    
    plugins_dir: 'plugins'

* Setup `plugins/bundler.rb`

```ruby
# plugins/bundler.rb
require "rubygems"
require "bundler/setup"
Bundler.require(:default)
```
* Create assets folders

```bash
$ mkdir _assets
$ mkdir _assets/images
$ mkdir _assets/stylesheets
$ mkdir _assets/javascripts
```

* Create `main.scss`

```sass
@import 'bootstrap-sprockets';
@import 'font-awesome-sprockets';
@import 'variables';
@import 'bootstrap';
@import 'font-awesome';
```

* Copy bootstrap variable file in our assets folder.

* Download jquery in `javascripts` folder.
* Create `main.js` in `content/_assets/javascripts` folder and add the followings:

```sass
//= require jquery-2.2.4.min
//= require_tree .
//= require bootstrap-sprockets
```

* Add `stylesheet` and `javascript` tags to `layout.html`

```
{% stylesheet main %}
{% javascript main %}
```

* Update `_config.yml`

```
assets:
  sources:
    - content/_assets
```

### Add navbar

* Create `content/_includes` folder.
* Create a `navbar.html` with navigation bar content.
* Update `default.html` layout.
 

    {% include navbar.html %}
    
### Add livereload

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

### List blogposts on home page

* Create `home.html` layout and `post.html` layout. 

* Update config file
 
```
# Blog posts url structure
permalink:   /:categories/:title
```

 * Update `home.html`

 ```html
 <ul>
     {% for post in site.posts %}
     <li>
         <span>{{ post.date | date: "%b %-d, %Y" }}</span>
 
         <h2>
             <a href="{{ post.url | prepend: site.baseurl }}">{{ post.title }}</a>
         </h2>
     </li>
     {% endfor %}
 </ul>
 ```
 
 
