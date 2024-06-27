/**
���ϸ� : Or01SelectBasic.sql
ó������ �����غ��� ���Ǿ�(SQL�� Ȥ�� Query��)
�����ڵ� ���̿����� '����'�̶�� ǥ���ϱ⵵ �Ѵ�.
���� : select, where, order by �� ���� �⺻���� DQL�� ����غ���
**/

/*
SQL Developer �ּ� ����ϱ�
    �������ּ�: �ں��� �����ϴ�.
    ���δ����ּ�: -- ���๮��. ������ 2���� �������� ����Ѵ�.
*/

--select��: ���̺� ����� ���ڵ带 ��ȸ�ϴ� SQL������ DQL���� �ش��Ѵ�.
/*
����]
    select �÷�1, �÷�2, ... Ȥ�� *
    from ���̺��
    where ����1 and ����2 or ����3
    order by �������÷��� asc(��������), desc(��������);
*/
--������̺� ����� ��� ���ڵ带 ������� ��� Į���� ��ȸ�Ѵ�.
select * from employees;
--�������� ��ҹ��ڸ� �������� �ʴ´�.
SELECT * FROM employees;

/*
�÷����� �����ؼ� ��ȸ�ϰ� ���� �÷��� ��ȸ�ϱ�
=> �����ȣ, �̸�, �̸���, �μ���ȣ�� ��ȸ�Ͻÿ�.
*/
select employee_id, first_name, last_name, email, department_id
from employees; --�ϳ��� �������� ������ ;�� �ݵ�� ����ؾ��Ѵ�.

/* ���̺��� ������ �÷��� �ڷ��� �� ũ�⸦ ������ش�. �� ���̺��� ��Ű��(����)��
�� �� �ִ�. */
desc employees;

/*
�÷��� ������(number)�� ��� ��������� �����ϴ�.
=> $100 �λ�� ������ �޿��� ��ȸ�Ͻÿ�.
*/
select employee_id, first_name, salary, salary + 100 from employees;

--number(����) Ÿ���� �÷������� ��������� �� �� �ִ�.
select employee_id, first_name, salary, salary + commission_pct
from employees;

/*
AS(�˸��ƽ�): ���̺� Ȥ�� �÷��� ��Ī(����)�� �ο��� �� ����Ѵ�.
    ���� ���ϴ� �̸�(����, �ѱ�)���� ������ �� ����� �� �ִ�.
    Ȱ��] �޿� + �������� => SalComn�� ���� ���·� ��Ī�� �ο��Ѵ�.
*/
--��Ī�� �ѱ۷� ����� �� �ִ�.
select employee_id, first_name, salary, salary + 100 as "�޿�100������"
from employees;

--������ ��Ī�� �������� ����ϴ� ���� �����Ѵ�.
select employee_id, first_name, salary, commission_pct,
salary + (salary * commission_pct) as "Salcomm"
from employees;

--as�� ������ �� �ִ�.
select employee_id "�����ȣ", first_name "�̸�", last_name "��"
from employees where first_name = 'William';
/*����Ŭ�� �⺻������ ��ҹ��ڸ� �������� �ʴ´�. �����(�Ķ��� Ű����)�� ��� 
��ҹ��� ���о��� ����� �� �ִ�.
*/
SELECT employee_id "�����ȣ", first_name "�̸�", last_name "��"
FROM employees WHERE first_name = 'William';

/*
��, ���ڵ��� ��� ��ҹ��ڸ� �����Ѵ�. ���� �Ʒ� SQL���� �����ϸ�
�ƹ��� ����� ������� �ʴ´�.
*/
select employee_id "�����ȣ", first_name "�̸�", last_name "��"
from employees where first_name = 'william';

/*
where���� �̿��ؼ� ���ǿ� �´� ���ڵ� �����ϱ�
=> last_name�� Smith�� ���ڵ带 �����Ͻÿ�.
*/
select * from employees where last_name = 'Smith';

/*
where���� 2�� �̻��� ������ �ʿ��� �� and Ȥ�� or�� ����� �� �ִ�.
=> last_name�� Smith�̸鼭 �޿��� 8000�� ����� �����Ͻÿ�. 
*/
-- �÷��� �������̸� single quotation���� ���ΰ�, ���ڸ� �����Ѵ�.
select * from employees where last_name = 'Smith' and salary = 8000;
-- �������� �̱��� ������ �� ����. ���� ������ �߻��Ѵ�.
select * from employees where last_name = Smith and salary = 8000;
-- �������� ��� single quotation ������ �⺻������ ��� �����ϴ�.
select * from employees where last_name = 'Smith' and salary = '8000';

/*
�񱳿����ڸ� ���� ������ �ۼ�
: �̻�, ���Ͽ� ���� ���ǿ� >, <=�� ���� �񱳿����ڸ� ����� �� �ִ�.
��¥�� ��� ����, ���Ŀ� ���� ���ǵ� �����ϴ�.
*/
-- �޿��� 5000 �̸��� ����� ������ �����Ͻÿ�.
select * from employees where salary < 5000;
-- �Ի����� 04�� 1�� 1�� ������ ����� ������ �����Ͻÿ�.
select * from employees where hire_date >= '04/01/01';

