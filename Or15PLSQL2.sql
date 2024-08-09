-----------------------------------
--���(���ǹ�) : IF��, CASE���� ���� ���ǹ��� �н��Ѵ�.

--����7] IF�� �⺻
--�ó�����] ������ ����� ���ڰ� Ȧ�� or ¦������ �Ǵ��ϴ� PL/SQL�� �ۼ��Ͻÿ�.
-- IF�� : Ȧ���� ¦���� �Ǵ��ϴ� IF�� �ۼ�
DECLARE
    -- ����ο��� ����Ÿ���� ������ ����
    NUM NUMBER;
BEGIN
    -- �ʱⰪ���� 10�� �Ҵ�
    NUM := 10;
    -- 2�� ���� �������� 0���� �Ǵ��Ͽ� Ȧ¦ ����
    IF MOD(NUM, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE(NUM || '��/�� ¦��');
    ELSE
        DBMS_OUTPUT.PUT_LINE(NUM || '��/�� Ȧ��');
    END IF;
END;
/

--����8] ���(���ǹ� : if-elsif)
/*
�ó�����] �����ȣ�� ����ڷκ��� �Է¹��� �� �ش� ����� ��μ�����
�ٹ��ϴ����� ����ϴ� PL/SQL���� �ۼ��Ͻÿ�. ��, if~elsif���� ����Ͽ�
�����Ͻÿ�.
*/
DECLARE
    --ġȯ�����ڸ� ���� ���� �ʱ�ȭ
    emp_id employees.employee_id%type := &emp_id;
    emp_name VARCHAR2(50); -- �Ϲݺ���
    emp_dept employees.department_id%type; --��������
    -- �ʿ��ϴٸ� ����ο��� ������ �ʱ�ȭ�� �� ����
    dept_name VARCHAR2(30) := '�μ���������';
BEGIN
    -- ������ INTO���� WHERE������ ���
    SELECT employee_id, last_name, department_id
        INTO emp_id, emp_name, emp_dept
    FROM employees
    WHERE employee_id = emp_id;
    
    /* �������� ������ ����� ��� Java�� ���� else if�� ������� �ʰ�
    ELSIF�� ����ؾ� �Ѵ�. ���� �߰�ȣ ��� THEN�� END IF�� ����Ѵ�. */
    IF emp_dept = 50 THEN
        dept_name := 'Shipping';
    ELSIF emp_dept = 60 THEN
        dept_name := 'IT';
    ELSIF emp_dept = 70 THEN
        dept_name := 'Publich Relations';
    ELSIF emp_dept = 80 THEN
        dept_name := 'Sales';
    ELSIF emp_dept = 90 THEN
        dept_name := 'Executive';
    ELSIF emp_dept = 100 THEN
        dept_name := 'Finance';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('�����ȣ' || emp_id || '�� ����');
    DBMS_OUTPUT.PUT_LINE('�̸�: ' || emp_name
            ||', �μ���ȣ: ' || emp_dept
            ||', �μ���: '|| dept_name);
END;
/

/*
CASE��
: Java�� switch���� ����� ���ǹ�
����]
    CASE ����
        WHEN ��1 THEN '�Ҵ簪1'
        WHEN ��2 THEN '�Ҵ簪2'
        ... ��N
    END;
*/
-- ����9] ���(���ǹ� : case~when)
-- �ó�����] �տ��� if~elsif�� �ۼ��� PL/SQL���� case~when������ �����Ͻÿ�.
DECLARE
    emp_id employees.employee_id%type := &emp_id;
    emp_name VARCHAR2(50);
    emp_dept employees.department_id%type;
    dept_name VARCHAR2(30) := '�μ���������';
BEGIN
    SELECT employee_id, last_name, department_id
    INTO emp_id, emp_name, emp_dept
    FROM employees
    WHERE employee_id = emp_id;
    
    /* CASE~WHEN���� IF���� �ٸ� ��
     - �Ҵ��� ������ ���� ������ �� ���� ������ ������ �Ǵ��Ͽ�
       �ϳ��� ���� �Ҵ��ϴ� ���
       ���� ������ �ߺ����� ������� �ʾƵ� �ȴ�.
    */
    dept_name :=
        CASE emp_dept
            WHEN 50 THEN 'Shipping'
            WHEN 60 THEN 'IT'
            WHEN 70 THEN 'Public Relations'
            WHEN 80 THEN 'Sales'
            WHEN 90 THEN 'Executive'
            WHEN 100 THEN 'Finance'
        END;
    DBMS_OUTPUT.PUT_LINE('�����ȣ' || emp_id || '�� ����');
    DBMS_OUTPUT.PUT_LINE('�̸�: ' || emp_name
            ||', �μ���ȣ: ' || emp_dept
            ||', �μ���: '|| dept_name);
