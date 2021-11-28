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
