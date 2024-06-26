--Функція get_sum_price_sales---------------------------------------------------

    FUNCTION get_sum_price_sales (p_table IN VARCHAR2) RETURN NUMBER IS
        v_sum NUMBER;
        v_dynamic_sql VARCHAR2(500);
    BEGIN
    
        IF p_table NOT IN ('products','products_old') THEN
            to_log(p_appl_proc => 'util.get_sum_price_sales', p_message => 'Неприпустиме значення! Очікується products або products_old.');
            raise_application_error(-20001, 'Неприпустиме значення! Очікується products або products_old.'); 
        ELSE
            v_dynamic_sql := 'SELECT SUM(p.price_sales) FROM hr. '||p_table||' p';
        EXECUTE IMMEDIATE v_dynamic_sql INTO v_sum;
        END IF;
        
        RETURN v_sum;
        
    END get_sum_price_sales;

--------------------------------------------------------------------------------