/*
in �λ���
: or �����ڿ� ���� �ϳ��� �÷��� �������� ������ ������ �ɰ���� �� ���
=> �޿��� 4200, 6400, 8000�� ����� ������ �����Ͻÿ�.
*/
--���1: or�� ����Ѵ�. �̶� �÷����� �ݺ������� ����ؾ� �ϹǷ� �����ϴ�.
select * from employees where salary = 4200 or salary = 6400 or salary = 8000;
--���2: in�� ����ϸ� �÷����� �ѹ��� ����ϸ� �ǹǷ� ���ϴ�.
select * from employees where salary in (4200, 6400, 8000);

/*
not ������
: �ش� ������ �ƴ� ���ڵ带 �����Ѵ�.
=> �μ���ȣ�� 50�� �ƴ� ��������� �����ϴ� SQL���� �ۼ��Ͻÿ�.
*/
select * from employees where department_id<>50;
select * from employees where not (department_id = 50);
select * from employees where department_id != 50;

/*
between and ������
: �÷��� ������ ���� �˻��� �� ����Ѵ�.
=> �޿��� 4000~8000 ������ ����� �����Ͻÿ�.
*/
select * from employees where salary >= 4000 and salary <= 8000;
select * from employees where salary between 4000 and 8000;

/*
distinct ������
: �÷����� �ߺ��Ǵ� ���ڵ带 ������ �� ����Ѵ�.
Ư�� �������� select���� �� �ϳ��� �÷����� �ߺ��Ǵ� ���� �ִ� ���
�ߺ����� ������ �� ����� ����� �� �ִ�.
=> ������ ���̵� �ߺ��� ������ �� �����Ͻÿ�.
*/
select job_id from employees;
select distinct job_id from employees;

/*
like �����ڿ� ���ϵ�ī��
: Ư�� Ű���带 ���� ���ڿ��� �˻��� �� ����Ѵ�.
����] �÷��� like '%Ű����%'
    ���ϵ�ī�� ����
    % : ��� ���� Ȥ�� ���ڿ��� ��ü
    ex) D�� �����ϴ� �ܾ�: D% => Da, Dae, Daewoo
        Z�� ������ �ܾ�: %Z => aZ, abxZ
        C�� ���ԵǴ� �ܾ�: %C% => aCb, abCde, Vitamin-C
    _ : ����ٴ� �ϳ��� ���ڸ� ��ü
    ex) D�� �����ϴ� 3������ �ܾ�: D__ => Dab, Ddd, Dxy
        A�� �߰��� ���� 3������ �ܾ�: _A_ => aAa, xAy
*/
--first_name�� 'D'�� �����ϴ� ������ �����Ͻÿ�.
select * from employees where first_name like 'D%';
--first_name�� ����° ���ڰ� 'a'�� ������ �����Ͻÿ�.
select * from employees where first_name like '__a%';
--last_name���� 'y'�� ������ ������ �����Ͻÿ�.
select * from employees where last_name like '%y';
--��ȭ��ȣ�� 1344�� ���Ե� ���� ��ü�� �����Ͻÿ�.
select * from employees where phone_number like '%1344%';

/*
���ڵ� �����ϱ�(Sorting)
    �������� ����: order by �÷��� asc(��������)
    �������� ����: order by �÷��� desc
    2�� �̻��� �÷����� �����ؾ� �� ��� �޸��� �����ؼ� �����Ѵ�.
    �� �̶� ���� �Է��� �÷����� ���ĵ� ���¿��� �ι�° �÷��� ���ĵȴ�.
*/
/*
�ó�����] ������� ���̺��� �޿��� ���� �������� ���� ������ ����ǵ���
�����Ͽ� �����Ͻÿ�.
����� �÷�: �̸�, �޿�, �̸���, ��ȭ��ȣ
*/
select first_name, salary, email, phone_number from employees
order by salary asc;
select first_name, salary, email, phone_number from employees
order by salary; -- ���������� ��� asc�� defalut�̱� ������ ���� ����

/*
�ó�����] �μ���ȣ�� ������������ ������ �� �ش� �μ����� ���� �޿��� �޴�
������ ���� ��µǵ��� SQL���� �ۼ��Ͻÿ�.
����� �÷�: �����ȣ, �̸�, ��, �޿�, �μ���ȣ
*/
select employee_id, first_name, salary, department_id from employees
order by department_id desc, salary asc;

