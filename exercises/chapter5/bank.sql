SET search_path TO bank;

-- Changing it slightly so it works with what we were given in Chapter 3
DROP MATERIALIZED VIEW IF EXISTS branch_cust;
CREATE MATERIALIZED VIEW branch_cust
AS (
  SELECT branch_name, id
  FROM depositor, account
  WHERE depositor.account_number = account.account_number
);

CREATE OR REPLACE FUNCTION refresh_branch_cust()
RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
BEGIN
  REFRESH MATERIALIZED VIEW branch_cust;
END;
$$;

DROP TRIGGER IF EXISTS ex56 ON depositor;
DROP TRIGGER IF EXISTS ex56 on account;
CREATE TRIGGER ex56 BEFORE INSERT
ON depositor
EXECUTE PROCEDURE refresh_branch_cust();
CREATE TRIGGER ex56 BEFORE INSERT
ON account
EXECUTE PROCEDURE refresh_branch_cust();

-- Also reworked to work with my current schema
CREATE OR REPLACE FUNCTION delete_orphan_depositors(deleted_account VARCHAR(5))
RETURNS VOID
LANGUAGE plpgsql
AS
$$
BEGIN
  INSERT INTO other_account_depositors
  SELECT depositor.id
  FROM depositor
  WHERE depositor.account_number = deleted_account;

  INSERT INTO without_outer_accounts
  SELECT depositor.id
  FROM depositor
  LEFT JOIN account ON depositor.account_number = account.account_number
  WHERE depositor.id IN (SELECT * FROM other_account_depositors)
  AND account.account_number IS NULL;

  DELETE FROM depositor
  WHERE depositor.id IN (SELECT * FROM without_other_accounts);
END;
$$;

CREATE OR REPLACE FUNCTION ex57trigger() RETURNS TRIGGER AS $$
  BEGIN
    SELECT * FROM delete_orphan_depositors(OLD.account_number); 
  END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS ex57 ON "account";
CREATE TRIGGER ex57 AFTER DELETE
ON account
EXECUTE PROCEDURE ex57trigger();
