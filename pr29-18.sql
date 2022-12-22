DROP TABLE accs;
CREATE TABLE accs(usr VARCHAR(10), pass VARCHAR(50));
\dt
\d accs
INSERT INTO accs (usr, pass) VALUES ('test', '123');
SELECT * FROM accs;
