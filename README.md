# Vehicle Rental Basic Database Design With ER Diagram.
**ER Diagram:**  https://drawsql.app/teams/amarkitchen/diagrams/nxtlvlassignment3

**Repository URL:**  https://github.com/ohidurgclan/nextLvLAsignThree.git

---

## Project Description
This project is a Vehicle Rental System designed to manage users, vehicles, and bookings efficiently using a relational database. The system consists of three main tables: Users, Vehicles, and Bookings, which are interconnected through primary and foreign keys to maintain data integrity. Users can register and make bookings for available vehicles, while each booking records details such as rental dates, booking status, and total cost. The Vehicles table stores essential information including vehicle type, model, registration number, daily rental price, and availability status. Through structured SQL queries, the system supports key operations such as identifying available vehicles, tracking booking history, finding vehicles that have never been booked, and analyzing booking frequency per vehicle. By using SQL features like WHERE, EXISTS, GROUP BY, and HAVING, the project demonstrates effective data retrieval and aggregations.

## Technology Stack
- **Language:**  Sql Query Language
- **Database:**  PostgreSQL
- **Other Tools/Tech:** Beekeeper Studio, DrawSql, 

---

## Getting Started
- At First Create a Database on Beekeeper Studio then Defines The ENUM Types Like.
```sql
CREATE TYPE user_role AS ENUM ('Admin', 'Customer');
CREATE TYPE vehicle_type AS ENUM ('car', 'bike', 'truck');
CREATE TYPE vehicle_status AS ENUM ('available', 'rented', 'maintenance');
CREATE TYPE booking_status AS ENUM ('pending', 'confirmed', 'completed', 'cancelled');
```
- Then Create The Tables By Using These Queries and Must Use ENUM Types.
```sql
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
```
- Then Insert The Dummy Data For For Practice Queries. Example Queries Given Below.

### Query 1: JOIN
```sql
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
```
### Query 2: EXISTS
```sql
SELECT
*
FROM "Vehicles" v
WHERE NOT EXISTS (
    SELECT 1
    FROM "Bookings" b
    WHERE b.vehicle_id = v.vehicle_id
)
ORDER BY v.vehicle_id;
```
### Query 3: WHERE
```sql
SELECT * FROM "Vehicles" v WHERE v.status = 'available' AND v.type = 'car';
```
### Query 4: GROUP BY and HAVING
```sql
SELECT
    v.name AS vehicle_name,
    COUNT(b.booking_id) AS total_bookings
FROM "Vehicles" v
JOIN "Bookings" b
    ON b.vehicle_id = v.vehicle_id
GROUP BY v.name
HAVING COUNT(b.booking_id) > 2;
```
## Conclusion
In conclusion, the Vehicle Rental System effectively demonstrates how a relational database can be used to organize and manage rental operations. By integrating users, vehicles, and bookings, the system ensures accurate data handling and meaningful relationships between entities. The use of SQL queries enables efficient data retrieval, filtering, and analysis, such as tracking availability and booking trends. This project strengthens understanding of database design principles and practical SQL operations used in real-world applications.