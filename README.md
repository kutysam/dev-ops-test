# Interview Steps

## Step 1: Running things locally

* Fork this Repo. 

* Install Ruby using RVM or rbenv. Check ruby version in gemfile.

* Use command to install dependencies
```sh
bundle install
```

* Install postgres and also create user using 
```sql 
create role myapp with createdb login password 'password1';
```

* Create Database using 
```sh
rake db:setup
``` 

* Database initialization using 
```sh 
rails db:migrate
```

* Run the app using 
```sh
rails server
```

* Navigate to  http://localhost:3000



## Step 2: Running the APP in GCP

* Dockerize the app

* Write a script to deploy to GCP. Will let you decide on what GCP service you want deploy to but it need to autoscale and make sure you handle secrets properly. 

* Set up a CD to deploy to GCP. 

## Step 3: Terraform - if time permites
* Move the entire infra into terraform. 