/*
is null Ȥ�� is not null
: ���� null �̰ų� null�� �ƴ� ���ڵ� �����ϱ�.
�÷��� null���� ����ϴ� ��� ���� �Է����� ������ null���� �Ǵµ�
�̸� ������� select�ؾ��� �� ����Ѵ�.
*/
-- ���ʽ����� ���� ����� ��ȸ�Ͻÿ�.
select * from employees where commission_pct is null;
-- ��������̸鼭 �޿��� 8000 �̻��� ����� ��ȸ�Ͻÿ�(is not null ���).
select * from employees where salary >= 8000
and commission_pct is not null;
-- (is not null ��� ����)
select * from employees where salary >= 8000
and job_id like 'SA%';

// select�� �⺻
/*
1. ���� �����ڸ� �̿��Ͽ� ��� ����� ���ؼ� $300�� �޿��λ��� ������� 
�̸�, �޿�, �λ�� �޿��� ����Ͻÿ�.
*/
select ename, sal, sal + 300 from emp;
/*
2. ����� �̸�, �޿�, ������ ������ �����ͺ��� ���������� ����Ͻÿ�.
������ ���޿� 12�� ������ $100�� ���ؼ� ����Ͻÿ�.
*/
select ename, sal, sal * 12 + 100 "annualSal" from emp
order by sal desc;
/*
3. �޿���  2000�� �Ѵ� ����� �̸��� �޿��� ������������ �����Ͽ� ����Ͻÿ�
*/
select
    ename, sal, sal * 12 + 100 "annualSal" from emp 
where sal > 2000 order by ename, sal desc;
/*
4. �����ȣ��  7782�� ����� �̸��� �μ���ȣ�� ����Ͻÿ�.
*/
select ename, deptno from emp where empno = 7782;
/*
5. �޿��� 2000���� 3000���̿� ���Ե��� �ʴ� ����� �̸��� �޿��� ����Ͻÿ�.
*/
select ename, sal from emp where not (sal between 2000 and 3000);
/*
6. �Ի����� 81��2��20�� ���� 81��5��1�� ������ ����� �̸�, ������, �Ի����� ����Ͻÿ�.
*/
select ename, job, hiredate from emp where hiredate 
between '81/02/20' and '81/05/01';
/*
7. �μ���ȣ�� 20 �� 30�� ���� ����� �̸��� �μ���ȣ�� ����ϵ�
�̸��� ����(��������)���� ����Ͻÿ�
*/
select
    ename, deptno from emp where deptno = 20 or deptno = 30
order by ename desc;
-- or ������ in���� ��ü
select
    ename, deptno from emp where deptno in(20, 30)
order by ename desc;

/*
8. ����� �޿��� 2000���� 3000���̿� ���Եǰ� �μ���ȣ�� 20 �Ǵ� 30�� ����� 
�̸�, �޿��� �μ���ȣ�� ����ϵ� �̸���(��������)���� ����Ͻÿ�
*/
select ename, sal, deptno from emp
where (sal between 2000 and 3000)
and (deptno = 20 or deptno = 30) order by ename;
/*
9. 1981�⵵�� �Ի��� ����� �̸��� �Ի����� ����Ͻÿ�. (like �����ڿ� ���ϵ�ī�� ���)
*/
select ename, hiredate from emp where hiredate like '%81%';
/*
10. �����ڰ� ���� ����� �̸��� �������� ����Ͻÿ�. 
*/
select ename, job from emp where comm is null;
/*
11. Ŀ�̼��� ������ �ִ� �ڰ��� �Ǵ� ����� �̸�, �޿�, Ŀ�̼��� ����ϵ�
�޿� �� Ŀ�̼��� �������� ������������ �����Ͽ� ����Ͻÿ�.
*/
select ename, sal, comm from emp where comm is not null
    order by sal desc, comm desc;
/*
12. �̸��� ����° ���ڰ� R�� ����� �̸��� ǥ���Ͻÿ�.
*/
select ename from emp where ename like '__R%';
/*
13. �̸��� A�� E�� ��� �����ϰ� �ִ� ����� �̸��� ǥ���Ͻÿ�.
*/
select ename from emp where ename like '%A%' and ename like '%E%';

--���� �Ʒ��� ���� ������ �ۼ��ϸ� A�� ���� ������ E�� �ִ� �̸��� �˻��Ѵ�.
select ename from emp where ename lika '%E%A';
-- E�� ����, A�� �ڿ� �ִ� �̸��� �˻��Ѵ�.
select ename from emp where ename lika '%A%E';
-- ���� �켱������ ����� �ǹǷ� ����� �˻��� ���� ���� �� �ִ�.

/*
14. �������� �繫��(CLERK) �Ǵ� �������(SALESMAN)�̸鼭
�޿��� $1600, $950, $1300 �� �ƴ� ����� �̸�, ������, �޿��� ����Ͻÿ�. 
*/
select ename, job, sal from emp where (job = 'CLERK' or job = 'SALESMAN')
and sal<>1600 or sal<>950 or sal<>1300;
/*
15. Ŀ�̼��� $500 �̻��� ����� �̸��� �޿� �� Ŀ�̼��� ����Ͻÿ�. 
*/
select ename, sal, comm from emp where comm >= 500;