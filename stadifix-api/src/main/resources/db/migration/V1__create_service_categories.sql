CREATE TABLE service_categories (
       id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
       name VARCHAR(80) NOT NULL UNIQUE,
       description VARCHAR(255),
       created_at TIMESTAMPTZ NOT NULL
       DEFAULT CURRENT_TIMESTAMP
);
