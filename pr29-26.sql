SELECT * FROM logs;
\i trig_class.sql
\df
CREATE TABLE kmeans_test(x FLOAT, y FLOAT, z INTEGER);
\d
\d kmeans_test
CREATE TRIGGER kmeans_predict BEFORE INSERT ON kmeans_test FOR EACH ROW EXECUTE PROCEDURE kmeans_classify();
\d kmeans_test
