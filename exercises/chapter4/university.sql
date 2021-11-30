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
