/**********
���ϸ� : Or16SubProgram.sql
PL/SQL
���� : ����Ŭ���� �����ϴ� ���� ���ν���, �Լ�, �׸��� ���ν��� ������
        Ʈ���Ÿ� �н�
**********/

/*
���� ���α׷�(Sub Program)
- PL/SQL������ procedure�� �Լ���� �ΰ��� ������ Sub Program�� �ִ�.
- SELECT�� �����ؼ� �ٸ� DML���� �̿��Ͽ� ���α׷������� ��Ҹ� ����
    ��� �����ϴ�.
- Trigger�� Procedure�� �������� Ư�� ���̺��� ���ڵ��� ��ȭ�� ���� ���
    �ڵ����� ����ȴ�.
- �Լ��� �������� �Ϻκ����� ����ϱ� ���� �����Ѵ�. �� �ܺ� ���α׷�����
    ȣ���ϴ� ���� ���� ����.
- procedure�� �ܺ� ���α׷����� ȣ���ϱ� ���� �����Ѵ�. ���� Java, JSP
    ��� ������ ȣ��� ������ ������ ������ �� �ִ�.
*/

/*
1. ���� ���ν���(Stored Procedure)
- procedure�� return ���� ���� ��� out �Ķ���͸� ���� ���� ��ȯ�Ѵ�,
- ���ȼ��� ���� �� �ְ�, ��Ʈ��ũ�� ���ϸ� ���� �� �ִ�.
����= CREATE[OR REPLACE] PROCEDURE ���ν�����
     [(�Ű����� in �ڷ���, �Ű����� out �ڷ���)}
     IS [��������]
     BEGIN
        ���๮��;
     END;
     /
�� �ĸ����� ������ �ڷ����� ����ϰ�, ũ��� ������� �ʴ´�.
*/

--����1] ����� �޿��� �����ͼ� ����ϴ� ���ν��� ����
--�ó�����] 100�� ����� �޿��� select�Ͽ� ����ϴ� �������ν����� �����Ͻÿ�.
--���ν����� ������ 'OR REPLACE'�� �߰��ϴ� ���� �ٶ����ϴ�.
CREATE OR REPLACE PROCEDURE pcd_emp_salary
IS
    /*
    PL/SQL������ DECLARE���� ������ ����������, ���ν��������� IS������ �����Ѵ�.
    ���� ������ ���ٸ� ������ ������ �� �ִ�.
    */
    --employees ���̺��� salary �÷��� �����ϴ� ���������� �����Ѵ�.
    v_salary employees.salary%type;
BEGIN
    --employee_id�� 100���� ����� salary�� 'INTO'�� �̿��ؼ� ������ �����Ѵ�.
    SELECT salary INTO v_salary
    FROM employees
    WHERE employee_id = 100;
    
    dbms_output.put_line('�����ȣ 100�� �޿��� : ' || v_salary || '�Դϴ�.');
END;
/

-- ������ �������� Ȯ���Ѵ�. ����� �빮�ڷ� ����ǹǷ� ��ȯ�Լ��� �̿��Ѵ�.
SELECT * FROM user_source WHERE name LIKE UPPER('%pcd_emp_salary');

-- ù ������ ��� ���ʷ� �ѹ� �����ؾ� ����� �ȴ�.
SET SERVEROUTPUT ON;
-- ���ν����� ȣ���� ȣ��Ʈ ȯ�濡�� EXECUTE ����� �̿��Ѵ�.
EXECUTE pcd_emp_salary;

--����2] IN�Ķ���� ����Ͽ� ���ν��� ����
/*
�ó�����] ����� �̸��� �Ű������� �޾Ƽ� ������̺��� ���ڵ带 ��ȸ����
�ش����� �޿��� ����ϴ� ���ν����� ���� �� �����Ͻÿ�.
�ش� ������ in�Ķ���͸� ������ ó���Ѵ�.
����̸�(first_name) : Bruce, Neena
*/
--PROCEDURE ������ IN �Ķ���͸� ����. first_name�� �����ϴ� ���������� param_name ����
CREATE OR REPLACE PROCEDURE pcd_in_param_salary
    (param_name in employees.first_name%type)
