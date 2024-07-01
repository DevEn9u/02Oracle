/**************
���ϸ� : Or14View.sql
View(��)
���� : View�� ���̺�κ��� ������ ������ ���̺�� ���������δ� ��������
    �ʰ� �������� �����ϴ� ���̺��̴�.
**************/

-- HR �������� �ǽ��մϴ�.

/*
SELECT ������ ������ �ش� ���̺��� ���ٸ�
"���̺� �Ǵ� �䰡 �������� �ʽ��ϴ�" ��� �����޼����� ���´�.
*/
SELECT * FROM member;

/*
���� ����
����] CREATE [OR REPLACE] VIEW �����̸� [(�÷�1, �÷�2, ...)]
    AS
    SELECT * FROM ���̺�� WHERE ����
    Ȥ�� JOIN�� �ִ� SELECT��
    GROUP BY�� �߰��� SELECT�� ��..
*/

/*
�ó�����] HR������ ������̺��� �������� ST_CLERK�� ����� ������
    ��ȸ�� �� �ִ� VIEW�� �����Ͻÿ�.
    ����׸�: employee_id, first_name, job_id, hire_date, department_id
*/
--1. �ó������� ���Ǵ�� SELECT���� �����Ѵ�.
SELECT
    employee_id, first_name, last_name, job_id, hire_date, department_id
FROM employees WHERE job_id = 'ST_CLERK';
--2. �� �����ϱ�
CREATE VIEW view_employees
AS
    SELECT
        employee_id, first_name, last_name, job_id, hire_date, department_id
    FROM employees WHERE job_id = 'ST_CLERK';
--3. �����ͻ������� Ȯ���ϱ�
SELECT * FROM user_views;
--4. �� �����ϱ�
SELECT * FROM view_employees;

/*
�� �����ϱ�
    : �� ���� ���忡 OR REPLACE�� �߰��ϸ� �ȴ�.
    �ش� �䰡 �����ϸ� �����ǰ�, �������� ������ ���Ӱ� �����Ѵ�.
    ���� ���ʷ� �並 ������ ������ ����ص� �����ϴ�.
*/

/*
�ó�����] �տ��� ������ �並 ������ ���� �����Ͻÿ�.
    ���� �÷��� employee_id, first_name, last_name, job_id,
    hird_date, department_id�� 
    id, fname, jobid, hdate, deptid�� �����Ͽ� �並 �����Ͻÿ�.
*/
CREATE OR REPLACE VIEW view_employees (id, fname, jobid, hdate, deptid)
AS
    SELECT 
        employee_id, first_name, job_id, hire_date, department_id
    FROM employees WHERE job_id = 'ST_CLERK';
/*
    �� ������ ���� ���̺��� �÷����� �����ؼ� ����ϰ� �ʹٸ� ���� ����
    ������ �÷����� �� �̸� �ڿ� �Ұ�ȣ�� ������ָ� �ȴ�.
*/
SELECT * FROM view_employees;

/*
����] ������ ���̵� ST_MAN�� ����� �����ȣ, �̸�, �̸���, �Ŵ������̵�
    ��ȸ�� �� �ֵ��� �ۼ��Ͻÿ�.
    ���� �÷����� e_id, name, email, m_id�� �����Ѵ�. ��, �̸��� 
    first_name�� last_name�� ����� ���·� ����Ͻÿ�.
	��� : emp_st_man_view
*/
CREATE OR REPLACE VIEW emp_st_man_view (e_id, name, email, m_id)
AS
    SELECT
        employee_id, first_name || ' ' || last_name, email, manager_id
    FROM employees WHERE job_id = 'ST_MAN';
SELECT * FROM emp_st_man_view;

--(����Թ���) ������ ���Ǵ�� SELECT�� �ۼ�
SELECT employee_id, first_name || ' ' || last_name, email, manager_id
FROM employees WHERE job_id = 'ST_MAN';
--�� ����
CREATE OR REPLACE VIEW emp_st_man_view (e_id, name, email, m_id)
AS
    SELECT
        employee_id, first_name || ' ' || last_name, email, manager_id
    FROM employees WHERE job_id = 'ST_MAN';
SELECT * FROM emp_st_man_view;
--�並 ���� ��� Ȯ��
SELECT * FROM emp_st_man_view;

 /*
����] �����ȣ, �̸�, ������ ����Ͽ� ����ϴ� �並 �����Ͻÿ�.
�÷��� �̸��� emp_id, l_name, annual_sal�� �����Ͻÿ�.
�������� -> (�޿�+(�޿�*���ʽ���))*12
���̸� : v_emp_salary
��, ������ ���ڸ����� �ĸ��� ���ԵǾ�� �Ѵ�. 
*/
CREATE OR REPLACE VIEW v_emp_salary (emp_id, l_name, annual_sal)
AS
    SELECT employee_id, last_name,                  
        TO_CHAR(((salary + salary * NVL(commission_pct, 0)) * 12), '999,000')
    FROM employees;
SELECT * FROM v_emp_salary;

/* (����� ����) SELECT�� �ۼ�(NULL���� �ִ� ��� ��Ģ������ ���� �����Ƿ� NVL()�Լ��� ����
0���� ��������� �Ѵ�. */
SELECT
    employee_id, last_name, (salary + nvl((salary * commission_pct), 0)) * 12
FROM employees;
-- �� ����
CREATE OR REPLACE VIEW v_emp_salary (emp_id, l_name, annual_sal)
AS
    SELECT
        employee_id, last_name, 
        ltrim(to_char((salary + (salary * nvl(commission_pct, 0))) * 12, '999,000'))
FROM employees;
--�� Ȯ��
SELECT * FROM v_emp_salary;

/*
�� ������ ������� �߰��Ǿ� ������ �÷��� �����Ǵ� ��쿡�� �ݵ��
��Ī���� �÷����� ����ؾ� �Ѵ�. �׷��� ������ �� ������ ������ �߻��Ѵ�.
*/
CREATE OR REPLACE VIEW v_emp_salary
AS
    SELECT
        employee_id, last_name, 
        (salary + nvl((salary * commission_pct), 0)) * 12
FROM employees;

 /*
-������ ���� View ����
�ó�����] ������̺�� �μ����̺�, �������̺��� �����Ͽ� ���� ���ǿ� �´� 
�並 �����Ͻÿ�.
����׸� : �����ȣ, ��ü�̸�, �μ���ȣ, �μ���, �Ի�����, ������
���Ǹ�Ī : v_emp_join
�����÷� : empid, fullname, deptid, deptname, hdate, locname
�÷��� ������� : 
	fullname => first_name+last_name 
	hdate => 0000��00��00��
    locname => XXX���� YYY (ex : Texas���� Southlake)	
*/
--1. SELECT�� �ۼ�
SELECT
    employee_id, first_name || ' ' || last_name, department_id,
    department_name, TO_CHAR(hire_date, 'YYYY"��" MM"��" DD"��"'), 
    city || ', ' || state_province
FROM employees
    INNER JOIN departments USING(department_id)
    INNER JOIN locations USING(location_id);
--2. VIEW ����
CREATE OR REPLACE VIEW v_emp_join (empid, fullname, deptid, deptname, 
    hdate, locname)
AS
    SELECT
        employee_id, first_name || ' ' || last_name, department_id,
        department_name, TO_CHAR(hire_date, 'YYYY"��" MM"��" DD"��"'), 
        city || ', ' || state_province
    FROM employees
        INNER JOIN departments USING(department_id)
        INNER JOIN locations USING(location_id);
--3. ������ �������� view�� ���� ������ ��ȸ�� �� �ִ�.
SELECT * FROM v_emp_join;