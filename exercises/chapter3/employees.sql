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

-- I think 3.9.e is impossible. The company name is a primary key so we can't have more
-- than one tuple in company with the same name, and thus we can't have more than city for the
-- same company name. The exercise says 'assume' it is possible however, I'm not sure whether it means
-- that it's possible with a different schema

CREATE OR REPLACE FUNCTION ex39f()
RETURNS TABLE (
  company_name VARCHAR(25),
  employees BIGINT
)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY (
    WITH companies_by_employees AS (
      SELECT company.company_name, COUNT(works.id) as employees
      FROM company
      JOIN works ON company.company_name = works.company_name
      GROUP BY company.company_name
    )
    SELECT cte.company_name, cte.employees
    FROM companies_by_employees as cte
    WHERE cte.employees >= (
      SELECT MAX(inner_cte.employees)
      FROM companies_by_employees as inner_cte
    )
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex39g(search_company_name VARCHAR(25))
RETURNS TABLE (
  company_name VARCHAR(25)
)
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY (
    SELECT company.company_name
    FROM company
    JOIN works ON company.company_name = works.company_name
    GROUP BY company.company_name
    HAVING AVG(works.salary) > (
      SELECT AVG(_works.salary)
      FROM company AS _company
      JOIN works AS _works ON _company.company_name = _works.company_name
      WHERE _company.company_name = search_company_name
    )
  );
END;
$$;

CREATE OR REPLACE PROCEDURE ex310a()
LANGUAGE plpgsql
AS
$$
BEGIN
  UPDATE employee
  SET city = 'Newton'
  WHERE employee.id = '12345';
END;
$$;

CREATE OR REPLACE PROCEDURE ex310b()
LANGUAGE plpgsql
AS
$$
BEGIN
  UPDATE works
  SET works.salary = CASE
    WHEN works.salary * 1.1 <= 100000 THEN works.salary * 1.1
    ELSE works.salary * 1.03
  END
  WHERE EXISTS (
    SELECT manages.manager_id
    WHERE manages.manager_id = works.id
  );
END;
$$;