IS
    valSalary NUMBER(10);
BEGIN
    --IS���� ������ ���� valSalary�� ������ ����� ����
    SELECT salary INTO valSalary
    FROM employees WHERE first_name = param_name;
    --��� ���
    dbms_output.put_line(param_name || '�� �޿��� ' || valSalary || ' �Դϴ�.');
END;
/
--�����ͻ������� Ȯ��
SELECT * FROM user_source WHERE name LIKE UPPER('%pcd_in_param_salary');
--EXECUTE ��ɾ�� PROCEDURE ����
EXECUTE pcd_in_param_salary('Bruce');
EXECUTE pcd_in_param_salary('Neena');


--����3] OUT�Ķ���� ����Ͽ� ���ν��� ����
/*
�ó�����] �� ������ �����ϰ� ������� �Ű������� ���޹޾Ƽ� �޿��� ��ȸ�ϴ�
���ν����� �����Ͻÿ�. ��, �޿��� out�Ķ���͸� ����Ͽ� ��ȯ�� ����Ͻÿ�
*/
/*
�ΰ��� ������ �Ķ���͸� ����. �Ϲݺ���, ���������� ���� ����ؼ� ����
�Ķ���ʹ� �뵵�� ���� IN, OUT�� ����ϰ�, ũ��� ������ ������� �ʴ´�.
*/
CREATE OR REPLACE PROCEDURE pcd_out_param_salary
    (
        param_name IN VARCHAR2,
        param_salary OUT employees.salary%TYPE
    )
IS
    /* SELECT�� ����� OUT �Ķ���Ϳ� ������ ���̹Ƿ� ������ ������ �ʿ����� �ʾ�
    IS���� ����д�.*/
BEGIN
    /* IN �Ķ���ʹ� WHERE���� �������� ����ϰ�, SELECT�� ����� INTO������
    OUT �Ķ���Ϳ� �����Ѵ�.*/
    SELECT salary INTO param_salary
    FROM employees WHERE first_name = param_name;
END;
/
--ȣ��Ʈȯ�濡�� ���ε� ������ �����Ѵ�. variable�� ����ص� �ȴ�.
VAR v_salary VARCHAR2(30);
/* ���ν��� ȣ��� ������ �Ķ���͸� ����Ѵ�. Ư�� ���ε庯���� :�� �ٿ��� �Ѵ�.
OUT �Ķ������ param_salary�� ����� ���� v_salary�� ���޵ȴ�. */
EXECUTE pcd_out_param_salary('Matthew', :v_salary);
--���ν��� ���� �� OUT �Ķ���͸� ���� ���޵� ���� ����Ѵ�. 
PRINT v_salary;

/*****
�ǽ��� ���� employees ���̺��� ���ڵ���� ��ü �����Ѵ�.
������ ���̺�� : zcopy_employees
*****/
CREATE TABLE zcopy_employees
AS
SELECT * FROM employees WHERE 1 = 1;
DESC zcopy_employees;
SELECT COUNT(*) FROM zcopy_employees;

/*
�ó�����] �����ȣ�� �޿��� �Ű������� ���޹޾� �ش����� �޿��� �����ϰ�,
���� ������ ���� ������ ��ȯ�޾Ƽ� ����ϴ� ���ν����� �ۼ��Ͻÿ�.
*/
/* IN �Ķ���ʹ� �����ȣ�� �޿��� ���޹޴´�. OUT �Ķ���ʹ� UPDATE��
����� ���� ������ ��ȯ�ϴ� �뵵�� �����Ѵ�. */
CREATE OR REPLACE PROCEDURE pcd_update_salary
    (
        p_empid IN NUMBER,
        p_salary IN NUMBER,
        rCount OUT NUMBER
    )
