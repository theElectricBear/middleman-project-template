# http://scottwb.com/blog/2012/02/24/middleman-deployment-rakefile/

desc "Run the preview server at http://localhost:4567"
task :preview do
  system("bundle exec middleman server")
end

desc "Build the website from source"
task :build do
  puts "## Building site"
  system("gulp build")
  status = system("bundle exec middleman build --clean")
  puts status ? "OK" : "FAILED"
end

desc "Deploy latest build to server"
task :deploy do
  puts "## Deploying site"
  status = system("bundle exec middleman deploy")
  puts status ? "OK" : "FAILED"
 end
