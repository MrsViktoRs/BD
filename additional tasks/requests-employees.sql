CREATE TABLE IF NOT EXISTS Departments (
department_id SERIAL PRIMARY KEY
);
CREATE TABLE IF NOT EXISTS Employees (
employee_id SERIAL PRIMARY KEY,
name VARCHAR (20) NOT NULL,
department INTEGER REFERENCES Departments(department_id),
chief INTEGER REFERENCES Employees(employee_id)
);