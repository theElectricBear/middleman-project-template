###
# Compass
###

# Change Compass configuration
# http://blachniet.com/2014/04/29/middleman-foundation/
compass_config do |config|
  # Require any additional compass plugins here.
  config.add_import_path "bower_components/foundation/scss"

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
  proxy "/pages/#{page.name}.html", "/templates/page.html", :locals => { :page => page }, :ignore => true
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
    /bower_components\//,
    /node_modules\//,
    /images\//
    ]
end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

# http://middlemanapp.com/basics/pretty-urls/
activate :directory_indexes

# Add bower's directory to sprockets asset path
after_configuration do
  @bower_config = JSON.parse(IO.read("#{root}/.bowerrc"))
  sprockets.append_path File.join "#{root}", @bower_config["directory"]
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do

  # For example, change the Compass output style for deployment
  activate :minify_css, ignore: [
    'bower_components/*',
    'stylesheets/vendor/*'
  ]

  # Minify Javascript on build
  activate :minify_javascript, ignore: [
    'javascripts/vendor/*',
    'bower_components/*',
  ]

  # Enable cache buster
  activate :asset_hash, ignore: [
    'javascripts/vendor/*',
    'bower_components/*',
    'fonts/*',
    'images/*',
    'stylesheets/vendor/*'
  ]

  activate :autoprefixer, ignore: [
    'bower_components/*',
    'stylesheets/vendor/*'
  ]

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"

  # http://middlemanapp.com/advanced/file-size-optimization/#gzip-text-files
  activate :gzip

  # http://middlemanapp.com/advanced/file-size-optimization/#minify-html
  activate :minify_html

  # generate favicons
  # https://github.com/follmann/middleman-favicon-maker
  # https://css-tricks.com/favicon-quiz/
  # https://www.npmjs.com/package/grunt-favicons
  activate :favicon_maker, :icons => {
    "images/favicons/_260x260_white_bg.png" => [
    { icon: "favicon-196x196.png" },
    { icon: "favicon-160x160.png" },
    { icon: "favicon-96x96.png" },
    { icon: "favicon-32x32.png" },
    { icon: "favicon-16x16.png" },
    { icon: "favicon.png", size: "64x64" },
    { icon: "favicon.ico", size: "64x64,32x32,24x24,16x16" },
    { icon: "apple-touch-icon-152x152.png" },
    { icon: "apple-touch-icon-144x144.png" },
    { icon: "apple-touch-icon-120x120.png" },
    { icon: "apple-touch-icon-114x114.png" },
    { icon: "apple-touch-icon-76x76.png" },
    { icon: "apple-touch-icon-72x72.png" },
    { icon: "apple-touch-icon-60x60.png" },
    { icon: "apple-touch-icon-57x57.png" },
    { icon: "apple-touch-icon.png", size: "57x57" },
    { icon: "apple-touch-icon.png", size: "57x57" },
    { icon: "firefox-icon-16x16.png", size: "16x16" },
    { icon: "firefox-icon-30x30.png", size: "30x30" },
    { icon: "firefox-icon-32x32.png", size: "32x32" },
    { icon: "firefox-icon-48x48.png", size: "48x48" },
    { icon: "firefox-icon-60x60.png", size: "60x60" },
    { icon: "firefox-icon-64x64.png", size: "64x64" },
    { icon: "firefox-icon-90x90.png", size: "90x90" },
    { icon: "firefox-icon-120x120.png", size: "120x120" },
    { icon: "firefox-icon-128x128.png", size: "128x128" },
    { icon: "firefox-icon-256x256.png", size: "256x256" },
    { icon: "mstile-70x70.png", size: "70x70" },
    { icon: "mstile-144x144.png", size: "144x144" },
    { icon: "mstile-150x150.png", size: "150x150" },
    { icon: "mstile-310x310.png", size: "310x310" },
    { icon: "mstile-310x150.png", size: "310x150" },
    { icon: "windows-tile-144x144.png", size: "144x144"}
    ]
  }

end
