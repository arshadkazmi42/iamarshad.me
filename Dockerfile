FROM ruby:3.1.4-slim

# System deps for sqlite + native gem builds
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
      build-essential \
      libsqlite3-dev \
      nodejs \
      git \
      curl \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Bundle deps first (cache layer)
COPY Gemfile Gemfile.lock* ./
RUN gem install bundler && bundle install --jobs 4

# App source
COPY . .

# Precompile tailwind + asset pipeline output
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=1
ENV SECRET_KEY_BASE=placeholder_for_assets_precompile
RUN bundle exec rails assets:precompile

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
