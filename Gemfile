source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.4'

gem 'rails', '~> 7.0.8'
gem 'sprockets-rails'

# Database — landing page doesn't actually use it, but Rails needs ActiveRecord
# to boot. SQLite keeps setup zero-cost and the file is .gitignored.
gem 'sqlite3', '~> 1.4'

# Web server
gem 'puma', '~> 5.0'

# Hotwire stack
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'

# Styling
gem 'tailwindcss-rails'
gem 'sassc-rails'

# Windows tzinfo bundling
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Faster boot via cache
gem 'bootsnap', require: false

# Optional .env support for local dev
gem 'dotenv-rails'

group :development, :test do
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  gem 'web-console'
end
