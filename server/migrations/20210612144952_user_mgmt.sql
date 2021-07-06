-- migrate:up

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO fluttermin_user;
ALTER DEFAULT PRIVILEGES REVOKE EXECUTE ON FUNCTIONS FROM public;

-- customized for listing app users
CREATE OR REPLACE VIEW fluttermin_users
  (user_id, last_name, first_name, email)
AS
  SELECT user_id, last_name, first_name, email, app_role
  FROM fluttermin.users
  ORDER BY last_name
;


-- decode JWT claims
CREATE OR REPLACE FUNCTION fluttermin_claims(token text)
RETURNS table(header json, payload json, valid boolean) LANGUAGE sql AS $$
    SELECT fluttermin_verify(token, current_setting('app.jwt_secret'));
$$ SECURITY DEFINER;

ALTER FUNCTION fluttermin_claims(token text) OWNER TO fluttermin_user;


-- migrate:down

DROP VIEW fluttermin_users CASCADE;
DROP FUNCTION IF EXISTS fluttermin_claims;
