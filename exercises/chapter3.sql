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
