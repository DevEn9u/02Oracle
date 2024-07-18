-- system�������� �� ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER modernize_t IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE, unlimited tablespace TO modernize_t;

------------------------------------------------------------
-- modernize_t �������� ���̺� ����
CREATE TABLE membership (
    id varchar2(30) primary key,
    pass varchar2(30) not null,
    name varchar2(30) not null,
    email varchar2(30) not null,
    mobile varchar2(30) not null,
    regidate date default sysdate
);
desc membership;

INSERT INTO membership (id, pass, name, email, mobile)
VALUES ('tjoeun', '1234', '������IT', 'tj@tjoeun.com', '010-1234-5678');
commit;
SELECT * FROM membership;

-- �α��� ó���� ���� ������
SELECT * FROM membership WHERE id = 'tjoeun' AND pass = '1234';
SELECT * FROM membership WHERE id = 'tjoeun' AND pass = '9999';

