DROP FUNCTION log_eventt;
CREATE OR REPLACE FUNCTION log_eventt() RETURNS TRIGGER LANGUAGE 'plpgsql' AS
$$
BEGIN
  IF OLD.usr = 'admin' THEN
    INSERT INTO logs (evt) VALUES ('an attempt to delete admin account!');
    RAISE NOTICE 'this will be reported!';
    RETURN NULL;
  END IF;
  INSERT INTO logs (evt) VALUES (concat('account "', OLD.usr, '" deleted'));
  RETURN OLD;
END
$$;
INSERT INTO accs (usr, pass) VALUES ('abc', '123');
SELECT * FROM accs;
DELETE FROM accs WHERE usr = 'abc';
SELECT * FROM accs;
SELECT * FROM logs;
