/*********
���ϸ� : Or09Join.SQL
���̺� ����
���� : �ΰ� �̻��� ���̺��� ���ÿ� �����Ͽ� �����͸� �����;� �� ��
����ϴ� SQL��
*********/

--HR�������� �����մϴ�.

/*
1] inner join(���� ����)
- ���� ���� ����ϴ� ���ι����� ���̺��� ���������� ��� �����ϴ�
���ڵ带 �˻��Ҷ� ����Ѵ�.
- �Ϲ������� �⺻Ű(Primary key)�� �ܷ�Ű(foreign key)�� ����Ͽ�
join�ϴ� ��찡 ��κ��̴�.
- �� ���� ���̺� ������ �̸��� �÷��� �����ϸ� "���̺��.�÷���"
���·� ����ؾ� �Ѵ�.
- ���̺��� ��Ī�� ����ϸ� "��Ī.�÷���" ���·� ����� �� �ִ�.

����1(ǥ�ع��)
    select �÷�1, �÷�2
    from ���̺�1 inner join ���̺�2
        on ���̺�1.�⺻Ű�÷� = ���̺�2.�ܷ�Ű�÷�
    where ����1 and ����2 ...;
*/

/*
�ó�����] ������̺�� �μ����̺��� �����Ͽ� �� ������ � �μ�����
    �ٹ��ϴ��� ����Ͻÿ�. ��, ǥ�ع������ �ۼ��Ͻÿ�.
    ��°��: ������̵�, �̸�1, �̸�2, �̸���, �μ���ȣ, �μ���
*/
-- �Ʒ� �������� ���� �߻�
select
    employee_id, first_name, email,
    department_id, department_name
from employees inner join departments
    on employees.department_id = departments.department_id;
/*
ù��° �������� �����ϸ� ���� ���ǰ� �ָ��ϴٴ� ������ �߼��Ѵ�.
�μ���ȣ�� ���ϴ� department_id�� ���� ���̺� ��ο� �����ϹǷ�
� ���̺��� ������ �����ؾ����� ����ؾ��Ѵ�.
*/
select
    employee_id, first_name, email,
    employees.department_id, department_name
from employees inner join departments
    on employees.department_id = departments.department_id;
/* ������������ �Ҽӵ� �μ��� ���� 1���� ������ ������ 106����
���ڵ尡 ����ȴ�. ��, inner join�� ������ ���̺� ���� ��� �����ϴ�
���ڵ尡 ����ȴ�.*/

-- AS(�˸��ƽ�)�� ���� ���̺� ��Ī�� �ο��ϸ� �����ϰ� �������� �ۼ��� �� �ִ�.
select
    employee_id, first_name, email,
    Emp.department_id, department_name
from employees "Emp" inner join departments "Dep"
    on Emp.department_id = Dep.department_id;

--3�� �̻��� ���̺� �����ϱ�
/*
�ó�����] seattle(�þ�Ʋ)�� ��ġ�� �μ����� �ٹ��ϴ� ������ ������
    ����ϴ� �������� �ۼ��Ͻÿ�. �� ǥ�ع������ �ۼ��Ͻÿ�. 
    ��°��] ����̸�, �̸���, �μ����̵�, �μ���, ���������̵�, 
        ��������, �ٹ�����
    �� ��°���� ���� ���̺� �����Ѵ�. 
    ������̺� : ����̸�, �̸���, �μ����̵�, ���������̵�
    �μ����̺� : �μ����̵�(����), �μ���, �����Ϸù�ȣ(����)
    ���������̺� : ��������, ���������̵�(����)
    �������̺� : �ٹ��μ�, �����Ϸù�ȣ(����)
*/
-- 1. locations ���̺��� ���� Seattle�� ��ġ�� ���ڵ��� �Ϸù�ȣ�� �����Ѵ�.
select * from locations where city = initcap('seattle');
-- location_id�� 1700�� ���� Ȯ��

-- 2. location_id�� ���� �μ����̺��� ���ڵ带 Ȯ���Ѵ�.
select * from departments where location_id = 1700;
-- �������� 21���� ���� Ȯ�� 

-- 3. location_id�� ���� ������̺��� ���ڵ带 Ȯ���Ѵ�.
select * from employees where department_id = 10; -- 1��
select * from employees where department_id = 30; -- 6��

-- 4. ��������(job_id) Ȯ���ϱ�
select * from jobs where job_id = 'PU_MAN'; --Purchasing Manager
select * from jobs where job_id = 'PU_CLERK';--Purchasing Clerk

/*
5. join ������ �ۼ�
���� ���̺� ���ÿ� �����ϴ� �÷��� ��쿡��
�ݵ�� ���̺���̳� ��Ī�� ����ؾ� �Ѵ�.
*/
select 
    first_name, last_name, email,
    departments.department_id, department_name,
    city, state_province,
    jobs.job_id, job_title
from locations
    inner join departments
        on locations.location_id = departments.location_id
    inner join employees
        on employees.department_id = departments.department_id
    inner join jobs
        on employees.job_id = jobs.job_id
    where city = initcap('seattle');

