#! /bin/bash
export PGPASSWORD=<your_password>;
psql -h redshift_endpoint -U awsuser -d redshiftcourse -p 5439 -f data_load.sql
