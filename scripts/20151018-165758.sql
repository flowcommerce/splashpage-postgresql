create or replace function make_user(
  email text,
  start_date text,
  num integer
) returns text language plpgsql as $$
declare
  v_otto_id text;
  v_user_id text;
begin
  v_otto_id = 'usr-' || start_date || '-1';

  v_user_id = 'usr-' || start_date || '-' || num;
  insert into users (id, updated_by_user_id) values (v_user_id, v_otto_id);

  insert into emails
  (id, user_id, email, is_primary, updated_by_user_id)
  values
  ('eml-' || start_date || '-' || num, v_user_id, email, true, v_otto_id);

  return v_user_id || ': ' || email;
end;
$$;

select make_user('otto@flow.io', '20151006', 1);
select make_user('anonymous@flow.io', '20151006', 2);

drop function make_user(text, text, integer);

insert into tokens
(id, user_id, token, description, updated_by_user_id)
values
('tok-20151018-1', 'usr-20151006-1', 'development', 'Initial API token created for system user', 'usr-20151006-1');
