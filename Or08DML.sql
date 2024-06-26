/********
���ϸ� : Or08DML.sql
DML : Data Manipulation Language(������ ���۾�)
���� : ���ڵ带 ������ �� ����ϴ� ������. �տ��� �н��ߴ�
    select���� ����Ͽ� update(���ڵ����), delete(���ڵ����),
    insert(���ڵ��Է�)�� �ִ�.
********/

--study �������� �ǽ��մϴ�.

--���ο� ���̺� �����ϱ�
create table tb_sample (
    no number(10),
    name varchar2(20),
    loc varchar2(15),
    manager varchar2(30)
);
desc tb_sample;

/*
���ڵ� �Է��ϱ� : insert
    ���ڵ� �Է��� ���� ���������� �������� �ݵ�� ''(single quotation)����
    ���ξ� �ϰ� �������� ���� ����Ѵ�. ���� �������� ''�� ���δ� ��쿡��
    �ڵ����� ����ȯ�Ǿ� �Էµȴ�.
*/
--���ڵ� �Է�1: �÷��� ������ �� insert �Ѵ�.
insert into tb_sample(no, name, loc, manager)
    values (10, '��ȹ��', '����', '����');
insert into tb_sample(no, name, loc, manager)
    values (20, '�����', '����', '����');
select * from tb_sample;

--���ڵ� �Է�2: �÷� ���� ���� ��ü �÷��� ������� insert �Ѵ�.
insert into tb_sample values (30, '������', '�뱸', '���');
insert into tb_sample values (40, '�λ��', '�λ�', '����');
select * from tb_sample;  

/*
�÷��� �����ؼ� insert �ϴ� ��� �����͸� �������� ���� �÷��� ������ �� �ִ�.
�Ʒ��� ��� name �÷��� null���� �Էµȴ�.
*/
insert into tb_sample(no, loc, manager) values (50, '����', '��Ź');
select * from tb_sample;

/*
���ݱ����� �۾�(Ʈ�����)�� �״�� �����ϰڴٴ� ������� Ŀ���� �������� ������
�ܺο����� ����� ���ڵ带 Ȯ���� �� ����.
���⼭ �ܺζ� Java/JSP�� ���� Oracle �̿��� ���α׷��� �ǹ��Ѵ�.
�� transaction�̶� �۱ݰ� ���� �ϳ��� �����۾��� ���Ѵ�.
*/
commit;

--Ŀ�� ���� ���ο� ���ڵ带 �����ϸ� �ӽ����̺� ����ȴ�.
insert into tb_sample(no, loc, manager) values (60, '�±�', '�ձ�');
--select ��ɾ�� ���ο� ���ڵ������ Ȯ���� �� ������ ���� ���̺��� �ݿ����� ����
select * from tb_sample;

--�ѹ� ��ɾ�� ������ Ŀ�� ���·� �ǵ��� �� �ִ�.
rollback;
--������ Ŀ�� �۾� ���Ŀ� �Է��� '�ձ�' �׸��� ���ŵȴ�.
select * from tb_sample;

/*
���ڵ� �����ϱ� : update
����] update ���̺��
        set �÷�1 = ��, �÷�2 = �� ...
        where ����;
    �� ������ ���� ��� ��� ���ڵ尡 �Ѳ����� �����ȴ�.
    �� ���̺�� �տ� from�� ���� �ʴ´�.
*/
-- ��ȣ�� 40�� ���ڵ��� ������ '�̱�'���� �����Ͻÿ�.
UPDATE tb_sample set loc = '�̱�' where no = 40;
select * from tb_sample;
-- ������ ������ ���ڵ��� �Ŵ������� '��������'���� �����Ͻÿ�.
UPDATE tb_sample set manager = '��������' where loc = '����';
select * from tb_sample;
-- ��� ���ڵ带 ������� ������ '����'���� �����Ͻÿ�.
-- ��ü ���ڵ尡 ����� ��� where���� �����Ѵ�.
UPDATE tb_sample set loc = '����';
select * from tb_sample;

/*
���ڵ� ���� : delete
����] delete from ���̺�� where ����;
�� ���ڵ带 �����ϹǷ� delete �ڿ� �÷��� ������� �ʴ´�.
*/
--��ȣ�� 10�� ���ڵ带 �����Ͻÿ�.
delete from tb_sample where no = 10;
select * from tb_sample;
--���ڵ� ��ü�� �����Ͻÿ�.
delete from tb_sample;
select * from tb_sample;

--������ Ŀ�� �������� �ǵ����ش�.
rollback;
select * from tb_sample;

/*
DDl(Data Definition Language)�� : ���̺��� ���� �� �����ϴ� ������
    ���̺� ���� : create table ���̺��
    ���̺� ����
        �÷��߰� : alter table ���̺�� add �÷���
        �÷����� : alter table ���̺�� modify �÷���
        �÷����� : alter table ���̺�� drop column �÷���
    ���̺� ���� : drop table ���̺��
    
DMl(Data Manipulation Language)�� : ���ڵ带 �Է� �� �����ϴ� ������
    ���ڵ� �Է� : insert into ���̺�� (�÷�) values (��)
    ���ڵ� ���� : update ���̺�� set �÷� = �� where ����
    ���ڵ� ���� : delete from ���̺�� where ����
*/








