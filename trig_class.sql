CREATE OR REPLACE FUNCTION kmeans_classify() RETURNS TRIGGER LANGUAGE 'plpgsql' AS
$$
DECLARE
    d0 FLOAT;  -- distance from sample to each of the clusters
    d1 FLOAT;

    -- "learned" cluster centers
    cx0 FLOAT = 8.0; -- class "0" cluster center
    cy0 FLOAT = 7.4;

    cx1 FLOAT = 2.6; -- class "1" cluster center 
    cy1 FLOAT = 1.6;
BEGIN
    -- compute distances
    d0 = sqrt((cx0 - NEW.x) * (cx0 - NEW.x) + (cy0 - NEW.y) * (cy0 - NEW.y));
    d1 = sqrt((cx1 - NEW.x) * (cx1 - NEW.x) + (cy1 - NEW.y) * (cy1 - NEW.y));

    IF d0 < d1 THEN --pick nearest cluster
       NEW.z = 0;
    ELSE
       NEW.z = 1;
    END IF;
    RETURN NEW;
END
$$;
