DROP TABLE IF EXISTS person CASCADE;
DROP TABLE IF EXISTS car CASCADE;
DROP TABLE IF EXISTS accident CASCADE;
DROP TABLE IF EXISTS owns CASCADE;
DROP TABLE IF EXISTS participated CASCADE;

CREATE TABLE person (
  driver_id VARCHAR(5) PRIMARY KEY,
  name VARCHAR(25),
  address VARCHAR(50)
);

CREATE TABLE car (
  license_plate VARCHAR(10) PRIMARY KEY,
  model VARCHAR(25),
  year NUMERIC(4, 0)
);

CREATE TABLE accident (
  report_number VARCHAR(5) PRIMARY KEY,
  year NUMERIC(4, 0),
  location VARCHAR(50)
);

CREATE TABLE owns (
  driver_id VARCHAR(5) REFERENCES person ON DELETE CASCADE,
  license_plate VARCHAR(10) REFERENCES car ON DELETE CASCADE,

  PRIMARY KEY (driver_id, license_plate)
);

CREATE TABLE participated (
  report_number VARCHAR(5) REFERENCES accident ON DELETE CASCADE,
  license_plate VARCHAR(10) REFERENCES car ON DELETE CASCADE,
  driver_id VARCHAR(5) REFERENCES person ON DELETE CASCADE,
  damage_amount NUMERIC(8, 2),

  PRIMARY KEY (report_number, license_plate)
);
