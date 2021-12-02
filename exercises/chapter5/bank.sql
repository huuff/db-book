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
