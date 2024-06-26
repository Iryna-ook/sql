--Створити PL-SQL блок, який в залежності від року показує, це високосний рік чи ні.

DECLARE
    v_year NUMBER := 2024;
    v_check_year NUMBER;
BEGIN

    v_check_year := mod(v_year, 4);
    IF v_check_year = 0 THEN
        dbms_output.put_line('Високосний рік');
    ELSE
        dbms_output.put_line('Не високосний рік');
    END IF;
    
END;
/
