
/*
 * spring-cloud-task v3 schema taken from
 * https://github.com/spring-cloud/spring-cloud-task/blob/main/spring-cloud-task-core/src/main/resources/org/springframework/cloud/task/schema-mariadb.sql
 * and prefixed w/ 'BOOT3_'
 */

CREATE TABLE BOOT3_TASK_EXECUTION (
    TASK_EXECUTION_ID BIGINT NOT NULL PRIMARY KEY,
    START_TIME DATETIME(6) DEFAULT NULL,
    END_TIME DATETIME(6) DEFAULT NULL,
    TASK_NAME  VARCHAR(100),
    EXIT_CODE INTEGER,
    EXIT_MESSAGE VARCHAR(2500),
    ERROR_MESSAGE VARCHAR(2500),
    LAST_UPDATED TIMESTAMP,
    EXTERNAL_EXECUTION_ID VARCHAR(255),
    PARENT_EXECUTION_ID BIGINT
);

CREATE TABLE BOOT3_TASK_EXECUTION_PARAMS (
    TASK_EXECUTION_ID BIGINT NOT NULL,
    TASK_PARAM VARCHAR(2500),
    constraint BOOT3_TASK_EXEC_PARAMS_FK foreign key (TASK_EXECUTION_ID)
        references BOOT3_TASK_EXECUTION(TASK_EXECUTION_ID)
);

CREATE TABLE BOOT3_TASK_TASK_BATCH (
    TASK_EXECUTION_ID BIGINT NOT NULL,
    JOB_EXECUTION_ID BIGINT NOT NULL,
    constraint BOOT3_TASK_EXEC_BATCH_FK foreign key (TASK_EXECUTION_ID)
        references BOOT3_TASK_EXECUTION(TASK_EXECUTION_ID)
);

CREATE TABLE BOOT3_TASK_LOCK (
    LOCK_KEY CHAR(36) NOT NULL,
    REGION VARCHAR(100) NOT NULL,
    CLIENT_ID CHAR(36),
    CREATED_DATE DATETIME(6) NOT NULL,
    constraint BOOT3_LOCK_PK primary key (LOCK_KEY, REGION)
);

CREATE SEQUENCE BOOT3_TASK_SEQ START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775806 INCREMENT BY 1 NOCACHE NOCYCLE;

/*
 * spring-batch v5 schema taken from
 * https://github.com/spring-projects/spring-batch/blob/main/spring-batch-core/src/main/resources/org/springframework/batch/core/schema-mariadb.sql
 * and prefixed w/ 'BOOT3_'
 */
CREATE TABLE BOOT3_BATCH_JOB_INSTANCE (
    JOB_INSTANCE_ID BIGINT  NOT NULL PRIMARY KEY,
    VERSION BIGINT,
    JOB_NAME VARCHAR(100) NOT NULL,
    JOB_KEY VARCHAR(32) NOT NULL,
    constraint BOOT3_JOB_INST_UN unique (JOB_NAME, JOB_KEY)
);

CREATE TABLE BOOT3_BATCH_JOB_EXECUTION (
    JOB_EXECUTION_ID BIGINT  NOT NULL PRIMARY KEY,
    VERSION BIGINT ,
    JOB_INSTANCE_ID BIGINT NOT NULL,
    CREATE_TIME DATETIME(6) NOT NULL,
    START_TIME DATETIME(6) DEFAULT NULL,
    END_TIME DATETIME(6) DEFAULT NULL,
    STATUS VARCHAR(10),
    EXIT_CODE VARCHAR(2500),
    EXIT_MESSAGE VARCHAR(2500),
    LAST_UPDATED DATETIME(6),
    constraint BOOT3_JOB_INST_EXEC_FK foreign key (JOB_INSTANCE_ID)
        references BOOT3_BATCH_JOB_INSTANCE(JOB_INSTANCE_ID)
);

CREATE TABLE BOOT3_BATCH_JOB_EXECUTION_PARAMS (
    JOB_EXECUTION_ID BIGINT NOT NULL,
    PARAMETER_NAME VARCHAR(100) NOT NULL,
    PARAMETER_TYPE VARCHAR(100) NOT NULL,
    PARAMETER_VALUE VARCHAR(2500),
    IDENTIFYING CHAR(1) NOT NULL,
    constraint BOOT3_JOB_EXEC_PARAMS_FK foreign key (JOB_EXECUTION_ID)
        references BOOT3_BATCH_JOB_EXECUTION(JOB_EXECUTION_ID)
);

CREATE TABLE BOOT3_BATCH_STEP_EXECUTION (
    STEP_EXECUTION_ID BIGINT  NOT NULL PRIMARY KEY,
    VERSION BIGINT NOT NULL,
    STEP_NAME VARCHAR(100) NOT NULL,
    JOB_EXECUTION_ID BIGINT NOT NULL,
    CREATE_TIME DATETIME(6) NOT NULL,
    START_TIME DATETIME(6) DEFAULT NULL,
    END_TIME DATETIME(6) DEFAULT NULL,
    STATUS VARCHAR(10),
    COMMIT_COUNT BIGINT,
    READ_COUNT BIGINT,
    FILTER_COUNT BIGINT,
    WRITE_COUNT BIGINT,
    READ_SKIP_COUNT BIGINT,
    WRITE_SKIP_COUNT BIGINT,
    PROCESS_SKIP_COUNT BIGINT,
    ROLLBACK_COUNT BIGINT,
    EXIT_CODE VARCHAR(2500),
    EXIT_MESSAGE VARCHAR(2500),
    LAST_UPDATED DATETIME(6),
    constraint BOOT3_JOB_EXEC_STEP_FK foreign key (JOB_EXECUTION_ID)
        references BOOT3_BATCH_JOB_EXECUTION(JOB_EXECUTION_ID)
);

CREATE TABLE BOOT3_BATCH_STEP_EXECUTION_CONTEXT (
    STEP_EXECUTION_ID BIGINT NOT NULL PRIMARY KEY,
    SHORT_CONTEXT VARCHAR(2500) NOT NULL,
    SERIALIZED_CONTEXT TEXT,
    constraint BOOT3_STEP_EXEC_CTX_FK foreign key (STEP_EXECUTION_ID)
        references BOOT3_BATCH_STEP_EXECUTION(STEP_EXECUTION_ID)
);

CREATE TABLE BOOT3_BATCH_JOB_EXECUTION_CONTEXT (
    JOB_EXECUTION_ID BIGINT NOT NULL PRIMARY KEY,
    SHORT_CONTEXT VARCHAR(2500) NOT NULL,
    SERIALIZED_CONTEXT TEXT,
    constraint BOOT3_JOB_EXEC_CTX_FK foreign key (JOB_EXECUTION_ID)
        references BOOT3_BATCH_JOB_EXECUTION(JOB_EXECUTION_ID)
);

CREATE SEQUENCE BOOT3_BATCH_STEP_EXECUTION_SEQ START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775806 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE BOOT3_BATCH_JOB_EXECUTION_SEQ START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775806 INCREMENT BY 1 NOCACHE NOCYCLE;
CREATE SEQUENCE BOOT3_BATCH_JOB_SEQ START WITH 1 MINVALUE 1 MAXVALUE 9223372036854775806 INCREMENT BY 1 NOCACHE NOCYCLE;
