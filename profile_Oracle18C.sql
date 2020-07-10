
ALTER SYSTEM SET nls_length_semantics='CHAR' SCOPE=BOTH;
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;
ALTER SYSTEM SET processes=250 scope=spfile;
ALTER SYSTEM SET sessions=250 scope=spfile;
ALTER SYSTEM SET open_cursors=25000 SCOPE=BOTH;
ALTER SYSTEM SET recyclebin = OFF DEFERRED;
GRANT read, write ON DIRECTORY DATA_PUMP_DIR TO public; 

/*
GRANT select on sys.v_$session to public; 
GRANT select on sys.v_$sesstat to public; 
GRANT select on sys.v_$sql to public; 
GRANT select on sys.v_$sql_plan to public; 
GRANT select on sys.v_$sysmetric_history to public;

*/

CREATE BIGFILE TABLESPACE sonata_tbs_03 DATAFILE 'D:\Oracle18C\oradata\ORACLE18C\sonata_tbs_03.dat' SIZE 200M AUTOEXTEND ON; 
CREATE USER training IDENTIFIED by password DEFAULT TABLESPACE sonata_tbs_03 TEMPORARY TABLESPACE TEMP;
GRANT CONNECT, RESOURCE TO training ; 
ALTER USER training QUOTA UNLIMITED ON sonata_tbs_03; 
GRANT CREATE VIEW TO training ;

exec dbms_xdb_config.sethttpsport (1521); 
select dbms_xdb_config.gethttpsport() from dual; 