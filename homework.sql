/* 1. ��ü ����� �޿��ְ��, ������, ��ձ޿��� ����Ͻÿ�. �÷��� ��Ī�� �Ʒ��� ���� �ϰ�, ��տ� ���ؼ��� �������·� �ݿø� �Ͻÿ�.
��Ī) �޿��ְ�� -> MaxPay
�޿������� -> MinPay
�޿���� -> AvgPay
*/
select
    min(salary) MinPay, max(salary) MaxPay, ceil(avg(salary)) AvgPay
from employees;
/*
2. �� ������ �������� �޿��ְ��, ������, �Ѿ� �� ��վ��� ����Ͻÿ�.
�÷��� ��Ī�� �Ʒ��� �����ϰ� ��� ���ڴ� to_char�� �̿��Ͽ�
���ڸ����� �ĸ��� ��� �������·� ����Ͻÿ�.
��Ī) �޿��ְ�� -> MaxPay
�޿������� -> MinPay
�޿���� -> AvgPay
�޿��Ѿ� -> SumPay
����) employees ���̺��� job_id�÷��� �������� �Ѵ�.
*/
select
    job_id, to_char(min(salary) , '999,000') MinPay,
    to_char(max(salary), '999,000') MaxPay, 
    to_char(sum(salary), '999,000') Sumpay,
    to_char(round(avg(salary)), '999,000') AvgPay
from employees group by job_id order by job_id;

--3. count() �Լ��� �̿��Ͽ� �������� ������ ������� ����Ͻÿ�.
select
    job_id, count(department_id) "�����հ�"
from employees group by job_id order by �����հ�;

--4. �޿��� 10000�޷� �̻��� �������� �������� �հ��ο����� ����Ͻÿ�.
select
    job_id, count(department_id) "�հ��ο���"
from employees where salary >= 10000 group by job_id;

--5. �޿��ְ�װ� �������� ������ ����Ͻÿ�. 
select
    max(salary) - min(salary) "�ְ��ּұ޿���"
from employees;

/*
6. �� �μ��� ���� �μ���ȣ, �����, �μ� ���� ��� ����� ��ձ޿��� ����Ͻÿ�.
��ձ޿��� �Ҽ��� ��°�ڸ��� �ݿø��Ͻÿ�.
*/
select
    department_id, count(*), rtrim(to_char(avg(salary),'999,000.00')) "��ձ޿�"
from employees group by department_id order by department_id;