drop table if exists subscriptions;

create table subscriptions (
  id                      text primary key,
  publication             text not null check (util.lower_non_empty_trimmed_string(publication)),
  email                   text not null check (util.non_empty_trimmed_string(email)),
  ip_address              text check(util.null_or_non_empty_trimmed_string(ip_address)),
  latitude                text check(util.null_or_non_empty_trimmed_string(latitude)),
  longitude               text check(util.null_or_non_empty_trimmed_string(longitude)),
  constraint subscriptions_latitude_longitude_ck check
    ( (latitude is null and longitude is null)
      OR (latitude is not null and longitude is not null) )
);

select audit.setup('public', 'subscriptions');
create unique index subscriptions_lower_email_un_idx on subscriptions(lower(email)) where deleted_at is null;

comment on table subscriptions is '
  Keeps track of which publications a user has signed up for. If a
  user turns off a publication, we mark that record deleted
  (deleted_at).
';
