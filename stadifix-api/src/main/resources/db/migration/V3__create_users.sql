
CREATE TABLE users (
       id UUID PRIMARY KEY DEFAULT gen_random_uuid(),

       full_name VARCHAR(120) NOT NULL,

       email VARCHAR(254) NOT NULL,

       password_hash VARCHAR(255) NOT NULL,

       role VARCHAR(20) NOT NULL,

       created_at TIMESTAMPTZ NOT NULL
                  DEFAULT CURRENT_TIMESTAMP,#DataSourceSettings#
           #LocalDataSource: stadifix_db@localhost
#BEGIN#
<data-source source="LOCAL" name="stadifix_db@localhost" uuid="ce6a3101-bebb-426d-88cc-38e677bc79f3"><database-info product="" version="" jdbc-version="" driver-name="" driver-version="" dbms="POSTGRES"/><driver-ref>postgresql</driver-ref><synchronize>true</synchronize><jdbc-driver>org.postgresql.Driver</jdbc-driver><jdbc-url>jdbc:postgresql://localhost:5433/stadifix_db</jdbc-url><secret-storage>master_key</secret-storage><user-name>postgres</user-name><schema-mapping/><working-dir>$ProjectFileDir$</working-dir></data-source>
#END#



                  CONSTRAINT chk_users_role
                  CHECK (role IN ('CUSTOMER', 'PROVIDER'))
);

CREATE UNIQUE INDEX ux_users_email
    ON users (LOWER(email));
