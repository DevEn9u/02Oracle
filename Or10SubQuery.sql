/**********
���ϸ� : Or10SubQuery.sql
��������
���� : ������ �ȿ� �� �ٸ� �������� ���� ���·� select��
**********/

/*
������ ��������
����] SELECT * from ���̺�� where �÷� = (
            SELECT �÷� from ���̺�� where ����
        );
    �� ��ȣ ���� ���������� �ݵ�� �ϳ��� ����� �����ؾ� �Ѵ�.
*/
/*
�ó�����] ������̺��� ��ü����� ��ձ޿����� ���� �޿��� �޴� �������
        �����Ͽ� ����Ͻÿ�.
    ����׸� : �����ȣ, �̸�, �̸���, ����ó, �޿�
*/
--1. ��� �޿� ���ϱ� (��� : 6462)
SELECT round(avg(salary)) from employees;
--2. �տ��� ���� ��ձ޿��� ���� ��ձ޿����� �� �޴� ��� ���� (���: 56��)
select * from employees where salary < 6462;
/* 1, 2���� �Ʒ��� ���� �������� �ۼ��ϸ� ������ �߻��Ѵ�. ���ƻ�
�´� ��ó�� �������� �׷��Լ��� �����࿡ ������ �߸��� �������̴�. */
select * from employees where salary < round(avg(salary));
--���������� �ۼ��ϱ�
select * from employees where salary <(
    select round(avg(salary)) from employees
);

/*
�ó�����] ��ü ����� �޿��� ���� ���� ����� �̸��� �޿��� ����ϴ�
        ������������ �ۼ��Ͻÿ�.
    ����׸�: �̸�, ��, �̸���, �޿�
*/
--1. �ּұ޿��� Ȯ��(���: 2100)
select min(salary) from employees;
--2-1. �׷��Լ��� �����࿡ ��������Ƿ� �����߻���
select first_name, last_name, email, salary from employees
    where salary = min(salary);
--2-2. 1���� Ȯ���� �ּұ޿��� min(salry) ��ġ�� �ִ´�.
select first_name, last_name, email, salary from employees
    where salary = 2100;
--4. 2���� �������� ���ļ� ���������� �ۼ�
select first_name, last_name, email, salary
    from employees where salary = (
        select min(salary) from employees
    );

/*
�ó�����] ��ձ޿����� ���� �޿��� �޴� ������� ����� ��ȸ�� �� �ִ�
������������ �ۼ��Ͻÿ�.
��³��� : �̸�, ��, ��������, �޿�
�� ���������� jobs ���̺� �����Ƿ� join�ؾ� �Ѵ�.
*/
--��ձ޿� Ȯ���ϱ�
SELECT round(avg(salary)) from employees;
--jobs ���̺��� inner join �Ͽ� job_title�� ����
SELECT 
    first_name, last_name, job_title, salary
FROM employees INNER JOIN jobs using(job_id)
WHERE salary > 6462;
--���������� �ۼ�
SELECT 
    first_name, last_name, job_title, salary
FROM employees INNER JOIN jobs using(job_id)
WHERE salary > (SELECT round(avg(salary)) from employees);

/*
������ ��������
����] SELECT * from ���̺�� where �÷� in (
            SELECT �÷� from ���̺�� where ����
        );
    �� ��ȣ ���� ���������� 2�� �̻��� ����� �����ؾ� �Ѵ�.
    �� ��쿡 ���� 1���� ����� �������� ������ �߻������� �ʴ´�.
*/

/*
�ó�����] ��������� ���� ���� �޿��� �޴� ����� ����� ��ȸ�Ͻÿ�.
    ��¸��: ������̵�, �̸�, ���������̵�, �޿�
*/
--1. ��������� ���� ���� �޿��� Ȯ��
SELECT
    job_id, MAX(salary)
from employees GROUP BY job_id;
--2. �տ��� ���� ����� �������� �ܼ��� or �������� ������ �ۼ�
SELECT employee_id, first_name, last_name, job_id, salary
FROM employees WHERE
    (job_id = 'AD_PRES' AND salary = 24000) OR
    (job_id = 'AD_VP' AND salary = 17000) OR
    (job_id = 'IT_PROG' AND salary = 9000) OR
    (job_id = 'FI_MGR' AND salary = 12008);
/* 1�� �������� 19���� ����� ����Ǿ����� ������ ���� ����ϴ� ����
�����ϹǷ� 4�������� ����� Ȯ���غ��Ҵ�. */
--3. 2���� �÷��� �̿��ؾ� �ϹǷ� �����װ� �������� in���� �����Ѵ�.
SELECT employee_id, first_name, last_name, job_id, salary
FROM employees WHERE
    (job_id, salary) IN (
        SELECT
            job_id, MAX(salary)
        from employees GROUP BY job_id
);
    
