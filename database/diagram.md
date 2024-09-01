erDiagram
    USERS ||--o{ PRODUCTS : supplies
    USERS ||--o{ BOOKINGS : makes
    PRODUCT_TYPES ||--o{ PRODUCTS : categorizes
    PRODUCTS ||--o{ INVENTORY : has
    PRODUCTS ||--o{ PRICING : has
    INVENTORY ||--o{ BOOKINGS : reserved_in
    INVENTORY ||--o{ MAINTENANCE : undergoes
    BOOKINGS ||--o{ REVIEWS : receives
    BOOKINGS ||--o{ TRANSACTIONS : generates
    DISCOUNTS ||--o{ BOOKINGS : applies_to

    USERS {
        int id PK
        string email
        string password_hash
        string user_type
        string first_name
        string last_name
    }

    PRODUCT_TYPES {
        int id PK
        string name
        string description
    }

    PRODUCTS {
        int id PK
        int supplier_id FK
        int product_type_id FK
        string name
        string description
        decimal daily_rate
    }

    INVENTORY {
        int id PK
        int product_id FK
        string status
        string serial_number
        boolean is_consumable
        int quantity
    }

    BOOKINGS {
        int id PK
        int customer_id FK
        int inventory_id FK
        date start_date
        date end_date
        decimal total_price
        string status
    }

    MAINTENANCE {
        int id PK
        int inventory_id FK
        string description
        date maintenance_date
        boolean completed
    }

    REVIEWS {
        int id PK
        int booking_id FK
        int rating
        string comment
    }

    TRANSACTIONS {
        int id PK
        int booking_id FK
        decimal amount
        string transaction_type
        string status
    }

    PRICING {
        int id PK
        int product_id FK
        date start_date
        date end_date
        decimal daily_rate
    }

    DISCOUNTS {
        int id PK
        string code
        string discount_type
        decimal value
        date start_date
        date end_date
    }

    SETTINGS {
        int id PK
        string key
        string value
    }

    AUDIT_LOGS {
        int id PK
        int user_id FK
        string action
        string table_name
        int record_id
        jsonb old_values
        jsonb new_values
    }