IS --�߰����� ���� ������ �ʿ�����Ƿ� ����
BEGIN
    --���� ������Ʈ�� ó���ϴ� ���������� IN �Ķ���͸� ���� ���� �����Ѵ�.
    UPDATE zcopy_employees
        SET salary = p_salary
        WHERE employee_id = p_empid;
    
    /*
    SQL%notFound : ���� ���� �� ����� ���� ���� ��� TRUE ��ȯ
        Found�� �ݴ��� ��� ��ȯ
    SQL%rowCount : ���� ���� �� ����� ���� ���� ��ȯ
    */
    IF SQL%notFound THEN
        dbms_output.put_line(p_empId || '��/�� ���� ����Դϴ�.');
    ELSE
        dbms_output.put_line(SQL%rowCount || '���� �ڷᰡ �����Ǿ����ϴ�.');
        
        --���� ����� ���� ������ ��ȯ�Ͽ� OUT �Ķ���Ϳ� �����Ѵ�.
        rCount := SQL%rowCount;
    END IF;
    /*
    ���� ��ȭ�� �ִ� ������ ������ ��� �ݵ�� COMMIT �ؾ� ���� ���̺�
    ����Ǿ� Oracle �ܺο��� Ȯ���� �� �ִ�.
    */
    COMMIT;
END;
/
-- ���ν��� ������ ���� ���ε� ���� ����
VARIABLE r_count NUMBER;
-- 100�� ����� �̸��� �޿��� Ȯ���Ѵ�.
SELECT first_name, salary FROM zcopy_employees WHERE employee_id = 100;
-- PROCEDURE ����. ���ε庯������ �ݵ�� COLON(:)�� �ٿ��� �Ѵ�.
EXECUTE pcd_update_salary(100, 30000, :r_count);
-- UPDATE�� ����� ���� ���� Ȯ��
PRINT r_count;
SELECT first_name, salary FROM zcopy_employees WHERE employee_id = 100;

-----------------------------------------
/*
2. �Լ�(Function)
- ����ڰ� PL/SLQ���� ����Ͽ� ����Ŭ���� �����ϴ� �����Լ��� ����
  ����� ������ ���̴�.
- �Լ��� IN �Ķ���͸� ����� �� �ְ�, �ݵ�� ��ȯ�� ���� �ڷ�����
  ����ؾ� �Ѵ�.
- ���ν����� �������� ������� ���� �� ������, �Լ��� �ݵ�� �ϳ���
  ���� ��ȯ�ؾ� �Ѵ�.
- �Լ��� �������� �Ϻκ����� ���ȴ�.
�� �Ķ���Ϳ� ��ȯŸ���� ����� �� ũ��� ������� �ʴ´�.
*/

/*
�ó�����] 2���� ������ ���޹޾Ƽ� �� ���� ������ ��� ���� ���ؼ�
����� ��ȯ�ϴ� �Լ��� �����Ͻÿ�.
���࿹) 2, 7 -> 2+3+4+5+6+7 = ??
*/
-- �Լ��� IN �Ķ���͸� �����Ƿ� IN�� �ַ� �����Ѵ�.
CREATE OR REPLACE FUNCTION calSumBetween (
    num1 IN NUMBER,
    num2 NUMBER
)
RETURN
    -- �Լ��� ��ȯ���� �ʼ��̹Ƿ� �ݵ�� ��ȯŸ���� ����ؾ� �Ѵ�.
    NUMBER
IS
    -- ���� ����(���û��� : �ʿ���� ��� ���� ����)
    sumNum NUMBER;
BEGIN
    sumNum := 0;
    
    -- FOR ���������� ���� ������ ���� ����� �� ��ȯ
    FOR i IN num1 .. num2 LOOP
        sumNum := sumNum + i;
    END LOOP;
    -- ����� ��ȯ�Ѵ�.
    RETURN sumNum;
