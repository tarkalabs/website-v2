# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page '/projects/*', layout: 'project'
page '/technologies/*', layout: 'technology'

activate :directory_indexes
activate :livereload
activate :sprockets

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy(
#   '/this-page-has-no-template.html',
#   '/template-file.html',
#   locals: {
#     which_fake_page: 'Rendering a fake page with a local variable'
#   },
# )

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# helpers do
#   def some_helper
#     'Helping'
#   end
# end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

# configure :build do
#   activate :minify_css
#   activate :minify_javascript
# end

#Custom helpers

helpers do
  def technology_links(tech_csv)
    technologies = tech_csv.split(',').map(&:strip)
    tech_pages = app.sitemap.resources.select {|r| r.data['category'] && r.data['category'].downcase == 'technology'}
    tech_pages_map = tech_pages.inject({}) {|map, page| map[page.data['name'].downcase] = "/#{page.path}"; map}

    technologies.inject({}) {|map, tech| map[tech] = tech_pages_map[tech.downcase]; map }
  end

  def project_links(tech_page)
    tech_name = tech_page.data['name'].downcase
    projects = app.sitemap.resources.select do |r|
      r.data['category'] && r.data['category'].downcase == 'project' &&
          r.data['technologies'] && r.data['technologies'].downcase.include?(tech_name)
    end
    projects.inject({}) {|map, project| map[project.data['name']] = "/#{project.path}"; map}
  end
end
