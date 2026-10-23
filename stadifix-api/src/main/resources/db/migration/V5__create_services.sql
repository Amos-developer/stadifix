
CREATE TABLE services (
                          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

                          provider_id UUID NOT NULL,
                          category_id UUID NOT NULL,

                          title VARCHAR(120) NOT NULL,
                          description VARCHAR(1000) NOT NULL,

                          starting_price NUMERIC(12, 2) NOT NULL,
                          currency VARCHAR(3) NOT NULL DEFAULT 'TZS',

                          is_active BOOLEAN NOT NULL DEFAULT TRUE,

                          created_at TIMESTAMPTZ NOT NULL
                              DEFAULT CURRENT_TIMESTAMP,

                          updated_at TIMESTAMPTZ NOT NULL
                              DEFAULT CURRENT_TIMESTAMP,

                          CONSTRAINT fk_services_provider
                              FOREIGN KEY (provider_id)
                                  REFERENCES provider_profiles(user_id),

                          CONSTRAINT fk_services_category
                              FOREIGN KEY (category_id)
                                  REFERENCES service_categories(id),

                          CONSTRAINT chk_services_positive_price
                              CHECK (starting_price > 0),

                          CONSTRAINT chk_services_currency
                              CHECK (currency = 'TZS')
);

CREATE INDEX idx_services_provider
    ON services(provider_id);

CREATE INDEX idx_services_category_active
    ON services(category_id, is_active);