END;
/
-- ������1 : �������� �Ϻη� ����Ѵ�.
SELECT calSumBetween(1, 10) FROM dual;

-- ������2 : ���ε� ������ ���� ���������� �ַ� ���������� ����Ѵ�.
VAR hapText VARCHAR2(50);
EXECUTE :hapText := calSumBetween(1, 100);
PRINT hapText;

-- ������ �������� Ȯ���ϱ�
SELECT * FROM user_source WHERE name = upper('calSumBetween');

/*
��������] 
����] �ֹι�ȣ�� ���޹޾Ƽ� ������ �Ǵ��ϴ� �Լ��� �����Ͻÿ�.
999999-1000000 -> '����' ��ȯ
999999-2000000 -> '����' ��ȯ
��, 2000�� ���� ����ڴ� 3�� ����, 4�� ������.
�Լ��� : findGender()
*/
--substr() �Լ��� ���� ������ �ش��ϴ� ���� �ϳ��� �߶󳽴�.
SELECT SUBSTR('999999-1000000', 8, 1) FROM dual;

CREATE OR REPLACE FUNCTION findGender (ssn VARCHAR2)
-- ��ȯŸ���� VARCHAR2
RETURN VARCHAR2
IS
    -- �ֺ��ȣ���� ������ �ش��ϴ� ���ڸ� �߶� ������ judgeGender ���� ����
    judgeGender VARCHAR2(10);
    -- ���ϰ��� ������ ����
    returnVal VARCHAR2(50);
BEGIN
    judgeGender := substr(ssn, 8, 1);
    /*
    [������ �亯]
    if judgeGender = '1' then
        returnVal := '����';
    elsif judgeGender = '3' then
        returnVal := '����';
    elsif judgeGender = '2' then
        returnVal := '����';
    elsif judgeGender = '4' then
        returnVal := '����';
    else returnVal := '�� �� ����';
    */
    
    IF judgeGender IN ('1', '3') THEN
        returnVal := '����';
    ELSIF judgeGender IN ('2', '4') THEN
        returnVal := '����';
    ELSE
        returnVal := '�߸��� �ֹι�ȣ';
    END IF;
    -- �Լ��� �ݵ�� ��ȯ���� �־�� �Ѵ�.
    RETURN returnVal;
END;
/
--����Ȯ��
select findGender('999999-1000000') from dual;
select findGender('999999-3000000') from dual;
select findGender('999999-4000000') from dual;
select findGender('999999-6000000') from dual;

/*
�ó�����] ������̸�(first_name)�� �Ű������� ���޹޾Ƽ�
�μ���(department_name)�� ��ȯ�ϴ� �Լ��� �ۼ��Ͻÿ�.
�Լ��� : func_deptName
*/

-- 1�ܰ� : 2���� ���̺��� JOIN �ؼ� ��� Ȯ��
SELECT
    first_name, last_name, department_id, department_name
FROM employees INNER JOIN departments USING(department_id)
WHERE first_name = 'Nancy';

-- 2�ܰ� : �Լ� �ۼ�(����� �̸��� ���Ķ���ͷ� ����)
CREATE OR REPLACE FUNCTION func_deptName (
    param_name VARCHAR2
)
RETURN
    -- �μ����� ��ȯ�ϹǷ� ���������� ��ȯŸ�� ����
    VARCHAR2
IS
    -- �μ����̺��� �μ������� �����ϴ� �������� ����
    return_deptname departments.department_name%TYPE;
BEGIN
    --USING�� ����� INNER JOIN�� ���� �μ����� �����Ͽ� ������ �����ϴ� ������ �ۼ�
    SELECT
        department_name INTO return_deptname
    FROM employees INNER JOIN departments USING(department_id)
    WHERE first_name = param_name;
    
    RETURN return_deptname;
