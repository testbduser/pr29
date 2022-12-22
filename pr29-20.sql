DROP TABLE logs;
CREATE TABLE logs(ts TIMESTAMP DEFAULT now(), evt VARCHAR(100));
\d
\d logs
