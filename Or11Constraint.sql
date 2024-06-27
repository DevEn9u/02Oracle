/***********
���ϸ� : Or11Constraint.sql
��������
���� : ���̺� ������ �ʿ��� �������� �������ǿ� ���� �н��Ѵ�.
***********/
--study �������� �ǽ��մϴ�.

/*
primary key : �⺻Ű
- �������Ἲ�� �����ϱ� ���� ��������
- �ϳ��� ���̺��� �ϳ��� �⺻Ű�� ������ �� �ִ�.
- �⺻Ű�� ������ �÷��� �ߺ��� ���̳� Null���� �Է��� �� ����.
- �ַ� ���ڵ� �ϳ��� Ư���ϱ� ���� ���ȴ�.
*/

/*
����1] �ζ��ι�� : �÷� ������ ������ ���������� ����Ѵ�.
    create table ���̺�� (
        �÷��� �ڷ���(ũ��) [constraint �����] primary key
    )
    �� [] ���ȣ �κ��� ���� �����ϰ�, ������ ������� �ý�����
    �ڵ����� �ο��Ѵ�.
*/
CREATE table tb_primary1 (
    idx number(10) primary key,
    user_id varchar2(30),
    user_name varchar2(50)
);
desc tb_primary1;

/*
�������� �� ���̺� ��� Ȯ���ϱ�
    tab : ���� ������ ������ ���̺��� ����� Ȯ���� �� �ִ�.
    user_cons_columns : ���̺� ������ �������Ǹ�� �÷�����
        ������ ������ �����Ѵ�.
    user_constraints : ���̺� ������ ���������� ���� ������ �����Ѵ�.
�� �̿� ���� ���������̳� ��, ���ν������� ������ �����ϰ� �ִ�
    �ý��� ���̺��� '�����ͻ���'�̶�� �Ѵ�.
*/
select * from tab;
select * from user_cons_columns;
select * from user_constraints;

--���ڵ� �Է�
insert into tb_primary1 values(1, 'jongro1', '����');
insert into tb_primary1 values(2, 'cityhall', '��û');
/* ���Ἲ ���� ���� ����� ������ �߻��Ѵ�. PK�� ������ �÷� idx����
�ߺ��� ���� �Է��� �� ����. */
insert into tb_primary1 values(2, 'cityError', '�����߻�');

insert into tb_primary1 (idx, user_id, user_name)
    values (3, 'white', 'ȭ��Ʈ');
/* PK�� ������ �÷����� NULL���� �Է��� �� ����. �����߻��� */
insert into tb_primary1 (idx, user_id, user_name)
    values ('', 'black', '��');

select * from tb_primary1;
/* update���� ���������� idx ���� �̹� �����ϴ� 2�� ���������Ƿ�
�������� ����� ������ �߻��Ѵ�.*/
update tb_primary1 set idx = 2 where user_id = 'jongro1';

/*
����2] �ƿ����� ���
    create table ���̺�� (
        �÷��� �ڷ���(ũ��),
        [constraintes �����] primary key (�÷���)
    );
*/
CREATE table tb_primary2 (
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50),
    constraint my_pk1 primary key (user_id)
);
desc tb_primary2;
insert into tb_primary2 values(1, 'jongro1', '����');
/* PK ������ my_pk1�̶�� �̸��� ���������Ƿ� ���� �߻��� ������
�̸��� �ֿܼ� ����Ѵ�. */
insert into tb_primary2 values(2, 'jongro1', '����Error');
select * from tb_primary2;

/*
����3] ���̺� ���� �� alter������ �������� �߰�
    alter table ���̺�� add [constraint �����]
        primery key (�÷���);
*/
create table tb_primary3 (
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50)
);
desc tb_primary3;
/* ���̺��� ������ �� alter������ ���������� �ο��Ѵ�. �������
�ʿ信 ���� ������ �����ϴ�. */
alter table tb_primary3 add constraint tb_primary3_pk
    primary key (user_name);
--������ �������� �������� Ȯ���ϱ�
select * from user_constraints;
--���������� ���̺��� ������� �ϹǷ� ���̺��� �����Ǹ� ���� �����ȴ�.
drop table tb_primary3;
--Ȯ�ν� �����뿡 �� ���� �� �� �ִ�.
select * from user_cons_columns;

