DROP TABLE IF EXISTS branch CASCADE;
DROP TABLE IF EXISTS customer CASCADE;
DROP TABLE IF EXISTS loan CASCADE;
DROP TABLE IF EXISTS borrower CASCADE;
DROP TABLE IF EXISTS account CASCADE;
DROP TABLE IF EXISTS depositor CASCADE;

CREATE TABLE branch (
  branch_name VARCHAR(25) PRIMARY KEY,
  branch_city VARCHAR(25),
  assets NUMERIC(14, 2)
);

CREATE TABLE customer (
  id VARCHAR(5) PRIMARY KEY,
  customer_name VARCHAR(25),
  customer_street VARCHAR(25),
  customer_city VARCHAR(25)
);

CREATE TABLE loan (
  loan_number VARCHAR(5) PRIMARY KEY,
  branch_name VARCHAR(25) REFERENCES branch,
  amount NUMERIC(8, 2)
);

CREATE TABLE borrower (
  id VARCHAR(5) REFERENCES customer, 
  loan_number VARCHAR(5) REFERENCES loan,

  PRIMARY KEY (id, loan_number)
);

CREATE TABLE account (
  account_number VARCHAR(5) PRIMARY KEY,
  branch_name VARCHAR(25) REFERENCES branch,
  balance NUMERIC(14, 2)
);

CREATE TABLE depositor (
  id VARCHAR(5) REFERENCES customer,
  account_number VARCHAR(5) REFERENCES account,

  PRIMARY KEY(id, account_number)
);
