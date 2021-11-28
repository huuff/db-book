DROP TABLE IF EXISTS employee CASCADE;
DROP TABLE IF EXISTS works CASCADE;
DROP TABLE IF EXISTS company CASCADE;
DROP TABLE IF EXISTS manages CASCADE;

CREATE TABLE employee(
  id INTEGER PRIMARY KEY,
  person_name VARCHAR(25),
  street VARCHAR(25),
  city VARCHAR(25)
);

CREATE TABLE company(
  company_name VARCHAR(25) PRIMARY KEY,
  city VARCHAR(25)
);

CREATE TABLE works(
  id INTEGER PRIMARY KEY,
  company_name VARCHAR(25) REFERENCES company,
  salary NUMERIC(10, 2)
);

-- The ordering of the attributes suggest that managed_by is a better name?
CREATE TABLE manages(
  id INTEGER PRIMARY KEY REFERENCES employee,
  manager_id INTEGER REFERENCES employee
)
