ALTER TABLE sums ENABLE TRIGGER tg_sum;
INSERT INTO sums (a, b) VALUES (11, 12);
SELECT * FROM sums;
