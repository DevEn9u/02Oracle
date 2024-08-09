/**********
���ϸ� : Or15PLSQL.sql
PL/SQL
���� : ����Ŭ���� �����ϴ� ���α׷��� ���
**********/


/*
PL/SQL(Procedural Language)
:�Ϲ� ���α׷��� ���� ������ �ִ� ��Ҹ� ��� ������ ������
DB������ ó���ϱ� ���� ����ȭ�� ����̴�.
*/
--HR�������� �ǽ��մϴ�.

--����1] PL/SQL ������
--ȭ��� ������ ����ϰ� ���� �� ON���� �����Ѵ�. OFF�϶��� ��µ��� �ʴ´�.
SET SERVEROUTPUT ON;

DECLARE --����� : �ַ� ������ �����Ѵ�.
    cnt NUMBER;
BEGIN --����� : ������ ���� ������ ����Ѵ�.
    cnt := 10; --������ 10�� ����. :=�� ����ؾ� �Ѵ�.
    cnt := cnt + 1;
    dbms_output.put_line(cnt); --Java�� println()�� �����ϴ�.
END;
/
/*
    PL/SQL ���� ������ �ݵ�� '/'�� �ٿ��� �Ѵ�. ���� �������� ������
    ȣ��Ʈ ȯ������ ���������� ���Ѵ�. �� PL/SQL������ Ż���ϱ� ���� �ʿ��ϴ�.
    ȣ��Ʈ ȯ��: �������� �Է��ϱ� ���� SQL> ������Ʈ�� �ִ� ����
*/

--����2] �Ϲݺ��� �� INTO
/* �ó�����] ������̺��� �����ȣ�� 120�� ����� �̸��� ����ó��
����ϴ� PL/SQL���� �ۼ��Ͻÿ�. */
SELECT * FROM employess WHERE employees_id = 120;
--�ó����� ���ǿ� �´� SELECT���� �ۼ��Ѵ�.
SELECT CONCAT(first_name || ' ', last_name), phone_number
FROM employees WHERE employees_id = 120;

DECLARE
    /* ����ο��� ������ ������ ���� ���̺� �����ÿ� �����ϰ� �����Ѵ�.
    �� ������ �ڷ���(ũ��);
    �� ������ ������ �÷��� Ÿ�԰� ũ�⸦ �����Ͽ� �����ϴ� ���� ����.
    �Ʒ� '�̸�'�� ��� 2���� �÷��� ������ �����̹Ƿ� ���� �� �˳��� ũ���
    �������ִ� ���� ����.*/
    empName VARCHAR2(50);
    empPhone VARCHAR2(30);
BEGIN
    /*
    �����: SELECT������ ������ ����� ����ο��� ������ ������ 1:1��
        �����Ͽ� ���� �����Ѵ�. �̶� INTO�� ����Ѵ�.
    */
    SELECT
        CONCAT(first_name || ' ', last_name),
        phone_number
    INTO
        empName, empPhone
    FROM employees
    WHERE employee_id = 120;
    
    dbms_output.put_line(empName || ' ' || empPhone);
END;
/

--����3] ��������1(�ϳ��� �÷� ����)
/*
    ��������: Ư�� ���̺��� �÷��� �����ϴ� ������, ������ �ڷ����� ũ���
        �����ϰ� ���� �� ����Ѵ�.
        ����] ���̺��.�÷���%type
            �� Ư�� ���̺��� '�ϳ�'�� �÷��� �����Ѵ�.
*/
/*
�ó�����] �μ���ȣ 10�� ����� �����ȣ, �޿�, �μ���ȣ�� �����ͼ�
�Ʒ� ������ ������ ȭ��� ����ϴ� PL/SQL���� �ۼ��Ͻÿ�.
��, ������ �������̺��� �ڷ����� �����ϴ� '��������'�� �����Ͻÿ�.
*/
--���ǿ� �´� ������ �ۼ�
SELECT employee_id, salary, department_id FROM employees
    WHERE department_id = 10;
    
