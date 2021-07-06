# Dockerfile

# Include the Ruby base image (https://hub.docker.com/_/ruby)
# in the image for this application, version 2.7.1.
FROM ruby:2.7.1

# Put all this application's files in a directory called /code.
# This directory name is arbitrary and could be anything.
WORKDIR /code
COPY . /code

# Run this command. RUN can be used to run anything. In our
# case we're using it to install our dependencies.
RUN bundle install

# Tell Docker to listen on port 4567.
EXPOSE 4567

# Tell Docker that when we run "docker run", we want it to
# run the following command:
# $ bundle exec rackup --host 0.0.0.0 -p 4567.
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "4567"]
# CMD ["bundle", "exec", "ruby", "myapp.rb"]

# build image again when changing the Dockerfile

# Dockercommands terminal

# build image
# docker build --tag myapp .

# run image
# docker run -p 80:4567 myapp