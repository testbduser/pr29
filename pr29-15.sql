ALTER TABLE sums ADD COLUMN u INTEGER;
SELECT * FROM sums;
UPDATE sums SET u = 0 WHERE s IS NULL;
SELECT * FROM sums;