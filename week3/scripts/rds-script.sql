-- CREATE DATABASE week3;

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    age INT DEFAULT 0
);

INSERT INTO users (id, name, age)
VALUES
 (1, 'John', 33),
 (2, 'Bob', 31),
 (3, 'Liz', 24),
 (4, 'Karl', 52)
;

SELECT * FROM users;
