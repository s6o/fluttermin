-- migrate:up

ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL ON TABLES TO fluttermin_user;

CREATE OR REPLACE VIEW fluttermin_users
  (user_id, last_name, first_name, email)
AS
  SELECT user_id, last_name, first_name, email
  FROM fluttermin.users
  ORDER BY last_name

-- migrate:down

DROP VIEW fluttermin_users CASCADE;
