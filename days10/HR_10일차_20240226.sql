-- HR 
SELECT *
FROM tabs;

-- ANTI JOIN : NOT IN 연산자 사용한 경우
select employee_id, first_name, last_name, manager_id, department_id
FROM employees
WHERE department_id NOT IN (                            
                                select department_id
                                from departments
                                where location_id = 1700
                            )
-- SEMI JOIN : EXISTS 연산자 사용한 경우
SELECT *
FROM departments d
WHERE EXISTS (
                select *
                from employees e
                where d.department_id = e.department_id
                        and e.salary > 2500
              )



















