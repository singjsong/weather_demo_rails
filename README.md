# Weather Demo in Rails

# Installation/Usage
Make sure both Ruby (tested on 2.7.1) and Postgres (tested on 12.3) are installed.

Clone repo.

Install gems: `bundle`

Create Postgres role: `createuser -P -d sites_user`. Enter `sites_pass` for the password 
(which is what is used in `database.yml`).

Set up database/run migration: `rails db:setup`

Run server: `rails s`

Navigate to `http://localhost:3000/admin/sites`. Add sites by uploading a CSV file.
To bulk edit, select sites, and select Batch Edit Selected from Batch Actions.
