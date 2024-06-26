--Створити функцію яка буде повертати назву департаменту по співробітнику

create or replace FUNCTION get_dep_name(p_employee_id IN NUMBER) RETURN VARCHAR2 IS
    v_department_name irina.departments.department_name%TYPE;  
BEGIN

    SELECT d.department_name
    INTO v_department_name
    FROM irina.employees em
    INNER JOIN irina.departments d
    ON em.department_id = d.department_id
    WHERE em.employee_id = p_employee_id; 
    
    RETURN v_department_name;
    
END get_dep_name;
/

SELECT em.employee_id, 
       em.first_name, 
       em.last_name, 
       em.email, 
       em.phone_number, 
       em.hire_date, 
       get_job_title(em.employee_id) as job_title, 
       em.salary, 
       em.commission_pct, 
       em.manager_id, 
       nvl(get_dep_name(em.employee_id), 'Not found') as department_name
FROM hr.employees em;