/*
������ ������: any
    ���������� �������� ���������� �˻������ �ϳ� �̻� ��ġ�ϸ�
    ���� �Ǵ� ������. �� ���� �ϳ��� �����ϸ� �ش� ���ڵ带 �����Ѵ�.
*/
/*
�ó�����] ��ü ����߿��� �μ���ȣ�� 20�� ������� �޿����� ���� �޿���
    �޴� �������� �����ϴ� ������������ �ۼ��Ͻÿ�. �� �� �� �ϳ���
    �����ϴ��� �����Ͻÿ�.
*/
--20�� �μ��� �޿��� Ȯ��(���: 6000, 13000)
SELECT first_name, salary FROM employees where department_id = 20;
--�� ����� �ܼ��� or������ �ۼ�
SELECT first_name, salary FROM employees
where salary > 13000 or salary > 6000;
/* �� �� �ϳ��� �����ϸ� �ǹǷ� ������ ������ any�� �̿��ؼ� ����������
����� �ȴ�. �� 6000 Ȥ�� 13000���� ū �������� �������� ����ȴ�. */
SELECT first_name, salary FROM employees
where salary > any (
    SELECT salary FROM employees where department_id = 20
    );
--��������� 6000���� ũ�� ���ǿ� �����Ѵ�. (���: 55��)

/*
������ ������: all
    ���������� �������� ���������� �˻������ ��� ��ġ�ؾ�
    ���ڵ带 �����Ѵ�.
*/
/*
�ó�����] ��ü ����߿��� �μ���ȣ�� 20�� ������� �޿����� ���� �޿���
    �޴� �������� �����ϴ� ������������ �ۼ��Ͻÿ�. �� �� ������ ��� �����ϴ�
    ���ڵ常 �����Ͻÿ�.
*/
SELECT first_name, salary FROM employees
where salary > 13000 or salary > 6000;
/*
    6000 �̻��̰� ���ÿ� 13000 �̻��̾�� �ϹǷ� ��������� 13000 �̻���
    ���ڵ常 �����Ѵ�. (���: 5��)
*/
SELECT first_name, salary FROM employees
where salary > all (
    SELECT salary FROM employees where department_id = 20
    );

/*
rownum : ���̺��� ���ڵ带 ��ȸ�� ������� ������ �ο��Ǵ� ������
    �÷��� ���Ѵ�. �ش� �÷��� ��� ���̺� �������� �����Ѵ�.
*/
--��� ������ �������� �����ϴ� ���̺�
select * from dual;
/* ���ľ��� ��� ���ڵ带 �����ͼ� ���ڵ忡 rownum�� �ο��Ѵ�.
�� ��� rownum�� ������� ��µȴ�. */
select employee_id, first_name, rownum from employees;
/* �̸��̳� �����ȣ�� ���� �����ϸ� rownum�� 
���� �����⵵ �ϰ� ������� �����⵵ �Ѵ�. */
select employee_id, first_name, rownum from employees order by first_name;
select employee_id, first_name, rownum from employees order by employee_id;
/*
rownum�� �츮�� ������ ������� ��ο��ϱ� ���� ���������� ����Ѵ�.
from�� �ڿ��� ���� ���̺��� �����µ�, �Ʒ��� �������������� employees ���̺���
��ü ���ڵ带 ������� �ϵ� �̸��� ������ ���·� ���ڵ带 �������� �ǹǷ�
���̺��� ��ü�� �� �ְ� �ȴ�.
���� ���ĵ� ���¿��� rownum�� ���� �������� ������ �ο��ȴ�.
*/
SELECT first_name, ROWNUM FROM
    (SELECT * FROM employees ORDER BY first_name ASC);

/*
�̸��� �������� ���ĵ� ���ڵ忡 rownum�� �ο��Ͽ����Ƿ� where����
�Ʒ��� ���� ������ ���� ������ ���� select�� �� �ִ�.
*/
SELECT * FROM
    (SELECT tb.*, ROWNUM rNum FROM
       (SELECT * FROM employees ORDER BY first_name ASC) tb
    )
--where rNum >= 1 and rNum <= 10;
--where rNum >= 11 and rNum <= 20;
where rNum between 21 and 30;

-----------------------------------------------------
--���� 24.06.28

