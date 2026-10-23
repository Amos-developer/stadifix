CREATE TABLE provider_profiles (
             user_id UUID PRIMARY KEY,

             display_name VARCHAR(120) NOT NULL,

             bio VARCHAR(500),

             service_area VARCHAR(120) NOT NULL,

              created_at TIMESTAMPTZ NOT NULL
                         DEFAULT CURRENT_TIMESTAMP,

                         CONSTRAINT fk_provider_profiles_user
                         FOREIGN KEY (user_id)
                         REFERENCES users(id)
                         ON DELETE CASCADE
);
