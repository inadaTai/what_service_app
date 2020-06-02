FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y nodejs mariadb-client yarn chromium-driver
RUN mkdir /what_app
WORKDIR /what_app
COPY Gemfile /what_app/Gemfile
COPY Gemfile.lock /what_app/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /what_app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