/*
1.�����ȣ�� 7782�� ����� ��� ������ ���� ����� ǥ��(����̸��� ��� ����)�Ͻÿ�.
*/
SELECT * FROM emp where empno = 7782;
SELECT * FROM emp where job = 'MANAGER';
-- ���������� ����
SELECT * FROM emp WHERE job = (
    SELECT job FROM emp WHERE empno = 7782
);

--02.�����ȣ�� 7499�� ������� �޿��� ���� ����� ǥ��(����̸��� ��� ����)�Ͻÿ�.
SELECT * from emp WHERE sal > (
    SELECT sal FROM emp WHERE empno = 7499
);
--03.�ּ� �޿��� �޴� ����� �̸�, ��� ���� �� �޿��� ǥ���Ͻÿ�(�׷��Լ� ���).
SELECT empno, ename, job, sal FROM emp WHERE sal = (
    SELECT min(sal) FROM emp
);
--����� ����
--�޿��� �ּڰ� Ȯ��
SELECT MIN(sal) FROM emp; -- 800
--�޿� 800�� �޴� ����
SELECT * FROM emp WHERE sal = 800;
SELECT empno, ename, job, sal FROM emp WHERE sal = (SELECT MIN(sal) FROM emp);
--04.��� �޿��� ���� ���� ����(job)�� ��� �޿��� ǥ���Ͻÿ�.
SELECT job, AVG(sal) FROM emp WHERE sal IN (
    SELECT MIN(AVG(sal)) FROM emp group by job
);

--����� ����
--���޺� ��ձ޿� ����
SELECT job, AVG(sal) FROM emp GROUP BY job;
/* �տ��� ���� ��� �޿� ���ڵ忡�� ���� ���� ���� ã�� ���� min()�Լ���
�ѹ� �� ����Ѵ�. �� ��� job�÷��� �����ؾ� ������ �߻����� �ʴ´�. */
SELECT job, MIN(AVG(sal)) FROM emp GROUP BY job; -- �����߻�(job �÷��� �ָ���)
SELECT MIN(AVG(sal)) FROM emp GROUP BY job; -- �������. ��ձ޿��� �ּڰ��� ������.
/*
��� �޿��� ���������� �����ϴ� �÷��� �ƴϹǷ� WHERE������ ����� �� ����
HAVING���� ����ؾ� �Ѵ�. ��, ��ձ޿��� 1016�� ������ ����ϴ� �������
���������� �ۼ��ؾ� �Ѵ�.
*/
SELECT job, AVG(sal)
FROM emp
GROUP BY job
HAVING AVG(sal) = (
    SELECT MIN(AVG(sal))
    FROM emp
    GROUP BY job
);

--05.���μ��� �ּ� �޿��� �޴� ����� �̸�, �޿�, �μ���ȣ�� ǥ���Ͻÿ�.
SELECT ename, sal, deptno from emp WHERE
    (deptno, sal) IN (
        SELECT
            deptno, min(sal)
        from emp GROUP BY deptno
);

--����Թ���
--�׷��� ���� �ּұ޿� Ȯ��
SELECT deptno, MIN(sal) FROM emp GROUP BY deptno;
--�տ��� ���� ����� �Ϲ� ���������� �ۼ�
SELECT ename, sal, deptno FROM emp WHERE
    (deptno = 20 AND sal = 800) or
    (deptno = 30 AND sal = 950) or
    (deptno = 10 AND sal = 1300);
--������ �������� �����ڸ� ���� ������ �ۼ�
SELECT ename, sal, deptno FROM emp
WHERE (deptno, sal) IN (
    SELECT deptno, MIN(sal) FROM emp GROUP BY deptno);
    
/*
06.��� ������ �м���(ANALYST)�� ������� �޿��� �����鼭 
������ �м���(ANALYST)�� �ƴ� ������� ǥ��(�����ȣ, �̸�, ������, �޿�)�Ͻÿ�.
*/
SELECT empno, ename, job, sal FROM emp WHERE sal < (
    SELECT sal FROM emp WHERE job = 'ANALYST')
    AND job<>'ANALYST';
--����� ����
--��� ������ ���� �޿� Ȯ�� : 3000
SELECT * FROM emp WHERE job = 'ANALYST';
--������ ������ �Ϲ����������� �ۼ�
SELECT * FROM emp WHERE sal < 3000 AND job<>'ANALYST';
--�������������� �ۼ�
SELECT * FROM emp WHERE sal <(SELECT sal FROM emp WHERE job = 'ANALYST')
    AND job<>'ANALYST';
/*
07.�̸��� K�� ���Ե� ����� ���� �μ����� ���ϴ� 
����� �����ȣ�� �̸��� ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ�.
*/
SELECT * FROM emp WHERE deptno in (
    SELECT deptno from emp where ename like '%K%'
);

