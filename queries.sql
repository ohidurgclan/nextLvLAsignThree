-- Declear Enum Types
-------------------------
CREATE TYPE user_role AS ENUM ('Admin', 'Customer');
CREATE TYPE vehicle_type AS ENUM ('car', 'bike', 'truck');
CREATE TYPE vehicle_status AS ENUM ('available', 'rented', 'maintenance');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'completed', 'cancelled');

--------------------
-- Query 1: JOIN
--------------------
SELECT
    b.booking_id,
    u.name AS customer_name,
    v.name AS vehicle_name,
    b.start_date,
    b.end_date,
    b.booking_status AS status
FROM "Bookings" b
JOIN "Users" u
    ON b.user_id = u.user_id
JOIN "Vehicles" v
    ON b.vehicle_id = v.vehicle_id;

--------------------
-- Query 2: EXISTS
--------------------
SELECT
*
FROM "Vehicles" v
WHERE NOT EXISTS (
    SELECT 1
    FROM "Bookings" b
    WHERE b.vehicle_id = v.vehicle_id
)
ORDER BY v.vehicle_id;

--------------------
-- Query 3: WHERE
--------------------
SELECT * FROM "Vehicles" v WHERE v.status = 'available' AND v.type = 'car';

------------------------------------
-- Query 4: GROUP BY and HAVING
------------------------------------
SELECT
    v.name AS vehicle_name,
    COUNT(b.booking_id) AS total_bookings
FROM "Vehicles" v
JOIN "Bookings" b
    ON b.vehicle_id = v.vehicle_id
GROUP BY v.name
HAVING COUNT(b.booking_id) > 2;

--------------------------------
--------------------------------
-- Extras Table Creation
--------------------------------
CREATE TABLE "Users" (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    role user_role NOT NULL
);

CREATE TABLE "Vehicles" (
    vehicle_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    type vehicle_type NOT NULL,
    model VARCHAR(20) NOT NULL,
    registration_number VARCHAR(30) UNIQUE NOT NULL,
    rental_price NUMERIC(6, 2) NOT NULL,
    status vehicle_status NOT NULL
);

CREATE TABLE "Bookings" (
    booking_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES "Users"(user_id),
    vehicle_id INTEGER NOT NULL REFERENCES "Vehicles"(vehicle_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    booking_status booking_status NOT NULL,
    total_cost NUMERIC(8, 2) NOT NULL
);

-- Insert Data to Each Tables 

Insert Users Data
INSERT INTO "Users" (name, email, password, phone, role)
VALUES
    ('Alice', 'alice@example.com', '123456', '1234567890', 'Customer'),
    ('Bob', 'bob@example.com', '123456', '0987654321', 'Admin'),
    ('Charlie', 'charlie@example.com', '123456', '1122334455', 'Customer');

INSERT INTO "Vehicles"
(name, type, model, registration_number, rental_price, status)
VALUES
    ('Toyota Corolla', 'car', '2022', 'ABC-123', 50, 'available'),
    ('Honda Civic',    'car', '2021', 'DEF-456', 60, 'rented'),
    ('Yamaha R15',     'bike', '2023', 'GHI-789', 30, 'available'),
    ('Ford F-150',     'truck','2020', 'JKL-012', 100, 'maintenance');

INSERT INTO "Bookings"
(user_id, vehicle_id, start_date, end_date, booking_status, total_cost)
VALUES
    (1, 2, '2023-10-01', '2023-10-05', 'completed', 240),
    (1, 2, '2023-11-01', '2023-11-03', 'completed', 120),
    (3, 2, '2023-12-01', '2023-12-02', 'confirmed', 60),
    (1, 1, '2023-12-10', '2023-12-12', 'pending', 100);