END;
/

-------------------------------------------------
--���(�ݺ���)
/*
�ݺ���1 : Basic Loop��
    Java�� do~while���� ���� ���� üũ ���� �ϴ� LOOP�� ������ ��
    Ż�� ������ �� ������ �ݺ��Ѵ�. Ż��ÿ��� EXIT�� ����Ѵ�.
*/
--����10] ���(�ݺ��� : basic loop)
DECLARE
    -- ������ NUMBER Ÿ������ ���� �� 0���� �ʱ�ȭ
    num NUMBER := 0;
BEGIN
    -- ���� üũ ���� LOOP�� ����
    LOOP
        DBMS_OUTPUT.PUT_LINE(num);
        /* ���������ڳ� ���մ��Կ����ڰ� �����Ƿ� �Ϲ����� �������
        ������ �������Ѿ� �Ѵ�. */
        num := num + 1;
        /* num�� 10�� �ʰ��ϸ� loop���� Ż���Ѵ�. exit�� Java�� break��
        �����ϰ� �ݺ����� Ż���Ѵ�. */
        EXIT WHEN (num > 10);
    END LOOP;
END;
/

--����11] ���(�ݺ��� : basic loop)
--�ó�����] Basic loop������ 1���� 10������ ������ ���� ���ϴ� ���α׷��� �ۼ��Ͻÿ�.
DECLARE
    i NUMBER := 1;
    /* �������� �����ϱ� ���� ������, Java������ ���� sum�̶�� �������� ���������,
    Oracle������ �׷��Լ� sum()�� �����Ƿ�(�����) ��뿡 �����ؾ� �Ѵ�. */
    sumNum NUMBER := 0;
BEGIN
    LOOP
        -- �����ϴ� ���� i�� �����ؼ� �����ش�.
        sumNum := sumNum + i;
        i := i + 1;
        EXIT WHEN (i > 10);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1~10������ �� : ' || sumNum);
END;
/

/*
�ݺ���2 : WHILE��
    Basic Loop�� �ٸ��� ������ ���� Ȯ���� �� �����Ѵ�.
    ��, ���ǿ� ���� �ʴ´ٸ� �ѹ��� ������� ���� �� �ִ�.
    �ݺ��� ������ �����Ƿ� Ư���� ��찡 �ƴ϶�� EXIT�� 
    ������� �ʾƵ� �ȴ�.
*/
--����12] ���(�ݺ��� : while)
DECLARE
    num1 NUMBER := 0;
BEGIN
    --WHILE�� ���� �� ������ ���� Ȯ���Ѵ�.
    WHILE num1 < 11 LOOP
        -- 0~10���� ���
        DBMS_OUTPUT.PUT_LINE('�̹����ڴ� : ' || num1);
        num1 := num1 + 1;
    END LOOP;
END;
/
--����13] ���(�ݺ��� : while)
/*
�ó�����] while loop������ ������ ���� ����� ����Ͻÿ�.
*
**
***
****
*****
*/
DECLARE
    --*�� �����ؼ� ������ VARCHAR2 ���� ����
    starStr VARCHAR2(100);
    --�ݺ��� ���� ����
    i NUMBER := 1;
BEGIN
    WHILE i <= 5 LOOP
        --�ݺ��� ������ *�� ���ڿ��� ����
        starStr := starStr || '*';
        DBMS_OUTPUT.PUT_LINE(starStr);
        --i�� ����
        i := i + 1;
    END LOOP;
END;
/

--����14] ���(�ݺ��� : while) 
--�ó�����] while loop������ 1���� 10������ ������ ���� ���ϴ� ���α׷��� �ۼ��Ͻÿ�.
DECLARE
    i NUMBER := 1;
    sumNum NUMBER := 0;
BEGIN
    WHILE i <= 10 LOOP
        sumNum := sumNum + i;
        i := i + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1~10���� ���� ���� : ' || sumNum);
