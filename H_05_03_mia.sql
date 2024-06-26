-- 1. Створення копії таблиці hr.employees у своїй схемі
CREATE TABLE irina.employees AS 
SELECT * FROM hr.employees;

-- 2. Додавання власних даних в таблицю
INSERT INTO irina.employees (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
VALUES (207, 'Iryna', 'Malook', 'MALOOKIRINA25', '515.129.0162', '01.04.2024','IT_PROG', 17500, NULL, 103, 60);
COMMIT;

-- 3. Відправка сформованого звіту на пошту
DECLARE
    v_recipient VARCHAR2(50);
    v_subject VARCHAR2(50) := 'Звіт по департаментам';
    v_mes VARCHAR2(5000) := 'Вітаю! </br> Ось звіт з нашої компанії: </br></br>';
BEGIN
    SELECT em.email || '@gmail.com'
    INTO v_recipient
    FROM irina.employees em
    WHERE em.employee_id = 207;
    
    SELECT
        v_mes||'<!DOCTYPE html>
        <html>
            <head>
                <title></title>
                <style>
                    table, th, td {border: 1px solid;}
                    .center{text-align: center;}
                </style>
            </head>
            <body>
                <table border=1 cellspacing=0 cellpadding=2 rules=GROUPS frame=HSIDES>
                    <thead>
                        <tr align=left>
                            <th>Ід департаменту</th>
                            <th>Кількість співробітників</th>
                        </tr>
                    </thead>
                    <tbody>
                    '|| list_html || '
                    </tbody>
                </table>
             </body>
         </html>' AS html_table
    INTO v_mes
    FROM (
    SELECT LISTAGG('<tr align=left>
                    <td>' || department_id || '</td>' || '
                    <td class=''center''> ' || cnt_empl||'</td>
                </tr>', '<tr>')
        WITHIN GROUP(ORDER BY cnt_empl) AS list_html
    FROM ( SELECT nvl(em.department_id, 0) as department_id, count(em.employee_id) as cnt_empl
           FROM irina.employees em
           GROUP BY nvl(em.department_id, 0) ));
        
    v_mes := v_mes || '</br></br> З повагою, Ірина';
    
    sys.sendmail(p_recipient => v_recipient,
        p_subject => v_subject,
        p_message => v_mes || ' ');
END;
/
