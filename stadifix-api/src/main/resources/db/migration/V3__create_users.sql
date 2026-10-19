CREATE TABLE users (
       id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

       full_name VARCHAR(120) NOT NULL,

       email VARCHAR(254) NOT NULL,

       password_hash VARCHAR(255) NOT NULL,

       role VARCHAR(20) NOT NULL,

       created_at TIMESTAMPTZ NOT NULL
                  DEFAULT CURRENT_TIMESTAMP,

                  CONSTRAINT chk_users_role
                  CHECK (role IN ('CUSTOMER', 'PROVIDER'))
);

CREATE UNIQUE INDEX ux_users_email_lower
    ON users (LOWER(email));