END;
/
/*
�ݺ���3 : FOR��
    �ݺ��� Ƚ���� �����Ͽ� ����� �� �ִ� �ݺ������� �ݺ��� ���� ������
    ������ �������� �ʾƵ� �ȴ�. �׷��Ƿ� Ư���� ������ ���ٸ� ����θ�
    ������� �ʾƵ� �ȴ�.
*/
--����15] ���(�ݺ��� : for)
DECLARE
    -- ����ο� ������ ������ ����.
BEGIN
    -- �ݺ��� ���� ������ ������ ���� ���� FOR������ ����� �� �ִ�.
    FOR num2 IN 0 .. 10 LOOP
        DBMS_OUTPUT.PUT_LINE('FOR�� ¯�ε� : ' || num2);
    END LOOP;
END;
/

-- ���� ������ �ʿ� ���ٸ� DECLARE�� ���� �����ϴ�.
BEGIN
    FOR num3 IN REVERSE 0 .. 10 LOOP
        DBMS_OUTPUT.PUT_LINE('�Ųٷ� FOR�� ¯�ε� : ' || num3);
    END LOOP;
END;
/

--����16] ���(�ݺ��� : for) 
--��������] for loop������ �������� ����ϴ� ���α׷��� �ۼ��Ͻÿ�. 
BEGIN
    FOR dan IN 2..9 LOOP
        DBMS_OUTPUT.PUT_LINE(dan || '��');
        FOR su IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(dan|| ' x ' || su || '=' || dan * su);
        END LOOP;
    END LOOP;
END;
/

DECLARE
    newStr VARCHAR2(1000);
BEGIN
    FOR dan IN 2..9 LOOP
        FOR su IN 1..9 LOOP
            newStr := newStr || dan || ' x ' || su || '=' || dan * su || ' ';
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(dan || '��: ' || newStr);
        newStr := '';
    END LOOP;
END;
/
/*
Ŀ��(Cursor)
    :SELECT ������ ���� ���� ���� ��ȯ�Ǵ� ��� �� �࿡ �����ϱ� ���� ��ü
    ���� ���]
        CURSOR Ŀ���� IS
            SELECT ������. �� INTO���� ���� ���·� ����Ѵ�.
            
        OPEN CURSOR
            : ������ �����϶�� �ǹ�. �� OPEN�Ҷ� CURSOR ����� SELECT����
              ����Ǿ� ������� ��� �ȴ�. CURSOR�� �� ������� ù��° �࿡
              ��ġ�ϰ� �ȴ�.
        FETCH~INTO~
            : ����¿��� �ϳ��� ���� �о���̴� �۾����� ������� ����(FETCH)
              �Ŀ� CURSOR�� ���� ������ �̵��Ѵ�.
        CLOSE CURSOR
            : Ŀ�� �ݱ�� ������� �ڿ��� �ݳ��Ѵ�. SELECT ������ ��� ó���� ��
              CURSOR�� �ݾ��ش�.
              
        CURSOR�� �Ӽ�
            %Found : ���� �ֱٿ� ����(FETCH)�� ���� return �ϸ� True, �ƴϸ�
                False�� ��ȯ�Ѵ�.
            %NotFound : %Found�� �ݴ� ���� ��ȯ.
            %RowCount : ���ݱ��� return�� ���� ���� ��ȯ.
*/
--����17] Cursor
--�ó�����] �μ����̺��� ���ڵ带 Cursor�� ���� ����ϴ� PL/SQL���� �ۼ��Ͻÿ�.
DECLARE
    -- �μ����̺��� ��ü�÷��� �����ϴ� ���������� ����
    v_dept departments%rowtype;
    /* Ŀ�� ���� : �μ����̺��� ��� ���ڵ带 ��ȸ�ϴ� SELECT������
        INTO���� ���� ���·� �������� �ۼ��Ѵ�. ������ ��������
        cur1�� ����ȴ�.*/
    CURSOR cur1 IS
        SELECT
            department_id, department_name, location_id
        FROM departments;
