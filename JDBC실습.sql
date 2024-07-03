/*
JDBC ���α׷��� �ǽ��� ���� ��ũ��Ʈ
*/

--Java���� member���̺� CRUD ��� �����ϱ�
--member ���̺� ����
CREATE TABLE member (
    /* id, pass, name�� ����Ÿ������ �����ϰ� NULL���� ������� �ʴ� �÷�����
    �����Ѵ�. �� �ݵ�� �Է°��� �־�� insert�� �����ϴ�. */
	id VARCHAR2(30) NOT NULL,
	pass VARCHAR2(40) NOT NULL,
	name VARCHAR2(50) NOT NULL, 
    /* ��¥Ÿ������ ������. NULL�� ����ϴ� �÷����� �����Ѵ�. ���� �Է°���
    ���ٸ� ����ð�(SYSDATE)�� DEFAULT�� �Է��Ѵ�. */
	regidate DATE DEFAULT SYSDATE,
    /* ���̵� �⺻Ű(PK)�� �����Ѵ�. */
	PRIMARY KEY (id)
);

--member ���̺� ���ڵ�(���̵�����) �Է�
INSERT INTO member(id, pass, name) VALUES ('tjoeun01', '1234', '������IT');
/*
    �Է� �� commit�� �������� ������ ����Ŭ �ܺ� ���α׷�(Java, JSP)������
    ���Ӱ� �Է��� ���ڵ带 Ȯ���� �� ����. �Էµ� ���ڵ带 �����ϱ� ����
    �ݵ�� commit�� �����ؾ� �Ѵ�.
    Java�� ���� �ܺο��� �ԷµǴ� �����ʹ� �ڵ����� commit �ǹǷ� ������ ó����
    �ʿ����� �ʴ�.
*/
SELECT * FROM member;
COMMIT;

--like�� �̿��� ������ �˻� ��� �����ϱ�
SELECT * FROM member WHERE name LIKE '%����%';
SELECT * FROM member WHERE regidate LIKE '___07_01';

---------------------------------------------------------
/*
JSP���� JDBC�����ϱ� �ǽ�
*/
--���� system �������� ������ �� ���ο� ������ �����Ѵ�.

--C## ���ξ� ���� ������ �����ϱ� ���� ���Ǻ���
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
--���ο� ����� ���� ����
CREATE USER musthave IDENTIFIED BY 1234;
--2���� Role�� ���̺����̽����� ���� �ο�
GRANT CONNECT, RESOURCE, unlimited tablespace TO musthave;

/*
CMD ȯ�濡�� sqlplus�� ���� ������ ��쿡�� �ٸ� �������� ��ȯ�� 
�Ʒ��� ���� conn Ȥ�� connect ��ɾ ����� �� �ִ�.
Developer������ ���� ����â�� ����Ѵ�.
*/
conn musthave/1234;
show user;

--musthave ������ �����Ǹ� ����â�� ����� �� �����մϴ�.
--������ �Ϸ�Ǹ� member, board ���̺� ���� �� �������� ������ �����մϴ�.
--���̺� ��� ��ȸ
SELECT * FROM TAB;

/* ���̺� �� ������ ������ ���� ���� ������ ��ü�� �ִٸ� ������ ������ ��
���Ӱ� �����Ѵ�. */
drop table member;
drop table board;
drop sequence seq_board_num;

--ȸ�� ���̺� ����
CREATE TABLE member (
    id varchar2(10) not null,
    pass varchar2(10) not null,
    name varchar2(30) not null,
    regidate date default sysdate not null,
    primary key (id) /* id�÷��� �⺻Ű(PK)�� ����*/
);

--�Խ��� ���̺� ����
CREATE TABLE board (
    num number primary key, /* �Ϸù�ȣ (PK) */
    title varchar2(200) not null, /* ���� */
    content varchar2(200) not null, /* ���� */
    id varchar2(10) not null, /* ȸ���� �Խ����̹Ƿ� ȸ�����̵� �ʿ�*/
    postdate date default sysdate not null, /* �Խù��� �ۼ��� */
    visitcount number(6) /* �Խù��� ��ȸ�� */
);

--�ܷ�Ű ����
/*
�ڽ����̺��� board�� �θ����̺��� member�� �����ϴ� �ܷ�Ű�� �����Ѵ�.
board�� id �÷��� member�� �⺻Ű�� id �÷��� �����ϵ��� ���������� ����.
*/
alter table board
    add constraint board_mem_fk foreign key (id)
    references member (id); --�������Ǹ���� �����ؼ� �ܷ�Ű ������.
    
--������ ����
--board ���̺� �ߺ����� �ʴ� �Ϸù�ȣ�� �ο��Ѵ�.
create sequence seq_board_num
    /* ����ġ, ���۰�, �ּڰ��� ��� 1�� ���� */
    increment by 1
    start with 1
    minvalue 1
    /* �ִ�, cycle, cache�޸� ����� ��� no�� ���� */
    nomaxvalue
    nocycle
    nocache;
    
--���� ������ �Է�
/*
�θ����̺��� memeber�� ���� ���ڵ带 ������ �� �ڽ����̺��� board�� �����ؾ� �Ѵ�.
���� �ڽ����̺� ���� �Է��ϸ� �θ�Ű�� ���ٴ� ������ �߻��Ѵ�.
2���� ���̺��� ���� �ܷ�Ű(��������)�� �����Ǿ� �����Ƿ� ���� ���Ἲ�� �����ϱ� ����
������� ���ڵ带 �����ؾ� �Ѵ�.
*/
insert into member (id, pass, name) values ('musthave', '1234', '�ӽ�Ʈ�غ�');
insert into board (num, title, content, id, postdate, visitcount)
    values (
        seq_board_num.nextval, '����1�Դϴ�', 
        '����1�Դϴ�', 'musthave', sysdate, 0);

--Ŀ���ؼ� ���� ���̺� ����
commit;