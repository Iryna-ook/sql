-- 1. Створити PL-SQL блок, який по employee_id визначає посаду співробітника.

DECLARE
    v_employee_id hr.employees.employee_id%TYPE := 203;
    v_job_id hr.employees.job_id%TYPE;
    v_job_title hr.jobs.job_title%TYPE;
    
BEGIN

    SELECT em.job_id
    INTO v_job_id
    FROM hr.employees em
    WHERE em.employee_id = v_employee_id;

    SELECT j.job_title
    INTO v_job_title
    FROM hr.jobs j
    WHERE j.job_id = v_job_id;

    dbms_output.put_line('Посада співробітника: ' || v_job_title);

END;
/