BEGIN
    /* �ش� �������� �����ؼ� �����(ResultSet)�� ���´�. ������̶�
    �������� ������ �� ��ȯ�Ǵ� ���ڵ��� ����� ���Ѵ�. */
    OPEN cur1;
    
    -- basic ���������� ���� ������� ������ŭ �ݺ��Ͽ� �����Ѵ�.
    LOOP
        FETCH cur1 INTO
            -- FETCH(����)�� ����� ���������� ���� INTO(����)�Ѵ�.
            v_dept.department_id,
            v_dept.department_name,
            v_dept.location_id;
        
        -- Ż�� �������� �� �̻� ������ ���� ������ EXIT�� ����ȴ�.
        EXIT WHEN cur1%notfound;
        
        DBMS_OUTPUT.PUT_LINE(v_dept.department_id || ' ' ||
                        v_dept.department_name || ' ' ||
                        v_dept.location_id);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('����� ���� ����: ' || cur1%rowcount);
        -- Ŀ���� �ڿ� �ݳ�
        CLOSE cur1;
END;
/
    


--����18] Cursor
/*
�ó�����] Cursor�� ����Ͽ� ������̺��� Ŀ�̼��� null�� �ƴ� �����
�����ȣ, �̸�, �޿��� ����Ͻÿ�. ��½ÿ��� �̸��� ������������ �����Ͻÿ�.
*/
--���ˤ��� �´� �������� ����. 35�� ���� �����.
SELECT * FROM employees WHERE commission_pct IS NOT NULL
ORDER BY last_name ASC;

--PL/SQL�� �ۼ�
DECLARE
    -- �ۼ��� �������� ���� Ŀ�� ����
    CURSOR curEmp IS
        SELECT employee_id, last_name, salary
        FROM employees
        WHERE commission_pct IS NOT NULL
        ORDER BY last_name ASC;
    -- ��� ���̺��� ��ü �÷��� �����ϴ� �������� ����
    varEmp employees%rowType;
BEGIN
    -- Ŀ���� OPEN�ؼ� ���� ����
    OPEN curEmp;
    --BASIC LOOP�� ���� Ŀ���� ����� ����� ����
    LOOP
        -- ������ ������ ���������� ����
        FETCH curEmp
            INTO varEmp.employee_id, varEmp.last_name, varEmp.salary;
        -- ������ ������ ���ٸ� LOOP�� Ż��
        EXIT WHEN curEmp%notFound;
        DBMS_OUTPUT.PUT_LINE(varEmp.employee_id || ' ' ||
                            varEmp.last_name || ' ' ||
                            varEmp.salary);
        END LOOP;
        --Ŀ���� �ݾƼ� �ڿ�����
        CLOSE curEmp;
END;
/
--����19] �����迭(Associative Array)
/*
�ó�����] ������ ���ǿ� �´� �����迭�� ������ �� ���� �Ҵ��Ͻÿ�.
    �����迭 �ڷ��� �� : avType, �����ڷ���:������, Ű���ڷ���:������
    key : girl, boy
    value : Ʈ���̽�, ��ź�ҳ��
    ������ : var_array
*/
/*
�÷���(�迭)
    : �Ϲ� ���α׷��� ���� ����ϴ� �迭Ÿ���� PL/SQL��������
    ���̺�Ÿ���̶�� �Ѵ�. 1,2 ���� �迭�� �����غ��� ���̺�(ǥ)�� ���� �����̱� �����̴�.
1. �����迭(Associative Array)
    : Key�� Value�� ������ ������ collection���� Java�� Map�� �����ϴ�.
    ����]
        Type �����迭�ڷ��� IS
            TABLE OF Value�� Ÿ��
            INDEX OF Key�� Ÿ��;
*/
DECLARE
    --�����迭 �ڷ��� ����
    TYPE avType IS
        TABLE OF VARCHAR2(30) /* Value�� �ڷ��� ���� */
        INDEX BY VARCHAR2(10); /* Key�� �ڷ��� ���� */
    --������ �ڷ����� ���� �����迭 ���� ����
    var_array avType;
BEGIN
    --�����迭�� �� �Ҵ�
    var_array('girl') := 'Ʈ���̽�';
    var_array('boy') := '��ź�ҳ��';
    
    DBMS_OUTPUT.PUT_LINE(var_array('girl'));
    DBMS_OUTPUT.PUT_LINE(var_array('boy'));
END;
/

--����20] �����迭(Associative Array)
/*
�ó�����] 100�� �μ��� �ٹ��ϴ� ����� �̸��� �����ϴ� �����迭�� �����Ͻÿ�.
key�� ����, value�� full_name ���� �����Ͻÿ�.
*/
-- 100�� �μ��� �ٹ��ϴ� ��� ���: 6��
SELECT * FROM employees WHERE department_id = 100;
-- Fullname�� ����ϱ� ���� ������ �ۼ�
SELECT first_name || ' ' || last_name
    FROM employees WHERE department_id = 100;

