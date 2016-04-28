###
# Compass
###

# Change Compass configuration
# http://blachniet.com/2014/04/29/middleman-foundation/
compass_config do |config|
  config.output_style = :compact
end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

# dynamic pages see https://middlemanapp.com/advanced/dynamic_pages/
data.pages.each do |page|
  # when page.json is get in the data/pages directory, Middleman adds the file name as the zeroth item in an array, with the content of page.json as the first item
  page = page[1]
  # if the theme was defined on command line
  # for example, rake build theme=<theme_name>
  if ENV['theme']
      if ENV['theme'] == page.theme
        sub_directory = page.sub_directory ? '/' + page.sub_directory : ''
        proxy "#{sub_directory}/#{page.name}.html", "/templates/page.html", :locals => { :page => page }, :ignore => true
      end
  else
    sub_directory = page.sub_directory ? '/' + page.sub_directory : ''
    theme = page.theme ? '/' + page.theme : ''
    proxy "#{theme}#{sub_directory}/#{page.name}.html", "/templates/page.html", :locals => { :page => page }, :ignore => true
  end
end

# custom helper to render links to dynamic pages
# https://middlemanapp.com/basics/helper_methods/#custom-defined-helpers
helpers do

  def dynamic_pages_links
    html = "<h3>Pages</h3>"
    html << "<ul>"
    # this for reals needs to be refactored at some point
    data.pages.each do |page|
      # when page.json is get in the data/pages directory, Middleman adds the file name as the zeroth item in an array, with the content of page.json as the first item
      page = page[1]
      if page.name == "index" && !page.sub_directory && !page.theme
        html << ""
      elsif page.name == "index" && !page.theme
        sub_directory = page.sub_directory ? '/' + page.sub_directory + '/' : ''
        html << "<li><a href='#{http_path}#{sub_directory}'>#{page.name.titlecase}</a></li>"
      elsif page.name == "index" && page.theme
        sub_directory = page.sub_directory ? '/' + page.sub_directory + '/' : ''
        html << "<li><a href='#{http_path}#{page.theme}#{sub_directory}'>#{page.theme.titlecase} - #{page.name.titlecase}</a></li>"
      elsif page.theme
        sub_directory = page.sub_directory ? '/' + page.sub_directory + '/' : '/'
        html << "<li><a href='#{http_path}#{page.theme}#{sub_directory}#{page.name}'>#{page.theme.titlecase} - #{page.name.titlecase}</a></li>"
      else
        sub_directory = page.sub_directory ? '/' + page.sub_directory + '/' : ''
        html << "<li><a href='#{http_path}#{sub_directory}#{page.name}'>#{page.name.titlecase}</a></li>"
      end
    end
    html << "</ul>"
    return html
  end

  # if the data exists, output the html tag specified
  def if_data_element (data, element, classes = "", data_attrs = "")
    if data && !data.empty?
      return "<#{element} class='#{classes}' #{data_attrs}>#{data}</#{element}>"
    end
  end

  # if the data exists, output an img tag
  def if_data_img (data, classes = "", data_attrs = "")
    if data && !data.empty?
      "<img src='#{images_path}/#{data}' class='#{classes}' #{data_attrs} />"
    end
  end

  # if the data exists, output a list
  def if_data_list (data, classes = "", data_attrs = "")
    if data && !data.empty?
      html = "<ul class='#{classes}' #{data_attrs}>"
      data.each do |list_item|
        html << "<li>#{list_item}</li>"
      end
      html << "</ul>"
      return html
    end
  end

  # if the data exists, output a button
  def if_data_button (data, classes = "", data_attrs = "")
    return "<button class='#{classes}' #{data_attrs}>#{data}</button>"
  end

  # if the data (link text) exists, output a link
  def if_data_link (data, href, classes = "", data_attrs = "")
    return "<a href='#{href}' class='#{classes}' #{data_attrs}>#{data}</a>"
  end

