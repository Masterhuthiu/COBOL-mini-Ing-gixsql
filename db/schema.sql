CREATE TABLE IF NOT EXISTS policy (
    policy_id    SERIAL PRIMARY KEY,
    customer     TEXT          NOT NULL,
    product      TEXT          NOT NULL,
    base_premium NUMERIC(11,2) NOT NULL,
    status       TEXT          DEFAULT 'ACTIVE'
);

CREATE TABLE IF NOT EXISTS invoice (
    invoice_id  SERIAL PRIMARY KEY,
    policy_id   INTEGER       NOT NULL REFERENCES policy(policy_id),
    amount      NUMERIC(11,2) NOT NULL,
    status      TEXT          DEFAULT 'UNPAID',
    due_date    TEXT          NOT NULL
);

CREATE TABLE IF NOT EXISTS claim (
    claim_id    SERIAL PRIMARY KEY,
    policy_id   INTEGER       NOT NULL REFERENCES policy(policy_id),
    amount      NUMERIC(11,2) NOT NULL,
    status      TEXT          DEFAULT 'PENDING',
    created_at  TIMESTAMP     DEFAULT NOW()
);

INSERT INTO policy (customer, product, base_premium, status) VALUES
    ('Nguyen Van A', 'LIFE-BASIC',   500000.00, 'ACTIVE'),
    ('Tran Thi B',   'LIFE-PLUS',    800000.00, 'ACTIVE'),
    ('Le Van C',     'HEALTH-BASIC', 300000.00, 'INACTIVE')
ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS emp (
    id   SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    age  INTEGER NOT NULL
);