DECLARE
    --������̺��� Ư�� �÷��� Ÿ�԰� ũ�⸦ �״�� �����ϴ� ������ ����
    empId employees.employee_id%type; --NUMBER(6,0)�� ���� �����ϰ� �����.
    empSal employees.salary%type; --NUMBER(8,2)�� ���� �����ϰ� �����.
    deptId employees.department_id%type;
BEGIN
    SELECT employee_id, salary, department_id
        into empId, empsal, deptId
    FROM employees
    WHERE department_id = 10;
    
    dbms_output.put_line(empId || ' ' || empSal || ' ' || deptId);
END;
/

--����4] ��������2(��ü  �÷� ����)
/*
�ó�����] �����ȣ�� 100�� ����� ���ڵ带 �����ͼ�
emp_row������ ��ü�÷��� ������ �� ȭ�鿡 ���� ������ ����Ͻÿ�.
��, emp_row�� ������̺��� ��ü�÷��� ������ �� �ִ� ���������� �����ؾ��Ѵ�. 
������� : �����ȣ, �̸�, �̸���, �޿�
*/
DECLARE
    /* ������̺��� ��ü�÷��� �����ϴ� ���������� �����Ѵ�.
    ���̺�� �ڿ� %rowtype�� �ٿ��ָ� �ȴ�. */
    emp_row employees%rowtype;
BEGIN
    /* ���ϵ�ī�� *�� ���� ���� ��ü�÷��� ���� emp_row�� �ѹ��� 
    ������ �� �ִ�.*/
    SELECT *
        INTO emp_row
    FROM employees WHERE employee_id = 100;
    /* emp_row���� ��ü�÷��� ������ ����ǹǷ� ��½� ������.�÷��� ���·�
    ����ؾ� �Ѵ�.*/
    
    dbms_output.put_line(emp_row.employee_id || ' ' ||
                        emp_row.first_name || ' ' ||
                        emp_row.email || ' ' ||
                        emp_row.salary);
END;
/

--����5] ���պ���
/*
���պ���
    :class�� �����ϵ� �ʿ��� �ڷ����� ����� ��� �����ϴ� ����
    ����]
        type ���պ����ڷ��� IS RECORD(
            �÷���1 �ڷ���(ũ��),
            �÷���2 ���̺��.�÷���%type
        );
    �տ��� ������ �ڷ����� ������� ������ �����Ѵ�.
    ���պ��� �ڷ����� ���� ���� �Ϲݺ����� �������� 2������ �����ؼ�
    ����� �� �ִ�.
*/
-- �̸��� concat���� ������ �� ����Ѵ�.
SELECT employee_id, first_name || ' ' || last_name, job_id
FROM employees WHERE employee_id = 100;

DECLARE
    -- 3���� ���� ������ �� �ִ� ���պ����ڷ����� �����Ѵ�.
    TYPE emp_3type IS RECORD(
        /* ������̺��� �����ϴ� ���������� ���� */
        emp_id employees.employee_id%type,
        /* �Ϲݺ����� ���� */
        emp_name VARCHAR2(50),
        emp_job employees.job_id%type
    );
    /* �տ��� ������ �ڷ����� ���� ���պ����� �����Ѵ�. �� ������ 3���� ����
    ������ �� �ִ�. */
    record3 emp_3type;
BEGIN
    SELECT employee_id, first_name || ' ' || last_name, job_id
        INTO record3
    FROM employees WHERE employee_id = 100;
    
    dbms_output.put_line(record3.emp_id || ' ' ||
                       record3.emp_name || ' ' ||
                       record3.emp_job);
END;
/

