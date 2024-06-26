--Створити процедуру для видалення конкретної посади з таблиці JOBS, яка у власній схемі.

create or replace PROCEDURE del_jobs (p_job_id  IN VARCHAR2,
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
/
