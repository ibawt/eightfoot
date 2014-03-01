# eightfoot
=========

github issue tracker

#### Screen Shot
![Screenshot of eightfood](https://raw.github.com/ibawt/eightfoot/master/screenshot.png)

#### Progress 
![Screenshot of eightfood](https://raw.github.com/ibawt/eightfoot/master/progress_gif.gif)

### Setup
-----

1. `bundle install`
2. `bundle exec rake db:setup`
3. `bundle exec rake db:migrate` (it doesn't auto-migrate atm)
4. Create an application on GitHub, make the URL and callback URL http://localhost:3000
5. `export CLIENT_ID=#{the ID the application in step 4 made}`
6. `export CLIENT_SECRET=#{the secret the application in step 4 made}`
7. `bundle exec rails s`
8. Visit [http://localhost:3000](http://localhost:3000) and log in with your GitHub account credentials

Try not testing it against any majorly sensitive repos right now!!

### TODO:

 - Cull issues that are closed and not opend after signifant time?
 - Display branch status ci for PR's