--PK�� ���̺�� �ϳ��� ������ �� �����Ƿ� ������ �߻��Ѵ�.
create table tb_primary4 (
    idx number(10) primary key,
    user_id varchar2(30) primary key,
    user_name varchar2(50)
);
/* 
unique
- ���� �ߺ��� ������� �ʴ� ��������
- ����, ���ڴ� �ߺ��� ������� �ʴ´�.
- ������ NULL���� ���ؼ��� �ߺ��� ����Ѵ�.
- unique�� �� ���̺� 2�� �̻� ������ �� �ִ�.
*/
create table tb_unique (
    idx number unique not null, /* �ζ��� ������� ���� */
    user_id varchar2(30),
    telephone varchar2(20),
    nickname varchar2(30),
    unique(telephone, nickname) /* �ƿ����� ������� 2�� ���� ���� */
);
--������ �������� ������ �������� Ȯ��
select * from user_cons_columns;

insert into tb_unique (idx, name, telephone, nickname)
    values (1, '���̸�', '010-1111-1111', '���座��');
insert into tb_unique (idx, name, telephone, nickname)
    values (2, '����', '010-2222-2222', '');
insert into tb_unique (idx, name, telephone, nickname)
    values (3, '����', '', '');
--unique�� �ߺ��� ������� ������ null�� ������ �Է��� �� �ִ�.
select * from tb_unique;
--idx�÷��� �ߺ��� ���� �ԷµǹǷ� ������ �߻��Ѵ�.
insert into tb_unique (idx, name, telephone, nickname)
    values (2, '����', '010-3333-3333', '');

insert into tb_unique values(4, '����', '010-4444-4444', '��');

insert into tb_unique values(5, '����', '010-5555-5555', '��');
--�Է� ���� �߻�
insert into tb_unique values(6, '���', '010-5555-5555', '��');
/*
    telephone�� nickname�� ������ ��������� �����Ǿ����Ƿ� �ΰ���
    �÷��� ���ÿ� ������ ���� ������ ��찡 �ƴ϶�� �ߺ��� ���� ���ȴ�.
    ��, 4���� 5���� ���� �ٸ� �����ͷ� �ν��ϹǷ� �Էµǰ�, 6���� ��쿡��
    ������ �����ͷ� �νĵǾ� ������ �߻��Ѵ�.
*/

/*
Foreign key : �ܷ�Ű, ����Ű
- �ܷ�Ű�� �������Ἲ�� �����ϱ� ���� ��������
- ���� ���̺� �� �ܷ�Ű�� �����Ǿ� �ִٸ� �ڽ� ���̺� ��������
    ������ ��� �θ����̺��� ���ڵ�� ������ �� ����.

����1] �ζ��� ���
    create table ���̺�� (
        �÷��� �ڷ��� [constraint �����]
            refernces �θ����̺�� (������ �÷���)
    );
*/
create table tb_foreign1 (
    f_idx number(10) primary key,
    f_name varchar2(50),
    /* �ڽ����̺��� tb_foreign1���� �θ����̺��� tb_primary2�� 
    user_id �÷��� �����ϴ� �ܷ�Ű�� �����Ѵ�. */
    f_id varchar2(30) constraint tb_foreign_fk1
        references tb_primary2(user_id)
);
--�θ����̺��� ���ڵ� 1���� ���ԵǾ� ����
select * from tb_primary2;
--�ڽ����̺��� ���ڵ尡 ���� ����
select * from tb_foreign1;
--�����߻�. �θ����̺��� 'gildong' �̶�� user_id�� ����.
insert into tb_foreign1 values (1, 'ȫ�浿', 'gildong');
--�Է¼���. �θ����̺� �ش� ���̵� �ԷµǾ�����.
insert into tb_foreign1 values (1, '������', 'jongro1');
/* �ڽ����̺��� �����ϴ� ���ڵ尡 �����Ƿ�, �θ����̺��� ���ڵ带
������ �� ����. �� ��� �ݤ��� �ڽ����̺��� ���ڵ带 ���� ������ ��
�θ����̺��� ���ڵ带 �����ؾ� �Ѵ�. */
delete from tb_primary2 where user_id = 'jongro1';

