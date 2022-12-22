INSERT INTO quads (a, b, c) VALUES (1, 4, 1);
SELECT * FROM quads;
DELETE FROM quads WHERE a = 1.0 AND b = 4.0 AND c = 1.0;
SELECT * FROM logs;
