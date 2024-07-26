-- system�������� �� ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER modernize_t IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE, unlimited tablespace TO modernize_t;

------------------------------------------------------------
-- modernize_t �������� ���̺� ����
CREATE TABLE membership (
    id varchar2(30) primary key,
    pass varchar2(30) not null,
    name varchar2(30) not null,
    email varchar2(30) not null,
    mobile varchar2(30) not null,
    regidate date default sysdate
);
desc membership;

INSERT INTO membership (id, pass, name, email, mobile)
VALUES ('tjoeun', '1234', '������IT', 'tj@tjoeun.com', '010-1234-5678');
commit;
SELECT * FROM membership;

-- �α��� ó���� ���� ������
SELECT * FROM membership WHERE id = 'tjoeun' AND pass = '1234';
SELECT * FROM membership WHERE id = 'tjoeun' AND pass = '9999';


/*
���� Model 2 ����� �Խ����� ��ȸ���� �Խ����̹Ƿ� ȸ������ �����ϱ� ����
name �� id�� �����Ѵ�.
���� pass�� �ʿ���� ������ �����Ѵ�.
*/
create table mvcboard (
    idx number primary key, /* �Ϸù�ȣ */
    id varchar2(50) not null, /* �ۼ��� ���̵� */
    title varchar2(200) not null,/* ���� */
    content varchar2(2000) not null, /* ���� */
    postdate date default sysdate not null, /* �ۼ��� */
    ofile varchar2(200), /* ���� ���ϸ� */
    sfile varchar2(30), /* ������ ����� ���ϸ� */
    downcount number(5) default 0 not null, /* ���� �ٿ�ε� Ƚ�� */
    visitcount number default 0 not null /* �Խù� ��ȸ�� */
);

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
insert into mvcboard (idx, id, title, content)
    values (seq_board_num.nextval, 'tjoeun', '�ڷ�� ����1 �Դϴ�.','����');
insert into mvcboard (idx, id, title, content)
    values (seq_board_num.nextval, 'tjoeun', '�ڷ�� ����2 �Դϴ�.','����');
insert into mvcboard (idx, id, title, content)
    values (seq_board_num.nextval, 'tjoeun', '�ڷ�� ����3 �Դϴ�.','����');
insert into mvcboard (idx, id, title, content)
    values (seq_board_num.nextval, 'tjoeun', '�ڷ�� ����4 �Դϴ�.','����');
insert into mvcboard (idx, id, title, content)
    values (seq_board_num.nextval, 'tjoeun', '�ڷ�� ����5 �Դϴ�.','����');

commit;

SELECT * FROM mvcboard;

--��� ����� ���̺� ����
create table comments (
    idx number primary key, /* ����� �Ϸù�ȣ */
    board_idx number not null, /* ����� �ۼ��� �Խù��� �Ϸù�ȣ*/
    writer varchar2(30) not null, /* �ۼ��� ���̵� */
    comments varchar2(2000) not null, /* ���� */
    postdate date default sysdate /* �ۼ��� */
);
--�ڵ�� �ڵ� �Է�
INSERT INTO comments (idx, board_idx, writer, comments)
    VALUES (seq_board_num.nextval, ?, ?, ?);
INSERT INTO comments (idx, board_idx, writer, comments)
    VALUES (seq_board_num.nextval, 7, '��', '�׽�Ʈ���') ;
    
SELECT * FROM comments;

SELECT * FROM comments WHERE board_idx = 7  ORDER BY idx DESC;