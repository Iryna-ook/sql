--Створення view rep_project_dep_v

CREATE view rep_project_dep_v AS
SELECT ext_fl.project_id, ext_fl.project_name, ext_fl.department_id, d.department_name, count(em.employee_id) as count_employees, count(distinct(em.manager_id)) as count_manager, sum(em.salary) as sum_salary
FROM EXTERNAL ((project_id NUMBER,
                project_name VARCHAR2(200),
                department_id NUMBER)
    TYPE oracle_loader DEFAULT DIRECTORY FILES_FROM_SERVER --вказуємо назву директорії в БД
    ACCESS PARAMETERS (records delimited BY newline
                      nologfile
                      nobadfile
                      fields terminated BY ','
                      missing field VALUES are NULL)
    LOCATION('PROJECTS.csv')--вказує назву файлу
    REJECT LIMIT UNLIMITED /* немає обмежень для відкидання рядків*/) ext_fl
INNER JOIN hr.departments d
on ext_fl.department_id = d.department_id
INNER JOIN hr.employees em
on ext_fl.department_id = em.department_id
GROUP BY ext_fl.project_id, ext_fl.project_name, ext_fl.department_id, d.department_name
ORDER BY 1
;

--Формування CSV файла на диску

DECLARE
    file_handle UTL_FILE.FILE_TYPE;
    file_location VARCHAR2(200) := 'FILES_FROM_SERVER'; --назва створеної директорії
    file_name VARCHAR2(200):= 'total_proj_index_mia.CSV'; --Ім'я файлу, який буде записаний
    file_content VARCHAR2(5000); --Вміст файлу
BEGIN
    --Отримати вміст файлу з бази даних
    FOR cc IN (SELECT r.project_id || ',' || r.project_name ||','|| r.department_id ||','|| r.department_name ||','|| r.count_employees ||','|| r.count_manager ||','|| r.sum_salary AS file_content
               FROM rep_project_dep_v r) LOOP
    file_content := file_content || cc.file_content || CHR(10);
    END LOOP;

    --Відкрити файл для запису
    file_handle := utl_file.fopen(file_location, file_name, 'W');

    --Записати вміст файлу в файл на диск
    utl_file.put_raw(file_handle, UTL_RAW.CAST_TO_RAW(file_content));

    --Закрити файл
    utl_file.fclose(file_handle);

    EXCEPTION
        WHEN OTHERS THEN
        --Обробка помилок
        RAISE;
END;
/

