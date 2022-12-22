CREATE EXTENSION file_fdw;
CREATE SERVER file_srv FOREIGN DATA WRAPPER file_fdw;
CREATE FOREIGN TABLE synth_data (x FLOAT, y FLOAT, z INTEGER) SERVER file_srv 
OPTIONS (filename '/home/postgres/pr29/synth_data.csv', format 'csv');
SELECT * FROM synth_data;
INSERT INTO kmeans_test (x, y) SELECT x, y FROM synth_data;
SELECT * FROM kmeans_test;