end

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# https://github.com/middleman/middleman-livereload/issues/24#issuecomment-17582303
configure :development do
  activate :livereload
  config[:file_watcher_ignore] += [
    /node_modules\//,
    /images\//
    ]
end

# http://middlemanapp.com/basics/pretty-urls/
activate :directory_indexes

# Add node_modules's directory to sprockets asset path
after_configuration do
  sprockets.append_path File.join "#{root}", "node_modules"
end

# set default Middleman global path variables
# current preference is for _path variables, see explanation below
set :css_dir, 'stylesheets'
set :js_dir, 'javascripts'
set :images_dir, 'images'

# there is a bug with css_dir & js_dir being set in the build step
# see https://github.com/middleman/middleman/issues/1585
# use this in place of css_dir & js_dir in the templates to avoid issues
# and to be consistent, use images_path instead of images_dir
set :http_path, ''
set :css_path, '/stylesheets'
set :js_path, '/javascripts'
set :images_path, '/images'

# Build-specific configuration
configure :build do

  ignore '*.md'

  # uses ruby negative lookahead regex to ignore all js in themes dir
  # except <theme_name>.*
  # see https://github.com/middleman/middleman/issues/431
  ignore %r{javascripts/themes/(?!#{ENV['theme']}).*$}

  # ignore sass
  ignore %r{stylesheets/themes/(?!#{ENV['theme']}).*$}

  # ignore images
  ignore %r{images/themes/(?!#{ENV['theme']}).*$}

  # For example, change the Compass output style for deployment
  activate :minify_css, ignore: [
    'stylesheets/vendor/*'
  ]

  # Minify Javascript on build
  activate :minify_javascript, ignore: [
    'javascripts/vendor/*'
  ]

  # Enable cache buster
  activate :asset_hash, ignore: [
    'javascripts/vendor/*',
    'fonts/*',
    'images/*',
    'stylesheets/vendor/*'
  ]

  activate :autoprefixer, ignore: [
    'stylesheets/vendor/*'
  ]

  # Use relative URLs
  # activate :relative_assets

  # build all themes
  if ENV['build_dir']
    # set build directory name to the ENV VAR "build_dir"
    # to define this during build step --> "rake build build_dir=build_dir_name"
    set :build_dir, ENV['build_dir']
  else
    set :build_dir, "build"
  end

  # images_dir is used by compass image-url, so for background-image to work in sass files, this needs to be set
  set :images_dir, '/images'

  # set http_prefix, used by the stylesheet_link_tag, javascript_include_tag, and image-url helpers
  set :http_prefix, '/'

  # update path helpers used in templates
  set :http_path, '/'
  set :css_path, '/stylesheets'
  set :js_path, '/javascripts'
  set :images_path, '/images'

  # if a specific theme is being built
  if ENV['theme']

    # set build directory name
    set :build_dir, "#{ENV['theme']}"

    # set http_prefix, used by the stylesheet_link_tag, javascript_include_tag, and image-url helpers
    set :http_prefix, "/#{ENV['theme']}/"

    # update path helpers used in templates
    set :http_path, "/#{ENV['theme']}"
    set :css_path, "/#{ENV['theme']}/stylesheets"
    set :js_path, "/#{ENV['theme']}/javascripts"
    set :images_path, "/#{ENV['theme']}/images"

  end

  # if a specific theme is being built AND will be deployed to html root on server
  if ENV['theme'] && ENV['root']

    # set build directory name
    set :build_dir, "#{ENV['theme']}"

    # set http_prefix, used by the stylesheet_link_tag, javascript_include_tag, and image-url helpers
    set :http_prefix, "/"

    # update path helpers used in templates
    set :http_path, "/"
    set :css_path, "/stylesheets"
    set :js_path, "/javascripts"
    set :images_path, "/images"

  end

  # http://middlemanapp.com/advanced/file-size-optimization/#gzip-text-files
  activate :gzip

  # http://middlemanapp.com/advanced/file-size-optimization/#minify-html
  # activate :minify_html

end