--����� ����
--'K'�� ���Ե� ����� 10��, 30�� �μ����� �ٹ��ϴ� ���� Ȯ��
SELECT * FROM emp WHERE ename LIKE '%K%';
--10 Ȥ�� 30�� �μ����� �ٹ��ϴ� ����� ���
SELECT * FROM emp WHERE deptno IN (10, 30);
--�������������� �ۼ�
/*
    or������ in���� ǥ���� �� �ִ�. ���� ������������ ������ ��������
    in�� ����Ѵ�. 2�� �̻��� ����� or�� �����ؼ� ����ϴ� ����� �����Ѵ�.
*/
SELECT * FROM emp WHERE deptno in (
    SELECT deptno FROM emp WHERE ename LIKE '%K%'
);

--08.�μ� ��ġ�� DALLAS�� ����� �̸��� �μ���ȣ �� ��� ������ ǥ���Ͻÿ�.
SELECT empno, ename, sal FROM emp INNER JOIN dept USING (deptno)
WHERE loc = 'DALLAS';

--����� ����
--�μ���ȣ�� 20���� Ȯ��
SELECT * FROM dept WHERE loc = 'DALLAS';
--20�� �μ����� �ٹ��ϴ� ���
SELECT * FROM emp WHERE deptno = 20;
--�������������� �ۼ�
SELECT empno, ename, sal FROM emp 
WHERE deptno = (SELECT deptno FROM dept WHERE loc = 'DALLAS');
/*
09.��� �޿� ���� ���� �޿��� �ް� �̸��� K�� ���Ե� ����� ���� �μ����� 
�ٹ��ϴ� ����� �����ȣ, �̸�, �޿��� ǥ���Ͻÿ�.
*/
--��ձ޿����ٸ��� �޿��� �޴´�.
SELECT * FROM emp WHERE sal > (
    SELECT AVG(sal) FROM emp
);
--�̸��� k�����ԵǾ��ִ�.
SELECT deptno FROM emp WHERE ename LIKE '%K%'; 

SELECT empno, ename, sal FROM emp WHERE sal > ALL (SELECT AVG(sal) FROM emp)
    AND deptno IN (
    SELECT deptno FROM emp WHERE ename LIKE '%K%'
);

--����� ����
--��ձ޿� Ȯ�� : 2077
SELECT AVG(sal) FROM emp;
--�޿��� 2077 �̻��̰� �̸��� 'K'�� ���Ե� ��� : 10, 30
SELECT * FROM emp WHERE sal > 2077 AND ename LIKE '%K%';
--�� 2���� ������ �ܼ��ϰ� �ۼ��ϸ�..
SELECT * FROM emp WHERE deptno IN (10, 30);
--�������������� �ۼ�
SELECT empno, ename, sal FROM emp WHERE deptno IN (
    SELECT deptno FROM emp WHERE sal > (SELECT AVG(sal) FROM emp)
    AND ename LIKE '%K%'
);

/* �� ���� ��� �޿����� ���� �޿��� �ް�, �̸��� K�� ���Ե� ����� �����ȣ, �̸�,
�޿��� ǥ����.

SELECT empno, ename, sal FROM emp WHERE sal > ALL (
    SELECT AVG(sal) from emp) AND
        deptno IN (
            SELECT deptno FROM emp WHERE ename LIKE '%K%'
);
*/

--10.��� ������ MANAGER�� ����� �Ҽӵ� �μ��� ������ �μ��� ����� ǥ���Ͻÿ�.
SELECT * FROM emp WHERE deptno IN (
    SELECT deptno FROM emp WHERE job = 'MANAGER'
);

--����� ����
--10, 20, 30�� �μ����� Ȯ��
SELECT * FROM emp WHERE job = 'MANAGER';
SELECT * FROM emp WHERE deptno IN (
    SELECT deptno FROM emp WHERE job = 'MANAGER'
);

/*
11.BLAKE�� ������ �μ��� ���� ����� �̸��� �Ի����� 
ǥ���ϴ� ���Ǹ� �ۼ��Ͻÿ�(��. BLAKE�� ����)
*/
SELECT ename, hiredate FROM emp WHERE deptno IN (
    SELECT deptno FROM emp WHERE ename = 'BLAKE')
    AND NOT ename = 'BLAKE';

--����� ����
--30�� �μ�Ȯ��
SELECT * FROM emp WHERE ename = 'BLAKE';

SELECT ename, hiredate FROM emp WHERE ename<>'BLAKE' AND deptno = (
    SELECT deptno FROM emp WHERE ename = 'BLAKE'
);