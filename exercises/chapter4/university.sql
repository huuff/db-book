CREATE OR REPLACE FUNCTION ex42a()
RETURNS TABLE (
  id VARCHAR(5),
  taught_sections BIGINT
)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY(
    SELECT instructor.id, COUNT(sec_id) as taught_sections
    FROM instructor
    LEFT OUTER JOIN teaches ON instructor.id = teaches.id
    GROUP BY instructor.id
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex42b()
RETURNS TABLE (
  id VARCHAR(5),
  taught_sections BIGINT
)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY(
    SELECT instructor.id, (
      SELECT count(*)
      FROM teaches
      WHERE teaches.id = instructor.id
    ) as taught_sections
    FROM instructor
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex42c(search_semester VARCHAR(6), search_year numeric(4,0))
RETURNS TABLE (
  title VARCHAR(50),
  sec_id VARCHAR(8),
  id VARCHAR(5),
  name VARCHAR(20)
)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY(
    SELECT course.title, section.sec_id, instructor.id, COALESCE(instructor.name, '-')
    FROM section
    NATURAL LEFT OUTER JOIN teaches
    NATURAL JOIN instructor
    JOIN course ON section.course_id = course.course_id
    WHERE section.semester = search_semester AND section.year = search_year
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex42d()
RETURNS TABLE (
  dept_name VARCHAR(20),
  instructor_count BIGINT
)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY (
    SELECT department.dept_name, COUNT(instructor.id) AS instructor_count
    FROM department
    NATURAL LEFT OUTER JOIN instructor
    GROUP BY department.dept_name
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex43a()
RETURNS TABLE (
  id VARCHAR(5),
  name VARCHAR(20),
  dept_name VARCHAR(20),
  tot_cred NUMERIC(3, 0),
  course_id VARCHAR(8),
  sec_id VARCHAR(8),
  semester VARCHAR(6),
  year NUMERIC(4, 0),
  grade VARCHAR(2)
)
LANGUAGE plpgsql
AS
$$
BEGIN
 RETURN QUERY (
 (SELECT * FROM student NATURAL JOIN takes)
  UNION ALL
 (SELECT *, NULL, NULL, NULL, NULL, NULL
  FROM student s
  WHERE NOT EXISTS (
      SELECT * FROM takes t WHERE t.id = s.id
    )
  )
);
END;
$$;

CREATE OR REPLACE FUNCTION ex43b()
RETURNS TABLE (
  id VARCHAR(5),
  name VARCHAR(20),
  dept_name VARCHAR(20),
  tot_cred NUMERIC(3, 0),
  course_id VARCHAR(8),
  sec_id VARCHAR(8),
  semester VARCHAR(6),
  year NUMERIC(4, 0),
  grade VARCHAR(2)
)
LANGUAGE plpgsql
AS
$$
BEGIN
 RETURN QUERY (
 (SELECT * FROM student NATURAL JOIN takes)
  UNION ALL
 (SELECT *, NULL, NULL, NULL, NULL, NULL
  FROM student s
  WHERE NOT EXISTS (
      SELECT * FROM takes t WHERE t.id = s.id
    )
  )
  UNION ALL
 (SELECT NULL, NULL, NULL, NULL, t.course_id, t.sec_id, t.semester, t.year, t.grade
  FROM takes t
  WHERE NOT EXISTS (
      SELECT * FROM student s WHERE t.id = s.id
    )
  )
);
END;
$$;

-- For 4.6 I'm going to just copy everything from 3.2

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

CREATE OR REPLACE VIEW ex46 AS SELECT * FROM ex32c();

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

-- 4.8.b
-- CREATE ASSERTION no_clone_instructors CHECK (SELECT * FROM ex48a())
