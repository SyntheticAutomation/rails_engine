# README
Turing Mod 3 Backend Engineering 1810
Solo Project: Rails Engine

A Turing School API created with Ruby on Rails. More information can be found in this blog post:
`https://medium.com/@syntheticauto900/rails-bootcamp-module-3-project-1-retrospective-summary-ce73703fd22e`


This project adheres the spec requirements listed on this site:

`http://backend.turing.io/module3/projects/rails_engine`

The waffle project management board for this project can be found here:

`https://waffle.io/SyntheticAutomation/rails_engine`

We utilized a database that was created already for us, found at:

`https://github.com/turingschool-examples/sales_engine/tree/master/data`

This project was an opportunity to explore creating our own API that returns a bunch of business analytics. Some of the main things I got to practice:

- Serialization
- JSON API Compliance
- Building our first Rake Task
- RESTful API design
- Single Responsibility Principle design
- Test Driven Development
- Endpoint creation
- Database relationships
- Rails development (including routing)
- Business Intelligence metrics
- MVC and Rails development
- Advanced ActiveRecord queries
- Database relationships and migrations
- Agile and project management tools
- Nested Resources
- Namespacing
- Deeply Nested Hashes
------------------------------------------
## **Business Intelligence**
This API can send the following information:
1. top x merchants ranked by total revenue
2. top x merchants ranked by total number of items sold
3. total revenue for date x across all merchants
4. total revenue for that merchant across successful transactions
5. total revenue for that merchant for a specific invoice date x
6. customer who has conducted the most total number of successful transactions
7. top x items ranked by total revenue generated
8. top x item instances ranked by total number sold
9. the date with the most sales for the given item using the invoice date


# **Setup**
You will need Rails version 5.2.x.
```
gem install rails -v 5.2.2
```
Clone down this repo via SSH:
```
git clone git@github.com:SyntheticAutomation/rails_engine.git
```
From a shell, navigate into the project directory:
```
cd rails_engine
```
Make sure your gemfile is up to date:
```
bundle update
```
Build the database in postgresql:
```
rake db:{drop,create,migrate,seed}
```
Run my custom rake task found in lib/tasks/import.rake:
```
rake import:all
```
Start up your server:
```
rails s
```
Open your browser and explore this url's endpoints. Take a look at the config/routes.rb file to see endpoints. Start with:
```
localhost:3000/api/v1/
```

From the command line run
```
rspec
```
Green is passing. Red is failing.

Test suite included use of:

- rspec
- capybara
- shoulda-matchers
- FactoryBot
- Faker

## Acknowledgments

Project Leads/Instructors:
* Sal Espinosa
* Mike Dao
