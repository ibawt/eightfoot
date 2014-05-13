Eightfoot
=========

Eightfoot is a GitHub issue tracker for teams.

[![Build Status](https://travis-ci.org/ibawt/eightfoot.png?branch=master)](https://travis-ci.org/ibawt/eightfoot)
[![Code Climate](https://codeclimate.com/github/ibawt/eightfoot.png)](https://codeclimate.com/github/ibawt/eightfoot)

##### Features and Use Cases

- Create a project that pulls in issues across multiple private/public repositories
- Create many projects and pre-filter the repo issues to create custom views for different roles in your organization (e.g., "Project Design", "Project Features", "Project Bugs")
- Quickly and easily filter the issues by assignee username, title, or label to gain quick insight
- Create as many status columns as you wish, with no restrictive rules
- Does not corrupt your GitHub issues as your source of truth with labels
- Eliminates the need for an external state-tracking platform for teams that care about getting things done

##### Screen Shot
![Screenshot of eightfood](https://raw.github.com/ibawt/eightfoot/master/screenshot.png)

##### Progress
![Screenshot of eightfood](https://raw.github.com/ibawt/eightfoot/master/progress_gif.gif)

We thought you might like to take a look at the design of eightfoot as we iterated on hackdays :)

#### Setup
-----

1. `bundle install`
2. `bundle exec rake db:setup db:migrate db:test:clone` (it doesn't auto-migrate atm)
3. Create an [application on GitHub](https://github.com/settings/applications/new), make the URL and callback URL http://localhost:4000
4. `export CLIENT_ID=#{the ID the application in step 4 made}`
5. `export CLIENT_SECRET=#{the secret the application in step 4 made}`
6. `bundle exec foreman`
7. Visit [http://localhost:4000](http://localhost:4000) and log in with your GitHub account credentials

Try not testing it against any majorly sensitive repos right now!!

### Development
1. set an environment variable 'TEST_API_TOKEN'
2. this will let you record new tests with VCR

#### TODO:

 - Cull issues that are closed and not opend after signifant time?
 - Display branch status ci for PR's
 - Be more intelligent about updating issues (with 2000 issues, things get really slow)
 - Add colour PR's differently (currently only the fork shows them as different)
