CREATE OR REPLACE FUNCTION ex31a()
RETURNS TABLE(title VARCHAR(50))
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY(
    SELECT course.title
    FROM course
    WHERE course.dept_name = 'Comp. Sci.'
      AND course.credits = 3
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex31b(instructor_name VARCHAR(20))
RETURNS TABLE(id VARCHAR(5))
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY(
    SELECT DISTINCT student.id
    FROM student
    JOIN takes ON student.id = takes.id
    JOIN teaches ON takes.course_id = teaches.course_id
    JOIN instructor ON teaches.id = instructor.id
    WHERE instructor.name = instructor_name
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex31c()
RETURNS NUMERIC(8, 2)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN (
    SELECT salary
    FROM instructor
    WHERE salary >=all (
      SELECT salary
      FROM instructor
    )
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex31d()
RETURNS VARCHAR(20)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN (
    SELECT instructor.name
    FROM instructor
    WHERE instructor.salary = (SELECT ex31c())
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex31e(section_year NUMERIC(4, 0))
RETURNS TABLE(
  course_id VARCHAR(8),
  sec_id VARCHAR(8),
  enrollment BIGINT
)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY(
    SELECT  
      section.course_id,
      section.sec_id,
      COUNT(DISTINCT(takes.id)) AS enrollment
    FROM section
    JOIN takes ON takes.course_id = section.course_id
    WHERE section.semester = 'Fall' AND section.year = section_year
    GROUP BY (section.course_id, section.sec_id)
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex31f(section_year NUMERIC(4, 0))
RETURNS BIGINT
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN (
    SELECT MAX(enrollment)
    FROM ex31e(section_year)
  ); 
END;
$$;

CREATE OR REPLACE FUNCTION ex31g(section_year NUMERIC(4, 0))
RETURNS TABLE(
  course_id VARCHAR(8),
  sec_id VARCHAR(8)
)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY(
    SELECT section_enrollments.course_id, section_enrollments.sec_id
    FROM ex31e(section_year) as section_enrollments
    WHERE section_enrollments.enrollment = (SELECT ex31f(section_year))
  );
END;
$$;

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

INSERT INTO takes (id, course_id, sec_id, semester, year, grade)
  WITH
    first_section AS (SELECT * FROM section LIMIT 1),
    first_student AS (SELECT * FROM student LIMIT 1)
  SELECT first_student.id, first_section.course_id, first_section.sec_id, first_section.semester, first_section.year, NULL
  FROM first_section, first_student
ON CONFLICT (id, course_id, sec_id, semester, year) DO NOTHING;

-- All of them work with aggregates, and since these just ignore nulls,
-- they all work on nulls

CREATE OR REPLACE PROCEDURE ex33a()
LANGUAGE plpgsql
AS
$$
BEGIN
    UPDATE instructor
    SET salary = salary * 1.1
    WHERE dept_name = 'Comp. Sci.'
    ;
END;
$$;

-- Also have to remove from prereq or foreign key constraint fails
-- TODO: Ugly and with repetition --
CREATE OR REPLACE PROCEDURE ex33b()
LANGUAGE plpgsql
AS
$$
BEGIN
  WITH unoffered_courses AS (
    SELECT course.course_id
    FROM course
    WHERE course.course_id NOT IN (SELECT course_id FROM section)
  )
  DELETE FROM prereq
  WHERE 
    (course_id IN (SELECT * FROM unoffered_courses)) 
  OR 
    (prereq_id IN (SELECT * FROM unoffered_courses)); 

  WITH unoffered_courses AS (
    SELECT course.course_id
    FROM course
    WHERE course.course_id NOT IN (SELECT course_id FROM section)
  )
  DELETE FROM course
  WHERE course_id IN (SELECT * FROM unoffered_courses);
END;
$$;

-- Can't set salary to 10000, there's a constraint that the minimum
-- is 29001
CREATE OR REPLACE PROCEDURE ex33c()
LANGUAGE plpgsql
AS
$$
BEGIN
  INSERT INTO instructor (id, name, dept_name, salary)
    SELECT student.id, student.name, student.dept_name, 30000
    FROM student
    WHERE student.tot_cred > 100
  ON CONFLICT (id) DO NOTHING
  ;
END;
$$;
