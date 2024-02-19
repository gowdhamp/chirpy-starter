# Dockerfile to build notes.gowdhamp.in

##############################
#### Stage 1: Build stage ####
##############################

FROM ruby:3.3.0-bullseye as builder

# Install build essentials
RUN apt-get update \
    && apt-get install -y build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Update and install Jekyll, Bundler
RUN gem update --system \
    && gem install jekyll bundler

WORKDIR /app

COPY ./notes .

RUN bundle install

# Build the site
RUN JEKYLL_ENV=production bundle exec jekyll b

###################################
#### Stage 2: Production stage ####
###################################

FROM nginx:latest

WORKDIR /usr/share/nginx/html

# Clean up the working dir
RUN rm -rf *

COPY --from=builder /app/_site /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