-- ���̺��� ��Ī�� ����ϸ� ��������� �����ϰ� ������ �ۼ� ����.
select 
    first_name, last_name, email,
    D.department_id, department_name,
    city, state_province,
    J.job_id, job_title
from locations L
    inner join departments D
        on L.location_id = D.location_id
    inner join employees E
        on E.department_id = departments.department_id
    inner join jobs J
        on E.job_id = J.job_id
    where city = initcap('seattle');

/*
����2] ����Ŭ ���
    select �÷�1, �÷�2, ...
    from ���̺�1, ���̺�2
    where
        ���̺�1.�⺻Ű�÷� = ���̺�2.�ܷ�ų�÷�
        and ����1 and ����2 ...;
ǥ�ع�Ŀ��� ����� inner join�� on�� �����ϰ� ������ ������
where���� ǥ���ϴ� ����̴�.
*/

/*
�ó�����] ������̺�� �μ����̺��� �����Ͽ� �� ������ � �μ�����
    �ٹ��ϴ��� ����Ͻÿ�. ��, ����Ŭ ������� �ۼ��Ͻÿ�.
    ��°��: ������̵�, �̸�1, ��, �̸���, �μ���ȣ, �μ���
*/
select
    employee_id, first_name, last_name,
    email, Dep.department_id, department_name
from employees Emp, departments Dep
where Emp.department_id = Dep.department_id;

/*
�ó�����] seattle(�þ�Ʋ)�� ��ġ�� �μ����� �ٹ��ϴ� ������ ������
    ����ϴ� �������� �ۼ��Ͻÿ�. �� ����Ŭ ������� �ۼ��Ͻÿ�. 
    ��°��] ����̸�, �̸���, �μ����̵�, �μ���, ���������̵�, 
        ��������, �ٹ�����
    �� ��°���� ���� ���̺� �����Ѵ�. 
    ������̺� : ����̸�, �̸���, �μ����̵�, ���������̵�
    �μ����̺� : �μ����̵�(����), �μ���, �����Ϸù�ȣ(����)
    ���������̺� : ��������, ���������̵�(����)
    �������̺� : �ٹ��μ�, �����Ϸù�ȣ(����)
*/
select
    first_name, last_name, email,
    D.department_id, department_name,
    J.job_id, job_title,
    city, state_province
from locations L, departments D, employees E, jobs J
where
    L.location_id = D.location_id and
    D.department_id = E.department_id and
    E.job_id = J.job_id and
    lower(city) = 'seattle';


/*
2] Outer join(�ܺ�����)
outer join�� inner join�� �޸� �� ���̺� ���� ������ ��Ȯ�� ��ġ����
�ʾƵ� ������ �Ǵ� ���̺��� ���ڵ带 �����ϴ� ����̴�.
outer join�� ����� ���� �ݵ�� ������ �Ǵ� ���̺��� �����ϰ� ��������
�ۼ��ؾ��Ѵ�.
    => left(�������̺�), right(���������̺�), full(�������̺�)

����1(ǥ�ع��)
    select �÷�1, �÷�2...
    from ���̺�1
        left[right, full] outer join
            on ���̺�1.�⺻�� = ���̺�2.����Ű
    where ����1 and ����2 or ����3 ...;
*/
/*
�ó�����] ��ü������ �����ȣ, �̸�, �μ����̵�, �μ���, ������
�ܺ�����(left)�� ���� ����Ͻÿ�.
*/
select
    employee_id, first_name, last_name,
    em.department_id, department_name, city
from employees Em
    left outer join departments De
        on Em.department_id = De.department_id
    left outer join locations Lo
        on De.location_id = lo.location_id;
/* �������� ���� �������ΰ��� �ٸ��� 107���� ���ڵ尡 ����ȴ�.
�μ��� �������� ���� ������� ����Ǳ� �����ε�. �� ��� �μ��ʿ�
���ڵ尡 �����Ƿ� null�� ��µȴ�.*/

/*
����2(����Ŭ���)
    select �÷�1, �÷�2
    from ���̺�1, ���̺�2
    where
        ���̺�1.�⺻Ű = ���̺�2.�ܷ�Ű (+)
        and ����1 and ����2;
- ����Ŭ ������� ����ÿ��� outer join �������� (+)�� �ٿ��ش�.
- ���� ��� ���� ���̺��� ������ �ȴ�.
- ������ �Ǵ� ���̺��� �����Ҷ��� ���̺��� ��ġ�� �Ű��ش�.
  (+)�� �ű��� �ʴ´�.
*/

/*
�ó�����] ��ü������ �����ȣ, �̸�, �μ����̵�, �μ���, ������
�ܺ�����(left)�� ���� ����Ͻÿ�. ��, ����Ŭ ������� �ۼ��Ͻÿ�.
*/
select
    employee_id, first_name, last_name,
    em.department_id, department_name, city
from employees em, departments de, locations lo
where
    em.department_id = de.department_id (+) and
    de.location_id = lo.location_id (+);