/*�Ʒ� ������ ���� PL/SQL���� �ۼ��Ͻÿ�.
1.���պ�������
- �������̺� : employees
- ���պ����ڷ����� �̸� : empTypes
        ���1 : emp_id -> �����ȣ
        ���2 : emp_name -> �������ü�̸�(�̸�+��)
        ���3 : emp_salary -> �޿�
        ���4 : emp_percent -> ���ʽ���
������ ������ �ڷ����� �̿��Ͽ� ���պ��� rec2�� ������ �����ȣ 108���� ������ �Ҵ��Ѵ�.
2.1�� ������ ����Ѵ�.
3.�� ������ �Ϸ����� ġȯ�����ڸ� ����Ͽ� �����ȣ�� ����ڷκ���
�Է¹��� �� �ش� ����� ������ ����Ҽ��ֵ��� �����Ͻÿ�.[����]
*/
--����� �־��� ������ �����ϴ� ������ �ۼ�
SELECT
    employee_id, first_name || ' ' || last_name, salary,
    nvl(commission_pct, 0)
FROM employees WHERE employee_id = 108;


DECLARE
    TYPE empTypes IS RECORD(
        -- 4���� ������ ���� ���պ����ڷ��� ����
        emp_id employees.employee_id%type,
        emp_name VARCHAR2(50),
        emp_salary employees.salary%type,
        emp_percent employees.commission_pct%type
    );
    -- ���պ����ڷ����� ���� ������ �����Ѵ�.
    rec2 empTypes;
BEGIN
    SELECT
        employee_id,
        first_name || ' ' || last_name,
        salary,
        commission_pct
        INTO rec2
    FROM employees WHERE employee_id = 108;
    
    dbms_output.put_line('�����ȣ / ����� / �޿� / ���ʽ���');
    dbms_output.put_line(rec2.emp_id || ' ' ||
                       rec2.emp_name || ' ' ||
                       rec2.emp_salary || ' ' ||
                       rec2.emp_percent);
END;
/


/*
ġȯ������ : PL/SQL���� ����ڷκ��� �����͸� �Է¹��� �� ����ϴ� �����ڷ�
    �����տ� &�� �ٿ��ָ� �ȴ�. ����� �Է�â�� ���.
*/
DECLARE
    TYPE empTypes IS RECORD(
        -- 4���� ������ ���� ���պ����ڷ��� ����
        emp_id employees.employee_id%type,
        emp_name VARCHAR2(50),
        emp_salary employees.salary%type,
        emp_percent employees.commission_pct%type
    );
    -- ���պ����ڷ����� ���� ������ �����Ѵ�.
    rec2 empTypes;
    -- ġȯ�����ڸ� ���� �Է¹��� ���� �Ҵ��� ������ �����Ѵ�.
    inputNum number(3);
BEGIN
    SELECT
        employee_id,
        first_name || ' ' || last_name,
        salary,
        commission_pct
        INTO rec2
    FROM employees WHERE employee_id = &inputNum;
    
    dbms_output.put_line(rec2.emp_id || ' ' ||
                       rec2.emp_name || ' ' ||
                       rec2.emp_salary || ' ' ||
                       rec2.emp_percent);
END;
/

-- ����6] ���ε庯��
/*
���ε庯��
    : ȣ��Ʈ ȯ�濡�� ����� ������, �� PL/SQL �����̴�.
      ȣ��Ʈ ȯ���̶� PL/SQL ���� ������ ������ �κ��� ���Ѵ�.
      �ֿܼ����� SQL> ������Ʈ�� �ִ� ���¸� ���Ѵ�.
      ����]
        var ������ �ڷ���;
        Ȥ��
        variable ������ �ڷ���;
*/
set serveroutput on;
-- ȣ��Ʈ ȯ�濡�� ���ε� ���� ����
VAR return_var = NUMBER;

DECLARE -- ����ο����� �̿� ���� �ƹ� ������ ���� ���� �ִ�.
BEGIN
    -- ���ε庯���� �Ϲݺ������� ������ ���� :(colon)�� �߰��ؾ� �Ѵ�.
    :return_var := 999;
    dbms_output.put_line(:return_var);
END;
/

PRINT return_var;
/*
ȣ��Ʈ ȯ�濡�� ���ε� ������ ����� ���� PRINT�� ����Ѵ�.
CMD������ ���������� �����ص� ������ ������, developer������ ���ε� �����κ���
������ PRINT������ ������ ���� �� �����ؾ� ����� ���������� ���´�.
*/