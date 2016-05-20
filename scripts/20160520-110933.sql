alter table subscriptions add constraint subscriptions_country_check check(util.null_or_country_code(country));
