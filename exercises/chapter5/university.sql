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

-- I'll do 5.8 using 3.2

CREATE TABLE IF NOT EXISTS grade_points(
  grade VARCHAR(2) NOT NULL,
  points NUMERIC(3, 1) NOT NULL,

  PRIMARY KEY (grade)
);

INSERT INTO grade_points (grade, points)
  VALUES
    ('A+', 4.0),
    ('A', 4.0),
    ('A-', 3.7),
    ('B+', 3.3),
    ('B', 3.0),
    ('B-', 2.7),
    ('C+', 2.3),
    ('C', 2.0),
    ('C-', 1.7),
    ('D+', 1.3),
    ('D', 1.0),
    ('E', 0.0),
    ('F', 0.0)
ON CONFLICT (grade) DO NOTHING;

CREATE OR REPLACE FUNCTION ex32a(student_id VARCHAR(5))
RETURNS NUMERIC(4,1)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN (
    SELECT SUM(course.credits * grade_points.points)
    FROM student
    JOIN takes ON takes.id = student.id
    JOIN grade_points ON takes.grade = grade_points.grade
    JOIN course ON course.course_id = takes.course_id
    WHERE student.id = student_id
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex32b(student_id VARCHAR(5))
RETURNS NUMERIC(2,1)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN (
    SELECT ex32a(student_id) / SUM(course.credits)
    FROM student
    JOIN takes ON student.id = takes.id
    JOIN course ON course.course_id = takes.course_id
    WHERE student.id = student_id
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex32c()
RETURNS TABLE(student_id VARCHAR(5), gpa NUMERIC(2,1))
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY(
    SELECT student.id, ex32b(student.id)
    FROM student
  );
END;
$$;

CREATE OR REPLACE VIEW ex58 AS (
  WITH ranked(student_id, rank, gpa) AS ( 
    SELECT student_id, RANK() OVER(ORDER BY gpa DESC) as s_rank, gpa
    FROM ex32c()
  )
  SELECT *
  FROM ranked
  WHERE rank <= 10
);