END;
/
SELECT func_deptName('Nancy') FROM dual;
SELECT func_deptName('Diana') FROM dual;
------------------------------------------------
/*
3. Trigger
- �ڵ����� ����Ǵ� procedure�� ���� ������ �Ұ����ϴ�.
- �ַ� ���̺� �Էµ� ���ڵ��� ��ȭ�� ���� �� �ڵ����� ����ȴ�.
*/

-- Trigger �ǽ��� ���� departments ���̺��� �����Ѵ�.
-- original ���̺��� ���ڵ���� ��ü�� ����.
CREATE TABLE trigger_dept_original
AS
SELECT * FROM departments;

-- backup ���̺��� ��Ű��(����)�� ����.
CREATE TABLE trigger_dept_backup
AS
SELECT * FROM departments WHERE 1 = 0;
--���ڵ� Ȯ��
SELECT * FROM trigger_dept_original;
SELECT * FROM trigger_dept_backup;


--����1] trig_dept_backup
/*
�ó�����] ���̺� ���ο� �����Ͱ� �ԷµǸ� �ش� �����͸� ������̺� �����ϴ�
Ʈ���Ÿ� �ۼ��غ���.
*/
CREATE OR REPLACE TRIGGER trig_dept_backup
    /* Ÿ�̹�: AFTER�̹Ƿ� �̺�Ʈ �߻� �� */
    AFTER
    /* �̺�Ʈ : ���ڵ� �Է� �� �߻� �� */
    INSERT
    /* Trigger�� ������ ���̺�� */
    ON  trigger_dept_original
    /*
    �� ���� Ʈ���Ÿ� �����Ѵ�. �� �ϳ��� ���� ��ȭ�� ������ Ʈ���Ű� ����ȴ�.
    ���� ����(���̺�)���� Ʈ���ŷ� �����Ϸ��� �ش� ������ �����Ѵ�.
    �� ��� ������ �����ϸ� Ʈ���ŵ� �� �� ���� ����ȴ�.
    */
    FOR EACH ROW
BEGIN
    /* INSERT �̺�Ʈ�� �߻��Ǹ� TRUE�� ��ȯ�Ͽ� IF���� ����ȴ�. */
    IF Inserting THEN
        dbms_output.put_line('insert Ʈ���� �߻�');
        /*
        ���ο� ���ڵ尡 �ԷµǾ����Ƿ� �ӽ� ���̺� ':NEW'�� ����ǰ�
        �ش� ���ڵ带 ���� backup ���̺� �Է��� �� �ִ�.
        �̿� ���� �ӽ����̺��� �� ���� Ʈ���ſ����� ����� �� �ִ�.
        */
        INSERT INTO trigger_dept_backup
        VALUES (
            :NEW.department_id,
            :NEW.department_name,
            :NEW.manager_id,
            :NEW.location_id
        );
    END IF;
END;
/
-- ����Ȯ��
-- original ���̺� ���ڵ� ����
INSERT INTO trigger_dept_original values (101, '������', 10, 100);
INSERT INTO trigger_dept_original values (102, 'CS��', 10, 100);
INSERT INTO trigger_dept_original values (103, '������', 10, 100);
-- ���Ե� ���ڵ� Ȯ��
SELECT * FROM trigger_dept_original;
-- �ڵ����� ����� ���ڵ� Ȯ��
SELECT * FROM trigger_dept_backup;


--����2] trig_dept_delete
/*
�ó�����] �������̺��� ���ڵ尡 �����Ǹ� ������̺��� ���ڵ嵵 ����
�����Ǵ� Ʈ���Ÿ� �ۼ��غ���.
*/
CREATE OR REPLACE TRIGGER trig_dept_delete
    -- original ���̺��� ���ڵ带 ������ �� �� ������ Ʈ���Ÿ� ����
    AFTER
    DELETE
    ON trigger_dept_original
    FOR EACH ROW
