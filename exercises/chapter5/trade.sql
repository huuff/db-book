-- TODO: as a changelog?

CREATE TABLE IF NOT EXISTS nyse(
  year NUMERIC(4, 0),
  month NUMERIC(2, 0),
  day NUMERIC(2, 0),
  shares_traded NUMERIC(6, 0),
  dollar_volume NUMERIC(10, 2),

  PRIMARY KEY (year, month, day)
);

DO $$
BEGIN
  IF NOT EXISTS (SELECT * FROM nyse)
  THEN
    INSERT INTO nyse (year, month, day, shares_traded, dollar_volume)
    SELECT 
      2000 + ROUND(RANDOM() * 21),
      ROUND(RANDOM() * 11),
      ROUND(RANDOM() * 31),
      ROUND(RANDOM() * 1000000),
      RANDOM() * 10000000
    FROM generate_series(1, 1000)
    ON CONFLICT (year, month, day) DO NOTHING;
  END IF;
END;
$$;

CREATE OR REPLACE VIEW ex59 AS (
  WITH ranked(year, month, day, rank, shares_tradedi, dollar_volume) AS (
    SELECT year, month, day, RANK() OVER (ORDER BY shares_traded DESC) AS rank, shares_traded, dollar_volume
    FROM nyse
  )
  SELECT *
  FROM ranked
);

CREATE OR REPLACE VIEW ex510 AS (
  SELECT year, month, day, SUM(shares_traded) as shares_traded, SUM(dollar_volume) as dollar_volume FROM nyse
  GROUP BY ROLLUP(year, month, day)
  ORDER BY year DESC
);
