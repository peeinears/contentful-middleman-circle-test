require 'dotenv/load'

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

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

# Proxy pages (https://middlemanapp.com/advanced/dynamic_pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# configure :development do
#   activate :livereload
# end

# Methods defined in the helpers block are available in templates
# helpers do
#   def some_helper
#     "Helping"
#   end
# end

module IssueSlug
  def issue_slug(issue)
    issue.title.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '')
  end
end

include IssueSlug

if app.data.respond_to?(:content)
  app.data.content.issues.values.each do |issue|
    slug = issue_slug(issue)
    proxy "/issues/#{slug}/index.html", "/issue.html", :locals => { :issue => issue }, :ignore => true
  end
end

helpers do
  include IssueSlug

  def issues
    data.content.issues.values
  end

  def issue_path(issue)
    "issues/#{issue_slug(issue)}"
  end

  def page_title
    current_page.data.title || current_page.metadata.try(:[], :locals).try(:[], :issue).try(:[], :title) || "LOGIC"
  end
end

activate :contentful do |f|
  f.space         = { content: ENV['CONTENTFUL_SPACE_ID'] }
  f.access_token  = ENV['CONTENTFUL_ACCESS_TOKEN']
  # f.cda_query     = QUERY
  f.content_types = { issues: 'issue' }
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

set :relative_links, true
activate :directory_indexes

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
end
