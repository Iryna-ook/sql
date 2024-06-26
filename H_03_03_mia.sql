
--Специфікація пакету util------------------------------------------------------

create or replace PACKAGE util AS

    gc_min_salary CONSTANT NUMBER := 2000;
    
    FUNCTION get_job_title (p_employee_id IN NUMBER) RETURN VARCHAR2;
    
    FUNCTION get_dep_name(p_employee_id IN NUMBER) RETURN VARCHAR2;

    FUNCTION add_years (p_date IN DATE DEFAULT SYSDATE,
                        p_year IN NUMBER) RETURN DATE;
    
    PROCEDURE del_jobs (p_job_id  IN VARCHAR2,
                        po_result OUT VARCHAR2);

    PROCEDURE add_new_jobs(p_job_id     IN VARCHAR2, 
                           p_job_title  IN VARCHAR2, 
                           p_min_salary IN NUMBER, 
                           p_max_salary IN NUMBER DEFAULT NULL,
                           po_err       OUT VARCHAR2);
END util;
--------------------------------------------------------------------------------

--Тіло пакету util--------------------------------------------------------------

create or replace PACKAGE body util AS

    c_percent_of_min_salary CONSTANT NUMBER := 1.5;
    
--Функція get_job_title---------------------------------------------------------  
    
    FUNCTION get_job_title (p_employee_id IN NUMBER) RETURN VARCHAR2 IS
        v_job_title jobs.job_title%TYPE;
    BEGIN
    
        SELECT j.job_title
        INTO v_job_title
        FROM irina.employees em
        INNER JOIN irina.jobs j
        ON em.job_id =j.job_id
        WHERE em.employee_id = p_employee_id;
    
        RETURN v_job_title;
    
    END get_job_title;
    
--Функція get_dep_name----------------------------------------------------------
    
    FUNCTION get_dep_name(p_employee_id IN NUMBER) RETURN VARCHAR2 IS
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
    
--Функція add_years-------------------------------------------------------------

    FUNCTION add_years (p_date IN DATE DEFAULT SYSDATE,
                        p_year IN NUMBER) RETURN DATE IS
        v_date DATE;
        v_year NUMBER := p_year * 12;
    
    BEGIN
    
        SELECT add_months(p_date, v_year)
        INTO v_date
        FROM dual;
    
        RETURN v_date;
    
    END add_years;
    
--Процедура del_jobs------------------------------------------------------------

    PROCEDURE del_jobs (p_job_id  IN VARCHAR2,
                                          po_result OUT VARCHAR2) IS
        v_cnt_job_id NUMBER;      
    BEGIN
    
        SELECT count(j.job_id)
        INTO v_cnt_job_id
        FROM irina.jobs j
        WHERE j.job_id = p_job_id;
    
            IF v_cnt_job_id = 0 THEN
                po_result := 'Посада ' || p_job_id || ' не існує';
            ELSE 
                DELETE FROM irina.jobs 
                WHERE job_id = p_job_id;
                COMMIT;
                po_result := 'Посада ' || p_job_id || ' успішно видалена';
            END IF;
    
    END del_jobs;
    
--Процедура add_new_jobs--------------------------------------------------------

    PROCEDURE add_new_jobs(p_job_id     IN VARCHAR2, 
                           p_job_title  IN VARCHAR2, 
                           p_min_salary IN NUMBER, 
                           p_max_salary IN NUMBER DEFAULT NULL,
                           po_err       OUT VARCHAR2) IS
        v_max_salary irina.jobs.max_salary%TYPE;
        v_is_exist_job NUMBER;
    BEGIN
    
        IF p_max_salary IS NULL THEN
           v_max_salary := p_min_salary * c_percent_of_min_salary;
        ELSE 
           v_max_salary := p_max_salary;
        END IF;
        
        SELECT COUNT(j.job_id)
        INTO v_is_exist_job
        FROM irina.jobs j
        WHERE j.job_id = p_job_id;
    
        IF (p_min_salary < gc_min_salary OR p_max_salary < gc_min_salary) THEN
            po_err := 'Передана ЗП менша 2000';
        ELSIF v_is_exist_job >= 1 THEN
               po_err := 'Посада ' || p_job_id || ' вже існуує';
        ELSE 
           INSERT INTO irina.jobs (job_id, job_title, min_salary, max_salary)
           VALUES (p_job_id, p_job_title, p_min_salary, v_max_salary);
           COMMIT;
           po_err := 'Посада ' || p_job_id || ' успішно додана';
    
        END IF;
    
    END add_new_jobs;
    
--------------------------------------------------------------------------------
END util;


-- Видалення функцій get_job_title, get_dep_name та процедури del_jobs з кореня своєї схеми

DROP FUNCTION get_job_title;
DROP FUNCTION get_dep_name;
DROP PROCEDURE del_jobs;

--Виклик функцій get_job_title, get_dep_name та процедури del_jobs з пакету util

DECLARE
    v_employee_id NUMBER := 101;
BEGIN
    dbms_output.put_line(util.get_job_title(p_employee_id => v_employee_id)); 
END;
/
--------------------------------------------------------------------------------
DECLARE
    v_employee_id NUMBER := 150;
BEGIN
    dbms_output.put_line(util.get_dep_name(p_employee_id => v_employee_id)) ; 
END;
/
-------------------------------------------------------------------------------
DECLARE
    v_job_id VARCHAR2(100) := 'IT_QA2';
    v_result VARCHAR2(100);
BEGIN
    util.del_jobs (p_job_id  => v_job_id,
                   po_result => v_result);
    dbms_output.put_line(v_result);      
END;
/