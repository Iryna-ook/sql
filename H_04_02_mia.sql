--Процедура del_jobs------------------------------------------------------------

    PROCEDURE del_jobs (p_job_id  IN VARCHAR2,
                        po_result OUT VARCHAR2) IS
        v_delete_no_data_found EXCEPTION;
    BEGIN
    
        check_work_time;

        BEGIN
        
            DELETE FROM irina.jobs 
            WHERE job_id = p_job_id;      
                          
            IF SQL%ROWCOUNT = 0 THEN
                raise v_delete_no_data_found;
            END IF;
            
            COMMIT; 
            po_result := 'Посада ' || p_job_id || ' успішно видалена';
            
            EXCEPTION
            WHEN v_delete_no_data_found THEN
                raise_application_error(-20004, 'Посада ' || p_job_id || ' не існує');  
                     
        END;   
   
    END del_jobs;

--------------------------------------------------------------------------------