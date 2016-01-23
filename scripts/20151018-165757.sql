-- if user service were online, we would use that directly. Instead,
-- replicate the schema to do basic auth here.

drop table if exists tokens;
drop table if exists emails;
drop table if exists users;

create table users (
  id                       text not null primary key
);

select audit.setup('public', 'users');

comment on table users is '
  Top level table identifying users. We anticipate having users
  created through a variety of means - e.g. via registration with
  an email address or via a mobile device token. Thus the user table
  to start with is just a id.
';

create table emails (
  id                       text not null primary key,
  user_id                  text not null references users,
  email                    text not null check (util.non_empty_trimmed_string(email)),
  is_primary               boolean not null
);

select audit.setup('public', 'emails');
create unique index emails_lower_email_un_idx on emails(lower(email)) where deleted_at is null;
create unique index emails_user_id_primary_un_idx on emails(user_id) where deleted_at is null and is_primary;
create index on emails(user_id);

comment on table emails is '
  Stores email addresses for users - each user will have 0 or more
  email addresses, each of which is globally unique.
';

create table tokens (
  id                       text not null primary key,
  user_id                  text not null references users,
  token                    text not null check (util.non_empty_trimmed_string(token)),
  description              text
);

select audit.setup('public', 'tokens');
create unique index tokens_token_un_idx on tokens(token) where deleted_at is null;
create index on tokens(user_id);

comment on table tokens is '
  API tokens for users.
';
