DROP FUNCTION log_event;
CREATE FUNCTION log_event() RETURNS TRIGGER LANGUAGE 'plpgsql' AS
$$
BEGIN
  INSERT INTO logs (evt) VALUES (concat('account "', OLD.usr, '" deleted'));
  RETURN OLD;
END
$$;
CREATE TRIGGER tg_log BEFORE DELETE ON accs FOR EACH ROW EXECUTE PROCEDURE log_event();
\d accs
DELETE FROM accs WHERE usr = 'test';
SELECT * FROM accs;
SELECT * FROM logs;
