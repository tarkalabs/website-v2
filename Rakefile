require 'bundler'
Bundler.require 

require 'open-uri'
require 'rss'

FEED_URL = 'https://medium.com/feed/tarkalabs'

desc "Import posts from medium"
task :import_posts do
    posts = []
    open(FEED_URL) do |body|
        feed = RSS::Parser.parse(body)
        feed.channel.items.each do |item|
            puts "Importing #{item.link} ..."
            post = {title: item.title, author: item.dc_creator, published_at: item.pubDate}
            page = open(item.link).read
            graph = OGP::OpenGraph.new(page)
            post[:link] = graph.url
            post[:image] = graph.image && graph.image.url
            posts << post
        end
    end
    File.write('data/posts.json', JSON.pretty_generate(posts))
end