--������ ������ ���� ������ ������� �ټ����� ����ǹǷ� CURSOR�� ����ؾ� �Ѵ�.
DECLARE
    --�������� ���� Ŀ���� ����
    CURSOR emp_cur IS
        SELECT first_name || ' ' || last_name FROM employees
        WHERE department_id = 100;
    --�����迭 �ڷ��� ����(Key: ������-BINARY_INTEGER, Value: ������-VARCHAR2(30))
    TYPE nameAvType IS
        TABLE OF VARCHAR2(30)
        INDEX BY BINARY_INTEGER;
    --�����迭 ���� ����
    names_arr nameAvType;
    --����� �̸��� �ε����� ����� ���� ����
    fname VARCHAR2(50);
    idx NUMBER := 1;
BEGIN
    /* Ŀ���� OPEN�Ͽ� �������� ������ �� ���� ������� ������ŭ
    �ݺ��Ͽ� ������� �����Ѵ�. */
    OPEN emp_cur;
    LOOP
        --�̸��� ������ �Է�
        FETCH emp_cur INTO fname;
        --�����迭 ������ ����̸��� �Է�
        EXIT WHEN emp_cur%NotFound;
        names_arr(idx) := fname;
        idx := idx + 1;
    END LOOP;
    --��� ������ �Ϸ�Ǹ� Ŀ���� �ݴ´�.
    CLOSE emp_cur;
    
    --�����迭����.COUNT: �����迭�� ����� ����� ������ ��ȯ
    FOR i IN 1 .. names_arr.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(names_arr(i));
    END LOOP;
END;
/

/*
2. VArray(Variable Array)
    : �������̸� ���� �迭��, �Ϲ� ���α׷��� ���� ����ϴ� �迭��
    �����ϴ�. ũ�⿡ ������ �־ ����� ũ��(������ ����)�� �����ϸ�
    �̺��� ū �迭�� ���� �� ����.
    ����] TYPE �迭Ÿ�Ը� IS
            ARRAY(�迭ũ��) OF ���� Ÿ��;
*/
--����21] VArray(Variable Array)
DECLARE
    --VArray Ÿ�� ����. ũ��� 5, ������ �������� Ÿ���� VARCHAR2 Ÿ������ ����.
    TYPE vaType IS
        ARRAY(5) OF VARCHAR2(20);
    -- VArray Ÿ���� �迭���� ����
    v_arr vaType;
    -- �ε����� ����� ���� ����
    cnt NUMBER := 0;
BEGIN
    --�����ڸ� ���� ���� �ʱ�ȭ. �� 5���� 3���� �Ҵ�.
    v_arr := vaType('First', 'Second', 'Third', '', '');
    
    --Basic ���������� �迭�� ���Ҹ� ����Ѵ�.(���ε����� 1���� ����)
    loop
        cnt := cnt + 1;
        --Ż�� ������ WHEN ��� IF�� ����� ���� �ִ�.
        IF cnt > 5 THEN
            EXIT;
        END IF;
        --�迭ó�� �ε����� ���� ����Ѵ�.
        DBMS_OUTPUT.PUT_LINE(v_arr(cnt));
    END LOOP;
    
    --�迭�� ���� ���Ҵ�
    v_arr(3) := '�츮��';
    v_arr(4) := 'JAVA';
    v_arr(5) := '�����ڴ�';
    
    --FOR ���������� ���
    FOR i IN 1 .. 5 LOOP
        DBMS_OUTPUT.PUT_LINE(v_arr(i));
    END LOOP;
END;
/

--����22] VArray(Variable Array)
/*
�ó�����] 100�� �μ��� �ٹ��ϴ� ����� �����ȣ�� �����Ͽ� VArray�� ������ ��
����ϴ� PL/SQL�� �ۼ��Ͻÿ�.
*/
--6���� ���ڵ尡 �����
SELECT * FROM employees WHERE department_id = 100;

DECLARE
    /* VArray �ڷ��� ���� : �迭�� ����� ���� ������̵� �÷��� �����Ͽ�
        �����Ѵ�.*/
    TYPE vaType1 IS
        ARRAY(6) OF employees.employee_id%Type;
    --�迭���� ���� �� �����ڸ� ���� �ʱ�ȭ�� �����Ѵ�.
    va_one vaType1 := vaType1('', '', '', '', '', '');
    cnt NUMBER := 1;
