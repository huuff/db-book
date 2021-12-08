SET search_path TO insurance; 

CREATE OR REPLACE FUNCTION ex34a(query_year NUMERIC(4, 0))
RETURNS BIGINT
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN (
    SELECT COUNT(DISTINCT person.driver_id)
    FROM person
    JOIN participated ON participated.license_plate = participated.driver_id
    JOIN accident ON participated.report_number = accident.report_number
    WHERE accident.year = query_year
  );
END;
$$;

CREATE OR REPLACE PROCEDURE ex34b(delete_driver_id VARCHAR(5))
LANGUAGE plpgsql
AS
$$
BEGIN
  DELETE FROM car
  WHERE
    car.year = 2010 AND
    car.license_plate IN (
      SELECT license_plate
      FROM owns
      WHERE owns.driver_id = delete_driver_id
    );
END;
$$;
