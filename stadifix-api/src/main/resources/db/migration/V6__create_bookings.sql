
-- Allow the database to verify that a booking's
-- provider matches the service's actual provider.
ALTER TABLE services
    ADD CONSTRAINT uq_services_id_provider
        UNIQUE (id, provider_id);

CREATE TABLE bookings (
                          id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

                          service_id UUID NOT NULL,
                          provider_id UUID NOT NULL,
                          customer_id UUID NOT NULL,

                          scheduled_for TIMESTAMPTZ NOT NULL,

                          service_address VARCHAR(255) NOT NULL,
                          customer_notes VARCHAR(1000),

                          quoted_price NUMERIC(12, 2) NOT NULL,

                          status VARCHAR(20) NOT NULL
                                              DEFAULT 'REQUESTED',

                          created_at TIMESTAMPTZ NOT NULL
                                              DEFAULT CURRENT_TIMESTAMP,

                          updated_at TIMESTAMPTZ NOT NULL
                                              DEFAULT CURRENT_TIMESTAMP,

                          CONSTRAINT fk_bookings_service_provider
                              FOREIGN KEY (service_id, provider_id)
                                  REFERENCES services(id, provider_id),

                          CONSTRAINT fk_bookings_customer
                              FOREIGN KEY (customer_id)
                                  REFERENCES users(id),

                          CONSTRAINT chk_bookings_price
                              CHECK (quoted_price > 0),
                              currency VARCHAR(3) NOT NULL DEFAULT 'TZS',

                          CONSTRAINT chk_bookings_currency
                              CHECK (currency = 'TZS'),

                          CONSTRAINT chk_bookings_status
                              CHECK (status IN (
                                                'REQUESTED',
                                                'ACCEPTED',
                                                'DECLINED',
                                                'CANCELLED',
                                                'COMPLETED'
                                  ))
);

CREATE INDEX idx_bookings_customer
    ON bookings(customer_id, created_at DESC);

CREATE INDEX idx_bookings_provider
    ON bookings(provider_id, created_at DESC);

-- Prevent double-booking exact start times.
CREATE UNIQUE INDEX ux_provider_accepted_slot
    ON bookings(provider_id, scheduled_for)
    WHERE status IN ('ACCEPTED', 'COMPLETED');
