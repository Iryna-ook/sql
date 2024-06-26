/* Створити PL-SQL блок, який по department_id = 80 виводить імʼя та прізвище, через крапку з комою 
виводить прибавку до зарплати і через крапку з комою опис процента(мінімальний, середній або максимальний). */

DECLARE
v_def_percent VARCHAR2(30);
v_percent VARCHAR2(5);
v_dep_id hr.employees.department_id%TYPE := 80;

BEGIN

    FOR cc IN (SELECT em.first_name || ' ' || em.last_name as emp_name, em.commission_pct*100 as percent_of_salary, em.manager_id
           FROM hr.employees em
           WHERE em.department_id = v_dep_id
           ORDER BY emp_name) LOOP
              
       IF cc.manager_id = 100 THEN 
          dbms_output.put_line('Співробітник - ' || cc.emp_name || ', процент до зарплати на зараз заборонений');
       CONTINUE;
       END IF;
       
       IF cc.percent_of_salary BETWEEN 10 AND 20 THEN v_def_percent := 'мінімальний';
       ELSIF cc.percent_of_salary BETWEEN 25 AND 30 THEN v_def_percent := 'середній';
       ELSIF cc.percent_of_salary BETWEEN 35 AND 40 THEN v_def_percent := 'максимальний';
       END IF;      
       
    v_percent := CONCAT(cc.percent_of_salary, '%');  
    
    dbms_output.put_line('Співробітник - ' || cc.emp_name || '; процент до зарплати - ' || v_percent || '; опис процента - '|| v_def_percent); 
              
    END LOOP; 
   
END;
/
