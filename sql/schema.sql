CREATE TABLE policies (
    policy_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    premium NUMERIC,
    start_date DATE
);

CREATE TABLE riders (
    rider_id SERIAL PRIMARY KEY,
    policy_id INT REFERENCES policies(policy_id),
    rider_type VARCHAR(50),
    rider_premium NUMERIC
);

CREATE TABLE policy (
    policy_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    policy_type VARCHAR(20),
    premium NUMERIC
);