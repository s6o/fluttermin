-- migrate:up

-- private schema
CREATE SCHEMA fluttermin;

CREATE TABLE fluttermin.users (
  user_id SERIAL PRIMARY KEY
, email TEXT UNIQUE CHECK (email ~* '^.+@.+\..+$')
, pass TEXT NOT NULL CHECK (length(pass) < 512)
, first_name TEXT
, last_name TEXT
, api_role NAME NOT NULL DEFAULT 'fluttermin_user' CHECK (length(api_role) < 512)
, app_role TEXT DEFAULT 'admin'
);


CREATE OR REPLACE FUNCTION
fluttermin.check_role_exists() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles AS r WHERE r.rolname = new.api_role) THEN
        RAISE foreign_key_violation USING message =
            'unknown database role: ' || new.api_role;
        RETURN NULL;
    END IF;
    RETURN NEW;
END
$$;

DROP TRIGGER IF EXISTS ensure_user_role_exists ON fluttermin.users;
CREATE CONSTRAINT TRIGGER ensure_user_role_exists
    AFTER INSERT OR UPDATE ON fluttermin.users
    FOR EACH ROW
    EXECUTE PROCEDURE fluttermin.check_role_exists();


CREATE OR REPLACE FUNCTION
fluttermin.encrypt_pass() RETURNS TRIGGER
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' OR NEW.pass <> OLD.pass THEN
        NEW.pass = crypt(NEW.pass, gen_salt('bf'));
    END IF;
    RETURN NEW;
end
$$;

DROP TRIGGER IF EXISTS encrypt_pass ON fluttermin.users;
CREATE TRIGGER encrypt_pass
    BEFORE INSERT OR UPDATE ON fluttermin.users
    FOR EACH ROW
    EXECUTE PROCEDURE fluttermin.encrypt_pass();


CREATE TYPE fluttermin.jwt_token AS (
  token TEXT
);


CREATE OR REPLACE FUNCTION
fluttermin.user_role(email TEXT, pass TEXT) RETURNS NAME
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN (
        SELECT api_role FROM fluttermin.users
            WHERE users.email = user_role.email
                AND users.pass = crypt(user_role.pass, users.pass)
    );
END;
$$;


-- login goes to public/api schema
CREATE OR REPLACE FUNCTION
fluttermin_login(email TEXT, pass TEXT) RETURNS fluttermin.jwt_token
    LANGUAGE plpgsql
    AS $$
DECLARE
    _role NAME;
    result fluttermin.jwt_token;
BEGIN
    -- check email and password
    SELECT fluttermin.user_role(email, pass) INTO _role;
    IF _role IS NULL THEN
        RAISE invalid_password USING message = 'invalid user or password';
    END IF;

    SELECT fluttermin_sign(row_to_json(r), current_setting('app.jwt_secret')) AS token
    FROM (
        SELECT
          _role AS role,
          au.app_role,
          au.email,
          au.user_id,
          extract(epoch from now())::integer + 60*60 AS exp
        FROM fluttermin.users au
        WHERE au.email = fluttermin_login.email
    ) r
    INTO result;

    RETURN result;
END;
$$ SECURITY DEFINER;


-- main PostgREST connection role
CREATE ROLE fluttermin_postgres NOINHERIT LOGIN PASSWORD 'flUtTerm!n-PostgRes';

-- the fluttermin_anon is only allowed to log in
CREATE ROLE fluttermin_anon NOINHERIT;
GRANT fluttermin_anon TO fluttermin_postgres;

-- switch from public to your api schema if required
REVOKE ALL ON SCHEMA public FROM fluttermin_anon;
GRANT EXECUTE ON FUNCTION fluttermin_login(text, text) TO fluttermin_anon;

-- api user expected to have a JWT token
CREATE ROLE fluttermin_user NOINHERIT;
GRANT fluttermin_user TO fluttermin_postgres;
GRANT ALL ON SCHEMA public TO fluttermin_user;
GRANT ALL ON ALL TABLES IN SCHEMA public TO fluttermin_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO fluttermin_user;
GRANT ALL ON ALL ROUTINES IN SCHEMA public TO fluttermin_user;


-- migrate:down

REVOKE EXECUTE ON FUNCTION fluttermin_login(text, text) FROM fluttermin_anon;

REVOKE ALL ON ALL ROUTINES IN SCHEMA public FROM fluttermin_user;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM fluttermin_user;
REVOKE ALL ON ALL TABLES IN SCHEMA public FROM fluttermin_user;
REVOKE ALL ON SCHEMA public FROM fluttermin_user;

DROP ROLE fluttermin_user;
DROP ROLE fluttermin_anon;
DROP ROLE fluttermin_postgres;

DROP FUNCTION fluttermin_login;

DROP SCHEMA fluttermin CASCADE;
