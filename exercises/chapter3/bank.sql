SET search_path TO bank;

CREATE OR REPLACE FUNCTION ex38a()
RETURNS TABLE ( id VARCHAR(5))
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY (
    SELECT customer.id
    FROM customer
    WHERE NOT EXISTS (
      SELECT *
      FROM borrower
      WHERE borrower.id = customer.id
    )
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex38b(searching_id VARCHAR(5))
RETURNS TABLE ( id VARCHAR(5) )
LANGUAGE plpgsql
AS
$$
DECLARE
  searching_street VARCHAR(25) := (SELECT customer.customer_street FROM customer WHERE customer.id = searching_id);
  searching_city VARCHAR(25) := (SELECT customer.customer_city FROM customer WHERE customer.id = searching_id);
BEGIN
  RETURN QUERY (
    SELECT customer.id
    FROM customer
    WHERE customer.customer_street = searching_street AND customer.customer_city = searching_city
  );
END;
$$;

CREATE OR REPLACE FUNCTION ex38c(searching_city VARCHAR(25))
RETURNS TABLE ( branch_name VARCHAR(25))
LANGUAGE plpgsql
AS
$$
BEGIN
  RETURN QUERY (
    SELECT DISTINCT(branch.branch_name)
    FROM branch
    JOIN account ON account.branch_name = branch.branch_name
    JOIN depositor ON depositor.account_number = account.account_number
    JOIN customer ON depositor.id = customer.id
    WHERE customer_city = searching_city
  );
END;
$$;
