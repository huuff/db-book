-- For 5.4, first I just copy my ex48a function here

CREATE OR REPLACE FUNCTION ex48a()
RETURNS TABLE (
  id VARCHAR(5),
  sec_id VARCHAR(8),
  semester VARCHAR(6),
  year NUMERIC(4,0)
)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY(
    SELECT i1.id, s1.sec_id, s1.semester, s1.year
    FROM instructor i1
    NATURAL JOIN teaches t1
    NATURAL JOIN section s1
    NATURAL JOIN classroom c1
    WHERE EXISTS(
      SELECT *
      FROM instructor i2
      NATURAL JOIN teaches t2
      NATURAL JOIN section s2
      NATURAL JOIN classroom c2
      WHERE i1.id = i2.id 
      AND s1.semester = s2.semester
      AND s1.time_slot_id = s2.time_slot_id
      AND s1.year = s2.year
      AND c1.building != c2.building
    )
  );
END;
$$;

-- Then I do the trigger
CREATE OR REPLACE FUNCTION no_clones()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
  IF EXISTS (SELECT * FROM ex48a()) THEN
    RAISE EXCEPTION 'Instructors cannot be in two classrooms at the same time!';
  END IF;
END;
$$;

DROP TRIGGER IF EXISTS ex55 ON "section";
DROP TRIGGER IF EXISTS ex55 ON "teaches";
CREATE TRIGGER ex55 BEFORE UPDATE OR INSERT
ON teaches
EXECUTE PROCEDURE no_clones();

CREATE TRIGGER ex55 BEFORE UPDATE OR INSERT
ON section
EXECUTE PROCEDURE no_clones();

