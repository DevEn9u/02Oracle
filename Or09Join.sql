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
    
/*
����] 2007�⿡ �Ի��� ����� ��ȸ�Ͻÿ�. ��, �μ��� ��ġ���� ����
������ ��� <�μ�����>���� ����Ͻÿ�. ��, ǥ�ع������ �ۼ��Ͻÿ�.
����׸� : ���, �̸�, ��, �μ���
*/
select
    employee_id, first_name, last_name,
    hire_date, nvl(department_name, '<�μ�����>')
from employees em left outer join departments de
    on em.department_id = de.department_id
where
   hire_date like '07%';
   
--����� ����
-- �켱 ����� ���ڵ带 �����ϰ� Ȯ���Ѵ�.
select first_name, hire_date, to_char(hire_date, 'yyyy') from employees;
-- 2007�⿡ �Ի��� ����� �����Ѵ�.
select first_name, hire_date from employees
where to_char(hire_date, 'yyyy') = '2007';
/* �ܺ������� ǥ�ع������ �ۼ��� �� ����� Ȯ���Ѵ�.
nvl()�Լ��� ���� null���� ������ ������ �����Y�д�. ����� 19�� ����� */
select employee_id, first_name, last_name, nvl(department_name, '<�μ�����>')
from employees E left outer join departments D
    on E.department_id = D.department_id
where to_char(hire_date, 'yyyy') = '2007';

/*
�ó�����] �� �������� ����Ŭ ������� �����Ͻÿ�.
*/
select employee_id, first_name, last_name, nvl(department_name, '<�μ�����>')
from employees Em, departments Dm
where Em.department_id = Dm.department_id (+)
    and to_char(hire_date, 'yyyy') = '2007';

/*
3] self join(��������)
���������� �ϳ��� ���̺� �ִ� �÷����� �����ؾ� �ϴ� ��� ����Ѵ�.
�� �ڱ��ڽ��� ���̺�� ������ �δ� ���̴�.
�������ο����� ��Ī�� ���̺��� �����ϴ� �������� ������ �ϹǷ� ������
�߿��ϴ�.
����] select ��Ī1.�÷�, ��Ī2.�÷� ...
        from ���̺�A ��Ī1, ���̺�A ��Ī2
        where ��Ī1.�÷� = ��Ī2.�÷�;
*/

/*
�ó�����] ������̺��� �� ����� �Ŵ��� ���̵�� �Ŵ��� �̸��� ����Ͻÿ�.
    ��, �̸��� first_name�� last_name�� �ϳ��� �����ؼ� ����Ͻÿ�.
*/
select 
    empclerk.employee_id "�����ȣ",
    empclerk.first_name || ' ' || empclerk.last_name "full_name",
    empclerk.manager_id "�Ŵ��������ȣ",
    empManager.first_name || ' ' || empManager.last_name "Manager_full_name"
from employees empClerk, employees empManager
where empClerk.manager_id = empManager.employee_id;

/*
�ó�����] self join�� ����Ͽ� 'Kimberely / Grant' ������� �Ի�����
���� ����� �̸��� �Ի����� ����Ͻÿ�.
��¸��: first_name, last_name, hire_date
*/

-- Kimberely�� �Ի��� Ȯ��
select first_name, last_name, hire_date
from employees
where first_name = 'Kimberely' and last_name = 'Grant';
-- �Ի����� 07/05/24�� ���� Ȯ��, �� ���Ŀ� �Ի��� ����� ���ڵ� ����
select first_name, last_name, hire_date
from employees
where hire_date > '07/05/24' order by first_name;

-- self join���� ������ �ۼ�(Ŵ������ ��� ������ ���̺�� ����)
select clerk.first_name, clerk.last_name, clerk.hire_date
from employees Kim, employees Clerk
where kim.hire_date < clerk.hire_date and
    kim.first_name = 'Kimberely' and kim.last_name = 'Grant'
order by first_name;

