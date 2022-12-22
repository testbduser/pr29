CREATE FUNCTION solve_equation() RETURNS TRIGGER LANGUAGE 'plpgsql' AS
$$
DECLARE
    d FLOAT;
BEGIN
    d = NEW.b * NEW.b - 4.0 * NEW.a * NEW.c;
    IF d < 0.0 THEN
        RETURN NEW;
    END IF;
    IF d > 0.0 THEN
        NEW.x0 = (-NEW.b - sqrt(d)) / (2.0 * NEW.a);
        NEW.x1 = (-NEW.b + sqrt(d)) / (2.0 * NEW.a);
        RETURN NEW;
    END IF;
    NEW.x0 = -NEW.b / (2.0 * NEW.a);
    RETURN NEW;
END
$$;
CREATE TRIGGER quad_roots BEFORE INSERT ON quads FOR EACH ROW EXECUTE PROCEDURE solve_equation();
\d quads
