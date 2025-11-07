--q1
WITH alexis_salary AS (
    SELECT
        salary
    FROM
        employees
    WHERE
        first_name = 'Alexis'
        AND last_name = 'Bull'
) SELECT
    first_name
    || ' '
    || last_name AS full_name,
    salary
  FROM
    employees e
  WHERE
    e.salary > (
        SELECT
            *
        FROM
            alexis_salary
    )
ORDER BY
    salary DESC;

--Q2
SELECT
    *
FROM
    employees
WHERE
    department_id = (
        SELECT
            department_id
        FROM
            departments
        WHERE
            department_name = 'IT'
    );

--Q3
SELECT
    first_name
    || ' '
    || last_name AS fullname
FROM
    employees
WHERE
    department_id IN (
        SELECT
            department_id
        FROM
            departments
        WHERE
            location_id IN (
                SELECT
                    location_id
                FROM
                    locations
                WHERE
                    country_id IN (
                        SELECT
                            country_id
                        FROM
                            countries
                        WHERE
                            country_name = 'United States of America'
                    )
            )
    )
    AND manager_id IS NOT NULL;

--Q4
SELECT
    *
FROM
    employees
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees
    );

--Q5
SELECT
    first_name,
    last_name,
    salary
FROM
    employees
WHERE
    salary > ALL (
        SELECT
            salary
        FROM
            employees
        WHERE
            job_id = 'SA_REP'
    );

--Q6
SELECT
    *
FROM
    employees e
WHERE
    employee_id IN (
        SELECT
            manager_id
        FROM
            departments d
        WHERE
            e.employee_id = d.manager_id
    );

--Q7
SELECT
    employee_id,
    first_name,
    last_name,
    salary,
    department_id
FROM
    employees e
WHERE
    salary > (
        SELECT
            AVG(salary)
        FROM
            employees d
        WHERE
            e.department_id = d.department_id
    );

--Q8
SELECT
    department_name,
    department_id
FROM
    departments d
WHERE
    NOT EXISTS (
        SELECT
            employee_id
        FROM
            employees e
        WHERE
            e.department_id = d.department_id
    );

--Q9
CREATE VIEW jonathontaylor_jobhistory AS
    SELECT
        start_date,
        end_date,
        job_id,
        department_id
    FROM
        job_history;

SELECT
    e.employee_id,
    j.job_title,
    h.start_date,
    h.end_date
FROM
    employees e
    INNER JOIN departments d ON d.department_id = e.department_id
    INNER JOIN jobs j ON j.job_id = e.job_id
    INNER JOIN job_history h ON h.employee_id = e.employee_id
WHERE
    e.first_name = 'Jonathon'
    AND e.last_name = 'Taylor';

--Q10
SELECT
    e.employee_id
FROM
    employees e
MINUS
SELECT
    j.employee_id
FROM
    job_history j;

--Q11
SELECT
    first_name
    || ' '
    || last_name AS entity_name,
    'Employee' AS entity_type
FROM
    employees
UNION ALL
SELECT
    department_name AS entity_name,
    'Department' AS entity_type
FROM
    departments;

--Q12
SELECT
    first_name
    || ' '
    || last_name AS full_name
FROM
    employees
WHERE
    employee_id IN (
        SELECT
            employee_id
        FROM
            employees e
        INTERSECT
        SELECT
            manager_id
        FROM
            departments d
        INTERSECT
        SELECT
            manager_id
        FROM
            employees
    );

--Q13
SELECT
    d.department_name,
    round(AVG(e.salary),2),
    CASE
            WHEN AVG(e.salary) > 10000              THEN 'High'
            WHEN AVG(e.salary) BETWEEN 5000 AND 10000 THEN 'Medium'
            WHEN AVG(e.salary) < 5000               THEN 'Low'
        END
    salary_category
FROM
    employees e
    JOIN departments d ON e.department_id = d.department_id
GROUP BY
    d.department_name;

--Q14a
UPDATE employees
SET
    commission_pct = 0.5
WHERE
    lower(first_name) = 'steven'
    AND lower(last_name) = 'king';

--Q14b
UPDATE employees
SET manager_id = (
    SELECT manager_id
    FROM employees
    WHERE first_name = 'Alexander' AND last_name = 'Hunold'
)
WHERE manager_id = (
    SELECT employee_id
    FROM employees
    WHERE first_name = 'Alexander' AND last_name = 'Hunold'
);

UPDATE departments 
SET manager_id = (
    SELECT manager_id
    FROM employees
    WHERE first_name = 'Alexander' AND last_name = 'Hunold'
)
WHERE manager_id = (
    SELECT employee_id
    FROM employees
    WHERE first_name = 'Alexander' AND last_name = 'Hunold'
);

--Q14c
DELETE FROM employees
WHERE employee_id = (SELECT employee_id FROM employees e WHERE e.first_name = 'Alexander'
AND e.last_name = 'Hunold');

--q15
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,
    d.department_name,
    e.hire_date,
    ROUND(MONTHS_BETWEEN(SYSDATE, e.hire_date) / 12, 1) AS years_of_service,
    m.email AS manager_email
FROM employees e
JOIN departments d 
    ON e.department_id = d.department_id
JOIN employees m 
    ON d.manager_id = m.employee_id
WHERE MONTHS_BETWEEN(SYSDATE, e.hire_date) / 12 > 10
ORDER BY d.department_name, e.hire_date;

--q16

SELECT 
    d.department_name,
    m.first_name || ' ' || m.last_name AS manager_name,
    COUNT(e.employee_id) AS num_employees,
    ROUND(AVG(e.salary), 2) AS avg_salary,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary,
    
    MAX(e.hire_date) AS latest_hire_date
FROM departments d
LEFT JOIN employees e 
    ON d.department_id = e.department_id
LEFT JOIN employees m 
    ON d.manager_id = m.employee_id
GROUP BY 
    d.department_name, 
    m.first_name, 
    m.last_name
ORDER BY 
    d.department_name;