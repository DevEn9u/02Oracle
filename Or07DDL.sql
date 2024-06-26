/*******
���ϸ� : 07OrDDL.sql
���� : ���̺�, ��� ���� ��ü�� ���� �� �����ϴ� �������� ���Ѵ�.
*******/

-- system �������� ������ �� �Ʒ� ����� �����Ѵ�.
-- ���ο� ����� ������ ������ �� ���ӱ��� �� ���̺� ���������� �ο��Ѵ�.
alter session set "_ORACLE_SCRIPT" = true;
create user study identified by 1234;
grant connect, resource to study;

-------------------------------------------------------------
-- study ������ Developer�� ����� �� �����Ѵ�.
-- DDL�� �ǽ��� study �������� �����մϴ�.

-- ������ ��� ������ �������� �����ϴ� ���̺�
SELECT * FROM dual;
/* ���� ������ ������ ������ ���̺��� ����� ������ �ý��� ���̺��
�̿� ���� ������ �������� ������ ���̺��� '�����ͻ���'�̶�� ǥ���Ѵ�. */
SELECT * FROM TAB;

/*
���̺� �����ϱ�
����] create table ���̺��(
            �÷���1 �ڷ���(ũ��),
            �÷���2 �ڷ���(ũ��),
            ...
            primary key(�÷���) ���� �������� �߰�
*/
CREATE table tb_member (
    idx number(10), -- ������(����)
    userid varchar2(30), -- ������
    passwd varchar2(50),
    username varchar2(30),
    mileage number(7, 2) -- ������(�Ǽ�)
);
-- ������ ������ ������ ���̺��� ����� Ȯ���Ѵ�.
SELECT * FROM TAB;
-- ���̺��� ����(��Ű��) Ȯ��. �÷���, �ڷ���, ũ�⸦ Ȯ���� �� �ִ�.
desc tb_member;

/*
���� ������ ���̺� ���ο� �÷� �߰��ϱ�
    => tb_member ���̺� email �÷��� �߰��Ͻÿ�.
����] alter table ���̺�� add �߰����÷��� �ڷ���(ũ��) ��������;
*/
alter table tb_member add email varchar2(100);
desc tb_member;

/*
���� ������ ���̺��� �÷� ����(����) �ϱ�
    => tb_member ���̺��� email �÷��� ����� 200���� Ȯ���Ͻÿ�.
    ���� �̸��� ����Ǵ� �÷��� 60���� Ȯ���Ͻÿ�.
����] alter table ���̺�� modify �������÷��� �ڷ���(ũ��);    
*/
alter table tb_member modify email varchar2(200);
alter table tb_member modify username varchar2(60);
desc tb_member;

/*
���� ������ ���̺��� �÷� ���� �ϱ�
    => tb_member ���̺��� mileage �÷��� �����Ͻÿ�.
����] alter table ���̺�� drop column �������÷���; 
*/
alter table tb_member drop column mileage;
desc tb_member;

/*
����] ���̺� ���Ǽ��� �ۼ��� employees ���̺��� �ش� study������ �״��
    �����Ͻÿ�. ��, ��������� ������� �ʽ��ϴ�.
*/
CREATE table employees (
    employee_id number(10),
    first_name varchar2(20),
    last_name varchar2(25),
    email varchar2(25),
    phone_number varchar2(25),
    hire_date date,
    job_id varchar2(10),
    salary number(8, 2),
    commission_pct number(2, 2),
    manager_id number(6),
    department_id number(4)
);
desc employees;

/*
���̺� �����ϱ�
    => employees ���̺��� �� �̻� ������� �����Ƿ� �����Ͻÿ�.
����] drop table ���������̺��;
*/
drop table employees;
desc employees;
select * from tab;

-- ���̺��� ����(drop)�ϸ� ������(recyclebin)�� �ӽ� �����ȴ�.
show recyclebin;
-- ������ ����
purge recyclebin;
-- �����뿡 ������ ���̺� �����ϱ�. ���⼭�� employees�� �����Ѵ�.
flashback table employees to before drop;

/*
tb_member ���̺� ���ο� ���ڵ带 �����Ѵ�.(DML���� �н�����)
������ ���̺� �����̽��� ������ ������ �� ���� �����̴�.
*/
insert into tb_member values (1, 'tjoeun', '1234', '������', 'tj@naver.com');
/*
Oracle 11g������ ���ο� ������ ������ �� connect, resources �� Role��
�ο��ϸ� ���̺� ���� �� ���Ա��� ������, �� ���� ����������
���̺� �����̽� ���� ������ �߻��Ѵ�. ���� �Ʒ��� ���� ���̺� �����̽��� ���� ���ѵ�
�Բ� �ο��ؾ� �Ѵ�.
*/
-- CMD�� ����ϰ� �ִٸ� conn ����� ���� �ٸ� �������� ����Ī�Ѵ�.
-- conn system/123456;
-- Developer������ ���� ����� ���� �޺��ڽ��� ���� system���� ������ �� ����� �����Ѵ�.
grant unlimited tablespace to study;

-- ���ڵ� ������ ���� study �������� ��ȯ �� insert ������ �����Ѵ�.
insert into tb_member values (2, 'hong', '1234', 'ȫ����', 'hong@naver.com');
insert into tb_member values (3, 'sung', '1234', '������', 'sung@naver.com');
-- ���Ե� ���ڵ� Ȯ��
select * from tb_member;

-- true�� �����̹Ƿ� ��� ���ڵ带 ������� �����Ѵ�.
select * from tb_member where 1 = 1;
-- false�� �����̹Ƿ� ���ڵ带 �������� �ʴ´�.
select * from tb_member where 1 = 0;


--���̺� ����1: ��Ű��(����)�� �����ϱ�
CREATE table tb_member_copy
as
SELECT * FROM tb_member WHERE 1 = 0;
--���̺��� ����Ǿ����� Ȯ��
desc tb_member_copy;
--���̺��� ������ ����Ǿ����Ƿ� ���ڵ�� ������� �ʴ´�.
select * from tb_member_copy;

--���̺� ����2: ��Ű��(����)�� ���ڵ���� ��� �����ϱ�
CREATE table tb_member_clone
as
SELECT * FROM tb_member WHERE 1 = 1;
--���̺��� ����Ǿ����� Ȯ��
desc tb_member_clone;
--true�� �������η� ������ ���ڵ� ��� ���������Ƿ� ����ȴ�.
select * from tb_member_clone;