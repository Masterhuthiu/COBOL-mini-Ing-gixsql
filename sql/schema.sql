CREATE TABLE policies (
    id SERIAL PRIMARY KEY,
    policy_number VARCHAR(50),
    policy_type VARCHAR(20),
    premium NUMERIC
);

CREATE TABLE riders (
    id SERIAL PRIMARY KEY,
    policy_id INTEGER,
    rider_name VARCHAR(50),
    rider_premium NUMERIC
);