/*
using: join������ �ַ� ����ϴ� on���� ��ü�� �� �ִ� ����
    ����] on ���̺�1.�÷� = ���̺�2.�÷�
            => using(�÷�)
*/
/*
�ó�����] Seattle�� ��ġ�� �μ����� �ٹ��ϴ� ������ ������
    ����ϴ� �������� �ۼ��Ͻÿ�. �� using�� ����ؼ� �ۼ��Ͻÿ�.
    ��°��] ����̸�, �̸���, �μ����̵�, �μ���, ���������̵�,
        ��������, �ٹ�����
*/
select 
    first_name, last_name, email, 
    department_id, departements.department_name,
    jobs.job_id, job_title, city, state_province
from locations inner join departments using(location_id)
    inner join employees using(department_id)
    inner join jobs using(job_id)
where city = initcap('seattle');
/*
    �� �������� using���� ����ϸ鼭 �����Ϸ��� �����Ϳ� ��Ī�� �ٿ���.
    using���� ���� �����÷��� ��� select������ ��Ī�� ���̸� ������
    ������ �߻��Ѵ�.
    using���� ���� �÷��� ���� ���̺� ���ÿ� �����ϴ� �÷��̶��
    ���� ������ �ۼ��Ǳ� ������ ���� ��Ī�� ����� �ʿ䰡 ���� �����̴�.
    �� using�� ���̺��� ��Ī �� on���� �����Ͽ� �� �� �����ϰ� 
    join �������� �ۼ��� �� �ְ� ���ش�.
*/
select 
    first_name, last_name, email, 
    department_id, department_name,
    job_id, job_title, city, state_province
from locations inner join departments using(location_id)
    inner join employees using(department_id)
    inner join jobs using(job_id)
where city = initcap('seattle');

/*
 ����] 2005�⿡ �Ի��� ������� California(STATE_PROVINCE) / 
 South San Francisco(CITY)���� �ٹ��ϴ� ������� ������ ����Ͻÿ�.
 ��, ǥ�ع�İ� using�� ����ؼ� �ۼ��Ͻÿ�.
 
 ��°��] �����ȣ, �̸�, ��, �޿�, �μ���, �����ڵ�, ������(COUNTRY_NAME)
        �޿��� ���ڸ����� �ĸ��� ǥ���Ѵ�. 
 ����] '������'�� countries ���̺� �ԷµǾ��ִ�. 
*/
select
    employee_id, first_name, last_name, 
    ltrim(to_char(salary, '$999,000')) "SALARY",
    department_name, country_id, country_name
from countries inner join locations using(country_id)
    inner join departments using(location_id)
    inner join employees using(department_id)
where
    substr(hire_date, 1, 2) = 05 and
    state_province = initcap('california') and
    city = 'South San Francisco';

-- ����� ����
-- 2005�⿡ �Ի��� ��� ����(���: 29��)
select first_name, hire_date from employees;
-- substr() �̿�
select first_name, hire_date from employees
where substr(hire_date, 1, 2) = 05;
-- to_char() �̿�
select first_name, hire_date from employees
where to_char(hire_date, 'yyyy') = 2005;
-- �������� �־��� ���������� �μ���ȣ�� Ȯ��(���: ������ȣ 1500)
select * from locations where city = 'South San Francisco'
    and state_province = 'California';
-- ������ȣ 1500�� ���� �ش� ��ġ�� �ִ� �μ��� Ȯ��(���: �μ���ȣ 50)
select * from departments where location_id = 1500;
-- �տ��� Ȯ���� ������ ���� ������ �ۼ�
select * from employees where department_id = 50 and
    to_char(hire_date, 'yyyy') = 2005;
/* 2005�⿡ �Ի��߰�, 50���μ�(shipping)�� �ٹ��ϴ� �����
������ �����ؾ� �Ѵ�.*/
select 
    employee_id, first_name, last_name, to_char(salary, '$0,000'),
    department_name, country_id, country_name
from employees inner join departments using(department_id)
    inner join locations using(location_id)
    inner join countries using(country_id)
where to_char(hire_date, 'yyyy') = 2005 and
    city = 'South San Francisco' and
    state_province = 'California';
