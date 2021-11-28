CREATE OR REPLACE FUNCTION ex39a(search_company_name VARCHAR(25))
RETURNS TABLE (
  id INTEGER,
  person_name VARCHAR(25),
  city VARCHAR(25)
)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY (
    SELECT employee.id, employee.person_name, employee.city
    FROM employee
    JOIN works ON works.id = employee.id
    JOIN company ON company.company_name = works.company_name
    WHERE company.company_name = search_company_name
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex39b(search_company_name VARCHAR(25))
RETURNS TABLE (
  id INTEGER,
  person_name VARCHAR(25),
  city VARCHAR(25)
)
LANGUAGE plpgsql
AS
$$
BEGIN
    RETURN QUERY (
      SELECT emp.id, emp.person_name, emp.city
      FROM ex39a(search_company_name) as emp
      JOIN works ON emp.id = works.id
      WHERE works.salary > 10000
    );
END;
$$;

CREATE OR REPLACE FUNCTION ex39c(search_company_name VARCHAR(25))
RETURNS TABLE (id INTEGER)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY (
    SELECT employee.id
    FROM employee
    WHERE employee.id NOT IN (
      SELECT works.id
      FROM works
      WHERE works.company_name = search_company_name
    )
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex39d(search_company_name VARCHAR(25))
RETURNS TABLE (id INTEGER)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY (
    SELECT employee.id
    FROM employee
    JOIN works ON employee.id = works.id
    WHERE works.salary >all (
      SELECT works.salary
      FROM ex39a(search_company_name) AS emp
      JOIN works ON emp.id = works.id
    )
  );
END;
$$;