BEGIN
    /*
    Java�� Ȯ�� for���� ����ϰ� ������ ������� ������ŭ �ڵ�����
    �ݺ��ϴ� ���·� ����Ѵ�. SELECT���� employee_id�� ���� i��
    �Ҵ�ǰ� �̸� ���� ������ �� �ִ�.
    */
    FOR i IN (SELECT employee_id FROM employees
                    WHERE department_id = 100) LOOP
        --������ �����͸� �迭�� ������� �����Ѵ�.
        va_one(cnt) := i.employee_id;
        cnt := cnt + 1;
    END LOOP;
    
    --�迭�� ũ�⸸ŭ �ݺ��Ͽ� �� ��Ҹ� ���
    FOR j IN 1 .. va_one.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(va_one(j));
    END LOOP;
END;
/

/*
3. ��ø���̺�(Nested Table)
    : VArray�� ����� ������ �迭��, �迭�� ũ�⸦ ������� �����Ƿ�
        �������� �迭�� ũ�Ⱑ �����ȴ�.
    ����] TYPE ��ø���̺�� IS
            TABLE OF ���� Ÿ��;
*/
--����23] ��ø���̺�(Nested Table)
DECLARE
    --��ø���̺��� �ڷ����� ������ �� ���� ����
    TYPE ntType IS
        TABLE OF VARCHAR2(30);
    nt_array ntType;
BEGIN
    --�����ڸ� ���� ���� �Ҵ�. �̶� ũ�Ⱑ 4�� ��ø���̺��� ������.
    nt_array := ntType('ù��°', '�ι�°', '����°', '');
    
    --4��° �������� ���������� �Ҵ� �� ��µȴ�.
    
    DBMS_OUTPUT.PUT_LINE(nt_array(1));
    DBMS_OUTPUT.PUT_LINE(nt_array(2));
    DBMS_OUTPUT.PUT_LINE(nt_array(3));
    nt_array(4) := '�׹�°�� �Ҵ�';
    
    DBMS_OUTPUT.PUT_LINE(nt_array(4));
    /*
    �����߻�
    ORA-06533: ÷�ڰ� ������ �Ѿ����ϴ� 
    - �� �ڵ����� �迭�� Ȯ������� �ʴ´�.
    */
    --nt_array(5) := '�ټ���°�� �Ҵ� �ǳ�???';
    
    /*
    ũ�⸦ Ȯ���� ���� �����ڸ� ���� �迭�� ũ�⸦ �������� Ȯ���Ѵ�.
    */
    nt_array := ntType('1a', '2b', '3c', '4d', '5e', '6f', '7g');
    
    FOR i IN 1 .. 7 LOOP
        DBMS_OUTPUT.PUT_LINE(nt_array(i));
    END LOOP;
END;
/

--����24] ��ø���̺�(Nested Table) 
--�ó�����] ��ø���̺�� for���� ���� ������̺��� ��ü ���ڵ��� �����ȣ�� �̸��� ����Ͻÿ�.
DECLARE
    /* ��ø���̺� �ڷ��� ���� �� ���� ���� : ������̺��� ��ü�÷��� �����ϴ�
        ���������� ���������Ƿ� �ϳ��� ���ڵ�(Row)�� ������ �� �ִ�
        Ÿ���� �ȴ�. */
    TYPE ntType IS
        TABLE OF employees%rowtype;
    nt_array ntType;
BEGIN
    --ũ�⸦ �������� ���� ���·� �����ڸ� ���� ��ø ���̺��� �ʱ�ȭ
    nt_array := ntType();
    /* ������̺��� ���ڵ� �� ��ŭ �ݺ��ϸ鼭 ���ڵ带 �ϳ��� �������ش�. */
    FOR rec IN (SELECT * FROM employees) LOOP
        --��ø���̺��� ������ �κ��� Ȯ���ϸ鼭 null�� ����(EXTEND �޼���)
        nt_array.EXTEND;
        --������ �ε��� ���� ���� �� ��������� ���(LAST �޼���)
        nt_array(nt_array.LAST) := rec;
    END LOOP;
    
    --��ø���̺��� ù��° �ε���(FIRST �޼���)���� ������ �ε���(LAST �޼���)���� ���
    FOR i IN nt_array.FIRST .. nt_array.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(nt_array(i).employee_id ||
            '>' || nt_array(i).first_name);
    END LOOP;
END;
/
