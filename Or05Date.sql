/*****
���ϸ� : Or05Date.sql
��¥�Լ�
���� : ��, ��, ��, ��, ��, ���� �������� ��¥������ �����ϰų�
    ��¥�� ����Ҷ� Ȱ���ϴ� �Լ���
*****/
/*
months_between() : ���糯¥�� ���س�¥ ������ �������� ��ȯ�Ѵ�.
    ����] months_between(���糯¥, ���س�¥[���ų�¥]);
*/
-- 2020�� 01�� 01�Ϻ��� ���ݱ��� ����� �����°�?
SELECT
    months_between(sysdate, '2020-01-01'),
    ceil(months_between(sysdate, '2020-01-01')) "�ø�ó��",
    floor(months_between(sysdate, '2020-01-01')) "����ó��"
from dual;

--����] ���� "2020��01��01��" ���ڿ��� �״�� �����ؼ� �������� ����Ϸ���?
SELECT
    to_char(
        trunc(months_between(sysdate,
            to_date('2020��01��01��', 'yyyy"��"mm"��"dd"��"')))) "����������"
from dual;

/*
last_day(): �ش���� ������ ��¥�� ��ȯ�Ѵ�.
*/
select last_day('22-04-03') from dual; -- 4���� 30�ϱ��� ����
select last_day('24-02-03') from dual; -- 24���� �����̹Ƿ� 29�� ���
select last_day('25-02-03') from dual; -- 25���� 28�� ���

--�÷��� date Ÿ���� ��� ������ ��¥������ �����ϴ�.
select
    sysdate "����", 
    sysdate + 1 "����",
    sysdate - 7 "��������"
from dual;