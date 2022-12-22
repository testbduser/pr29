DELETE FROM kmeans_test;
INSERT INTO kmeans_test (x, y) SELECT random() * 10, random() * 10 FROM generate_series(1, 50);
SELECT * FROM kmeans_test LIMIT 10;
