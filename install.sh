#!/bin/sh

psql -U postgres -c 'create database splashpagedb' postgres
psql -U postgres --no-align --tuples-only -c "SELECT 1 FROM pg_roles WHERE rolname='api'" | grep -q 1 || psql -U postgres -c 'create role api login PASSWORD NULL' postgres
psql -U postgres -c 'GRANT ALL ON DATABASE splashpagedb TO api' postgres
sem-apply --url postgresql://api@localhost/splashpagedb
