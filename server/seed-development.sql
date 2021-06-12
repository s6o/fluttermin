INSERT INTO fluttermin.users
  (email, pass, first_name, last_name)
VALUES
  ('john.doe@lost.net', 'johnny88', 'John', 'Doe')
, ('jane.doe@lost.net', 'jenny678', 'Jane', 'Doe')
ON CONFLICT DO NOTHING
;
