-- Створення таблиці interbank_index_ua_history
CREATE TABLE interbank_index_ua_history
            ( dt      DATE,
              id_api  VARCHAR2(100),
              value   NUMBER,
              special VARCHAR2(100) );
              
--SET DEFINE OFF ; --один раз запустити

--Створення view interbank_index_ua_v
CREATE view interbank_index_ua_v AS
SELECT TO_DATE(tt.dt,'dd.mm.yyyy') as dt, tt.id_api, tt.value, tt.special 
FROM (SELECT SYS.GET_NBU(p_url => 'https://bank.gov.ua/NBU_uonia?id_api=UONIA_UnsecLoansDepo&json') AS json_value FROM dual)
CROSS JOIN json_table
        (
            json_value, '$[*]'
            COLUMNS
        (
            dt      VARCHAR2(100) PATH '$.dt',
            id_api  VARCHAR2(100) PATH '$.id_api',
            value   NUMBER        PATH '$.value',
            special VARCHAR2(100) PATH '$.special'
        )
        )tt;

--Створення процедури download_ibank_index_ua
CREATE OR REPLACE PROCEDURE download_ibank_index_ua IS
BEGIN
    INSERT INTO interbank_index_ua_history (dt, id_api, value, special)
    SELECT * FROM interbank_index_ua_v;
COMMIT;
END download_ibank_index_ua;
/

--Створення шедулера
BEGIN
    sys.dbms_scheduler.create_job(job_name        => 'update_interbank_index_ua_history',
                                  job_type        => 'PLSQL_BLOCK',
                                  job_action      => 'begin download_ibank_index_ua(); end;',
                                  start_date      => SYSDATE,
                                  repeat_interval => 'FREQ=DAILY; BYHOUR=9; BYMINUTE=0; BYSECOND=0',
                                  end_date        => TO_DATE(NULL),
                                  job_class       => 'DEFAULT_JOB_CLASS' ,
                                  enabled         => TRUE,
                                  auto_drop       => FALSE,
                                  comments        => 'Оновлення Українського індексу міжбанківських ставок овернайт');
END;
/

--Перевірка
select * from interbank_index_ua_history;
