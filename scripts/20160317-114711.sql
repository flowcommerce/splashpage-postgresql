alter table subscriptions drop latitude;
alter table subscriptions drop longitude;
alter table subscriptions add country text check(util.null_or_lower_non_empty_trimmed_string(country));