--�ڽ����̺��� ���ڵ带 ���� ������ ��...
delete from tb_foreign1 where f_id = 'jongro1';
--�θ����̺��� ���ڵ带 �����ϸ� ���� ó���ȴ�.
delete from tb_primary2 where user_id = 'jongro1';
/*
    2���� ���̺��� �ܷ�Ű(����Ű)�� �����Ǿ� �ִ� ���
    �θ����̺� ������ ��� ���ڵ尡 ������ �ڽ����̺� insert�� �� ����.
    �ڽ����̺� �θ� �����ϴ� ��� ���ڵ尡 ���������� �θ����̺���
    ���ڵ带 delete�� �� ����.
*/

/*
����2] �ƿ����� ���
    create table ���̺�� (
        �÷���, �ڷ���,
        [constraint �����] forein key (�÷���)
            references �θ����̺� (������ �÷�)
    );
*/
create table tb_foreign2 (
    f_id number primary key,
    f_name varchar2(30),
    f_date date,
    /* tb_foreign2 ���̺��� f_id �÷��� �θ����̺��� tb_primary1��
    idx �÷��� �����ϴ� �ܷ�Ű�� �����Ѵ�.*/
    foreign key (f_id) references tb_primary1 (idx)
);
select * from user_constraints;
/*
�����ͻ������� �������� Ȯ�ν� �÷���
P : Primary key
R : Reference integrity(���� ���Ἲ), �� Foreign key�� ���Ѵ�.
C : Check Ȥ�� Not Null
U : Unique
*/

/*
����3] ���̺� ���� �� alter������ �ܷ�Ű �������� �߰�
    alter table ���̺�� add [constraints �����]
        foreign key (�÷���)
            references �θ����̺� (�����÷���)
*/
create table tb_foreign3 (
    f_id number primary key,
    f_name varchar2(30),
    f_idx number(10)
);

alter table tb_foreign3 add
    foreign key (f_idx) references tb_primary1 (idx);
/* ���� tb_primary1 ���̺��� tb_foreign2�� �ڽ����� �� ����.
�ϳ��� �θ����̺� �� �̻��� �ڽ����̺��� �ܷ�Ű�� ������ �� �ִ�. */

/*
�ܷ�Ű ������ �ɼ�
[on delete cascade]
    : �θ��ڵ� ������ �ڽķ��ڵ���� ���� �����ȴ�. 
    ����]
        �÷��� �ڷ��� references �θ����̺� (pk�÷�)
            on delete cascade;
[on delete set null]
    : �θ��ڵ� ������ �ڽķ��ڵ� ���� null�� ����ȴ�.
    ����]  
        �÷��� �ڷ��� references �θ����̺� (pk�÷�)
            on delete set null            
            
�� �ǹ����� ���԰Խù��� ���� ȸ���� �� �Խñ��� �ϰ������� �����ؾ��Ҷ�
����� �� �ִ� �ɼ��̴�. ��, �ڽ����̺��� ��� ���ڵ尡 �����ǹǷ� ��뿡
�����ؾ��Ѵ�.
*/
create table tb_primary4 (
    user_id varchar2(30) primary key,
    user_name varchar2(100)
);
create table tb_foreign4 (
    f_idx number(10) primary key,
    f_name varchar2(30),
    user_id varchar2(30) constraint tb_foreign4_fk
        references tb_primary4 (user_id)
            on delete cascade
);
insert into tb_primary4 values ('stu1', '�Ʒû�');
insert into tb_foreign4 values (1, '����1', 'stu1');
insert into tb_foreign4 values (2, '����2', 'stu1');
insert into tb_foreign4 values (3, '����3', 'stu1');
insert into tb_foreign4 values (4, '����4', 'stu1');
insert into tb_foreign4 values (5, '����5', 'stu1');
--���ڵ� Ȯ���ϱ�
select * from tb_primary4;
select * from tb_foreign4;
/* �θ����̺��� ���ڵ带 ������ ��� on delete cascade �ɼǿ� ����
�ڽ��ʱ��� ��� ���ڵ尡 �����ȴ�. ���� �ش� �ɼ��� �ο����� �ʾҴٸ�
���ڵ�� �������� �ʰ� ������ �߻��ϰ� �ȴ�.*/
delete from tb_primary4 where user_id = 'stu1';
--�θ�, �ڽ� ���̺��� ��� ���ڵ尡 ������ ���� Ȯ���� �� �ִ�.
select * from tb_primary4;
select * from tb_foreign4;