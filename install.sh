#!/bin/sh

psql -U postgres -c 'create database "splashpage"' postgres
psql -U postgres -c 'create role api login PASSWORD NULL' postgres
psql -U postgres -c 'GRANT ALL ON DATABASE "splashpage" TO api' postgres
sem-apply --user api --host localhost --name splashpage