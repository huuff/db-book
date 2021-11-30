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

-- CREATE OR REPLACE FUNCTION ex43a()
-- RETURNS TABLE (
  -- id VARCHAR(5),
  -- name VARCHAR(20),
  -- dept_name VARCHAR(20),
  -- tot_cred NUMERIC(3, 0),
  -- course_id VARCHAR(8),
  -- sec_id VARCHAR(8),
  -- semester VARCHAR(6),
  -- year NUMERIC(4, 0),
  -- grade VARCHAR(2)
-- )
-- LANGUAGE plpgsql
-- AS
-- $$
-- BEGIN
  
-- END;
-- $$;
