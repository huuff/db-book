# Written exercises

## 6.1
```mermaid
erDiagram
  customer {
    string name
    string address
  }
  car {
    string license_plate
  }
  accident {
    date accident_date
    string description
  }
  insurance_policy {

  }
  payment {
    date date_received
    date date_due
    numeric amount
  }

  customer ||--o{ car : owns
  car ||--o{ accident : recorded
  insurance_policy |o--|{ car : covers
  insurance_policy ||--o{ payment : premium
```

## 6.2

### a)
`mermaid.js` doesn't allow for ternary relationships in entity-relationship diagrams so I'll take it as an excuse to skip this.

### b)
```mermaid
erDiagram
  student {
    string name
    integer credits
  }
  course {
    string id
  }

  section {
    numeric year
    string semester
  }

  mark {
    numeric grade
  }

  student }o--o{ section : takes
  section }o--|| course : offered_by
  
  student ||--o| mark : received
  section ||--o| mark : in
```

## 6.3
```mermaid
erDiagram
  match {
    date match_date
  }

  score {
    numeric home_score
    numeric away_score
  }

  player {
    string name
  }

  match ||--|| score : result
  match }o--|{ player : played
```

Can't do derived attributes with mermaid but don't think these matter too much for the substance of this chapter.

## 6.4
The maintenance costs of having to update each occurrence whenever there's a change are higher, and also the possibility of one occurrence not being updated sneaks in, thus causing inconsistencies.