BEGIN
    dbms_output.put_line('delete Ʈ���� �߻���');
    /*
    ���ڵ尡 ������ ���� �̺�Ʈ�� �߻��Ǿ� Ʈ���Ű� ȣ��ǹǷ�
    :OLD �ӽ����̺��� ����Ѵ�.
    */
    IF deleting THEN
        DELETE FROM trigger_dept_backup
            WHERE department_id = :OLD.department_id;
    END IF;
END;
/
-- ���ڵ带 �����ϸ� Ʈ���Ű� �ڵ� ȣ���
delete from trigger_dept_original where department_id=101;
-- ���ڵ� Ȯ��
SELECT * FROM trigger_dept_original;
SELECT * FROM trigger_dept_backup;

/*
FOR EACH ROW �ɼǿ� ���� Ʈ���� ����Ƚ�� �׽�Ʈ
����1 : �������� ���̺� ������Ʈ ���� ������� �߻��Ǵ� Ʈ���� ����
*/
--����3] trigger_update_test
CREATE OR REPLACE TRIGGER trigger_update_test
    AFTER UPDATE
    ON trigger_dept_original
    FOR EACH ROW
BEGIN
    IF updating THEN
        dbms_output.put_line('update Ʈ���� �߻���')
        /* ������Ʈ �̺�Ʈ�� �����Ǹ� backup ���̺� ���ڵ带 �Է��Ѵ�. */
        INSERT INTO trigger_dept_backup
        VALUES(
            :OLD.department_id,
            :OLD.department_name,
            :OLD.manager_id,
            :OLD.location_id
        );
    END IF;
END;
/

-- 5���� ���ڵ尡 �����
SELECT * FROM trigger_dept_original WHERE
    department_id >= 10 AND department_id <= 50;
-- �� ������ �״�� ����Ͽ� ���ڵ� ������Ʈ
UPDATE trigger_dept_original SET department_name = '5�� ������Ʈ'
WHERE department_id >= 10 AND department_id <= 50;
--������Ʈ �� ���ڵ� Ȯ��
SELECT * FROM trigger_dept_original;
/* �������̺��� �ѹ��� ������ 5���� ���ڵ尡 �����Ǿ����Ƿ�,
������̺��� 5���� ���ڵ尡 �Էµȴ�. */
SELECT * FROM trigger_dept_backup;
/*
    �� ����� Ʈ���Ŵ� ����� ���� ������ŭ �ݺ� ����ȴ�.
*/

/*
����2 : �������� ���̺� ������Ʈ ���� ���̺�(����) ������ �߻��Ǵ�
    Ʈ���� ����
*/
CREATE OR REPLACE TRIGGER trigger_update_test
    AFTER UPDATE
    ON trigger_dept_original
    /* FOR EACH ROW */
BEGIN
    IF updating THEN
        /* ������Ʈ �̺�Ʈ�� �����Ǹ� backup ���̺� ���ڵ带 �Է��Ѵ�. */
        INSERT INTO trigger_dept_backup
        VALUES(
            /*
            ���̺� ���� Ʈ���ſ����� �ӽ� ���̺�(:NEW, :OLD)��
            ����� �� ���� ���� �õ��� ������ �߻��Ѵ�.
            ���� ������ ���� ����ؾ� �Ѵ�.
            :OLD.department_id,
            :OLD.department_name,
            :OLD.manager_id,
            :OLD.location_id
            */
            999, to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'), 99, 9
        );
    END IF;
END;
/
-- ������Ʈ ����(2��° �����̸�, 5���� ���ڵ尡 ������Ʈ��)
UPDATE trigger_dept_original SET department_name = '5������2nd'
WHERE department_id >= 10 AND department_id <= 50;
--������Ʈ �� ���ڵ� Ȯ��
SELECT * FROM trigger_dept_original;
/* �������� ���̺��� 5���� ���ڵ尡 �����Ǿ����Ƿ�, ���̺� ���� Ʈ�����̹Ƿ�
������̺����� 1���� ���ڵ常 ���Եȴ�. */
SELECT * FROM trigger_dept_backup;

