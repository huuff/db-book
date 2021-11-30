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

CREATE OR REPLACE FUNCTION ex42c()
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
    SELECT course.title, section.sec_id, instructor.id, instructor.name
    FROM section
    NATURAL JOIN teaches
    NATURAL JOIN instructor
    JOIN course ON section.course_id = course.course_id
    WHERE section.semester = 'Spring' AND section.year = '2008'
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
