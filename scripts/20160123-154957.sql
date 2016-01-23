select journal.refresh_journaling('public', 'subscriptions', 'journal', 'subscriptions');
select journal.refresh_journaling('public', 'users', 'journal', 'users');
select journal.refresh_journaling('public', 'emails', 'journal', 'emails');
select journal.refresh_journaling('public', 'tokens', 'journal', 'tokens');
