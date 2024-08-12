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
�θ����̺��� member�� ���� ���ڵ带 ������ �� �ڽ����̺��� board�� �����ؾ� �Ѵ�.
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

--������ �ַ� ����ϴ� ���̵� �߰� �Է��ϱ�
INSERT INTO member VALUES ('kig1132', '1234', '���꿣', sysdate);
SELECT * FROM member;
/* ���ڵ� �Է� �� Ŀ���� ���� ������ �ܺ� ���α׷������� ����� �� ����.
�ݵ�� COMMIT ����� �����Ͽ� ���� ���̺� ������ �� ����ؾ� �Ѵ�. */
COMMIT;

/**********************************
��1 ����� ȸ���� �Խ��� �����ϱ�
***********************************/
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '������ ���Դϴ�.', '���ǿ���', 'musthave',
        sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '������ �����Դϴ�.', '�������', 'musthave',
        sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '������ �����Դϴ�.', '������ȭ', 'musthave',
        sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '������ �ܿ��Դϴ�.', '�ܿ￬��', 'musthave',
        sysdate, 0);

SELECT * FROM board;

--DAO�� selectCount()�޼��� : board ���̺��� ���ù� ���� ī��Ʈ
SELECT count(*) FROM board;
SELECT count(*) FROM board WHERE title LIKE '%�ܿ�%';
SELECT count(*) FROM board WHERE title LIKE '%������%';
--���ǿ� ���� 0 Ȥ�� �� �̻��� �������� ����� ����ȴ�.(�׻� ������� �ִ�.)

--selectList()�޼��� : �Խ��� ��Ͽ� ����� ���ڵ带 �����ؼ� ����
SELECT * FROM board ORDER BY num DESC;
SELECT * FROM board WHERE title LIKE '%��%' ORDER BY num DESC;
SELECT * FROM board WHERE content LIKE '%����%' ORDER BY num DESC;
SELECT * FROM board WHERE title LIKE '%�ﱹ��%' ORDER BY num DESC;
--���ǿ� ���� ����Ǵ� ���ڵ尡 �ƿ� ���� ���� �ִ�.

COMMIT;

--selectView() �޼��� : �Խù��� ���� �󼼺���
/* board ���̺��� id�� ����Ǿ� �����Ƿ� �̸����� ����ϱ� ����
member ���̺�� join�� �ɾ �������� �����Ѵ�. */
SELECT *
    FROM board B INNER JOIN member M
        ON B.id = M.ID
WHERE num = 7; /* 2�� ���̺��� ��� �÷��� �����ͼ� �����Ѵ�. */

/* ���뺸�⿡�� ����� ���븸 �������� �ǹǷ� �Ʒ��� ���� ��Ī�� �̿��ؼ�
������ �÷��� �����Ѵ�. */
SELECT B.*, M.name
    FROM board B INNER JOIN member M
        ON B.id = M.ID
WHERE num = 11;

--JOIN�� ���� �����÷����� �����ϹǷ� USING���� �����ϰ� ǥ���� �� �ִ�.
SELECT *
    FROM board INNER JOIN member
        USING(id)
WHERE num = 11;

--updateVisitCount() �޼��� : �Խù� ��ȸ�� visitcount �÷��� 1�� ������Ű�� �۾�
UPDATE board SET visitcount = visitcount + 1 WHERE num = 2;
SELECT * FROM board;


--updateEdit() �޼��� : �Խù� �����ϱ�
UPDATE board
    set title = '�����׽�Ʈ', content = 'update������ �Խù��� �����غ��ϴ�.'
    WHERE num = 2;
SELECT * FROM board;
COMMIT;

/*
��1 �Խ����� ����¡ ��� �߰��� ���� ����������
*/
--1. board ���̺��� �Խù��� ������������ �����Ѵ�.
SELECT * FROM board ORDER BY num DESC;

--2. ������������ ���ĵ� ���¿��� rownum�� ���� �������� ��ȣ�� �ο��Ѵ�.
SELECT tb.*, rownum FROM (
    SELECT * FROM board ORDER BY num DESC) tb;

--3. ROWNUM�� ���� �� ���������� ����� �Խù��� ������ �����Ѵ�.
SELECT * FROM
    (SELECT tb.*, ROWNUM rNum FROM
       (SELECT * FROM board ORDER BY num DESC) tb
    )
--WHERE rNum >= 1 and rNum <= 10;
WHERE rNum >= 11 and rNum <= 20;
--WHERE rNum between 21 and 30;

/*4. �˻�� �ִ� ��쿡�� WHERE���� �������� �߰��ȴ�. LIKE���� ���� ������
�������� �߰��ϸ� �ȴ�. �˻� ���ǿ� �´� �Խù��� ������ �� ROWNUM��
�ο��ϰ� �ȴ�.*/
SELECT * FROM
    (SELECT tb.*, ROWNUM rNum FROM
       (SELECT * FROM board 
        WHERE title LIKE '%9��°%'
        ORDER BY num DESC) tb
    )
WHERE rNum >= 1 and rNum <= 20;

-----------------------�� 2��� ���̺�--------------------------
create table mvcboard (
    idx number primary key, /* �Ϸù�ȣ */
    name varchar2(50) not null, /* �ۼ��� �̸� */
    title varchar2(200) not null,/* ���� */
    content varchar2(2000) not null, /* ���� */
    postdate date default sysdate not null, /* �ۼ��� */
    ofile varchar2(200), /* ���� ���ϸ� */
    sfile varchar2(30), /* ������ ����� ���ϸ� */
    downcount number(5) default 0 not null, /* ���� �ٿ�ε� Ƚ�� */
    pass varchar2(50) not null, /* �н����� */
    visitcount number default 0 not null /* �Խù� ��ȸ�� */
);
--���� ������ �Է�
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����','1234');

commit;

SELECT * FROM mvcboard;

------------------------------------------------------------------------
/*
�鿣�� 2�� ������Ʈ : �ؽ������� ���� ������ ���� ���� ����
*/

ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER ngadmin IDENTIFIED BY ng1234;
GRANT CONNECT, RESOURCE, unlimited tablespace TO ngadmin;

SELECT * FROM member;

/* ���̺� �� ������ ������ ���� ���� ������ ��ü�� �ִٸ� ������ ������ ��
���Ӱ� �����Ѵ�. */
drop table member;
drop table free_board;
drop table download_board;
drop table qna_board;
drop table comments;
drop sequence seq_board_num;

--ȸ�� ���̺� ����
CREATE TABLE member (
    id varchar2(10) not null,
    pass varchar2(10) not null,
    name varchar2(30) not null,
    email varchar2(30) not null,
    phone_number varchar2(30) not null,
    primary key (id) /* id�÷��� �⺻Ű(PK)�� ����*/
);
ALTER TABLE member
ADD regidate DATE DEFAULT SYSDATE;

--�Խ��� ���̺� ����(�����Խ���, qna �Խ���, �ٿ�ε� �Խ������� ������) 07.18���� ����
CREATE TABLE free_board (
    idx number primary key, /* �Ϸù�ȣ */
    name varchar2(50) not null, /* �ۼ��� �̸� */
    title varchar2(200) not null,/* ���� */
    content varchar2(2000) not null, /* ���� */
    id varchar2(10) default 'test9999' not null,
    postdate date default sysdate not null, /* �ۼ��� */
    visitcount number default 0 not null /* �Խù� ��ȸ�� */
);
CREATE TABLE qna_board (
    idx number primary key, /* �Ϸù�ȣ */
    name varchar2(50) not null, /* �ۼ��� �̸� */
    title varchar2(200) not null,/* ���� */
    content varchar2(2000) not null, /* ���� */
    id varchar2(10) default 'test9999' not null,
    postdate date default sysdate not null, /* �ۼ��� */
    visitcount number default 0 not null /* �Խù� ��ȸ�� */
);
CREATE TABLE download_board (
    idx number primary key, /* �Ϸù�ȣ */
    name varchar2(50) not null, /* �ۼ��� �̸� */
    title varchar2(200) not null,/* ���� */
    content varchar2(2000) not null, /* ���� */   
    id varchar2(10) default 'test9999' not null,
    postdate date default sysdate not null, /* �ۼ��� */
    ofile varchar2(200), /* ���� ���ϸ� */
    sfile varchar2(30), /* ������ ����� ���ϸ� */
    downcount number(5) default 0 not null, /* ���� �ٿ�ε� Ƚ�� */
    visitcount number default 0 not null /* �Խù� ��ȸ�� */
);
CREATE TABLE comments (
    comm_idx number primary key, /* ����� �Ϸù�ȣ */
    board_idx number not null, /* ����� �ۼ��� �Խñ��� �Ϸù�ȣ */
    name varchar2(50) not null, /* �ۼ��� �̸� */
    content varchar2(1000) not null, 
    id varchar2(10) default 'test9999' not null,
    postdate date default sysdate not null,
    CONSTRAINT FK_comment FOREIGN KEY(board_idx) REFERENCES qna_board(idx)
);


--�ܷ�Ű ����
/*
�ڽ����̺��� board�� �θ����̺��� member�� �����ϴ� �ܷ�Ű�� �����Ѵ�.
board�� id �÷��� member�� �⺻Ű�� id �÷��� �����ϵ��� ���������� ����.
*/
alter table free_board
    add constraint board_mem_fk foreign key (id)
    references member (id); --�������Ǹ���� �����ؼ� �ܷ�Ű ������.

SELECT * FROM (SELECT Tb.*, ROWNUM rNum FROM (SELECT * FROM
    free_board ORDER BY idx DESC) Tb) WHERE rNum BETWEEN 1 AND 10;

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
    
insert into member (id, pass, name, email, phone_number) values
('musthave', '1234', '�ӽ�Ʈ�غ�', 'musthave@naver.com', '010-1111-2222');
insert into board (num, title, content, id, postdate, visitcount)
    values (
        seq_board_num.nextval, '����1�Դϴ�', 
        '����1�Դϴ�', 'musthave', sysdate, 0);

--Ŀ���ؼ� ���� ���̺� ����
commit;
delete from member where name like '%asd%';

--���� ������ �Է�
insert into free_board (idx, name, title, content)
    values (seq_board_num.nextval, '������', '�ڷ�� ����1 �Դϴ�.','����');
insert into free_board (idx, name, title, content)
    values (seq_board_num.nextval, '�庸��', '�ڷ�� ����2 �Դϴ�.','����');
insert into free_board (idx, name, title, content)
    values (seq_board_num.nextval, '�̼���', '�ڷ�� ����3 �Դϴ�.','����');
insert into free_board (idx, name, title, content)
    values (seq_board_num.nextval, '������', '�ڷ�� ����4 �Դϴ�.','����');
insert into free_board (idx, name, title, content)
    values (seq_board_num.nextval, '������', '�ڷ�� ����5 �Դϴ�.','����');

commit;

SELECT * FROM free_board;
SELECT COUNT(*) FROM free_board;

-- rownum���� ���
SELECT tb.*, rownum FROM (
    SELECT * FROM free_board ORDER BY idx DESC) tb;


--������ ����
--comments ���̺� �ߺ����� �ʴ� �Ϸù�ȣ�� �ο��Ѵ�.
create sequence seq_comments_num
    /* ����ġ, ���۰�, �ּڰ��� ��� 1�� ���� */
    increment by 1
    start with 1
    minvalue 1
    /* �ִ�, cycle, cache�޸� ����� ��� no�� ���� */
    nomaxvalue
    nocycle
    nocache;
-- INSERT comments dummy data
insert into comments (comm_idx, board_idx, name, content, id)
    values (seq_comments_num.nextval, 21, '�ӽ�Ʈ�غ�',
    'Test Comment 1234', 'musthave');
    
SELECT * FROM (SELECT Tb.*, ROWNUM rNum FROM (
				 SELECT * FROM comments where board_idx = 21
				 ORDER BY comm_idx)
			     Tb) WHERE rNum BETWEEN 0 AND 10;
                 
delete from comments where comm_idx = 22;
delete from member where id like'%123%';
SELECT COUNT(*) FROM comments WHERE board_idx = 24;



--------------------------------------------------------------------
--2024.08.12
--JDBC > Callable Statement �������̽� ����ϱ�

--Study �������� �н��մϴ�.

--���� 1-1]�Լ� :  fillAsterisk()
/*
�ó�����] �Ű������� ȸ�����̵�(���ڿ�)�� ������ ù ���ڸ� ������ ������ �κ���
        '*'�� ��ȯ�ϴ� �Լ��� �����Ͻÿ�.
        ���� ��) oracle21c => o********
*/
--SUBSTR(���ڿ� Ȥ�� �÷�, ���� �ε���, ����) : ���� �ε������� ���̸�ŭ �߶󳻴� �޼���
SELECT SUBSTR('hongildong', 1, 1) FROM dual;
--RPAD(���ڿ� Ȥ�� �÷�, ����, ä�� ����) : ���ڿ��� ���� ���̸� ���ڷ� ä���.
SELECT RPAD('h', 10, '*') FROM dual;
/* ���ڿ�(���̵�)�� ù ���ڸ� ������ ������ �κ��� '*'�� ä���.
  ���̵� �Խ��ǿ� ����� �� ����(����ŷ)ó���� �� Ȱ���� �� �ִ�.*/
SELECT RPAD(SUBSTR('hongildong', 1, 1), LENGTH('hongildong'), '*')
FROM dual;

-- �Լ� ����
CREATE OR REPLACE FUNCTION fillAsterisk(
    idStr VARCHAR2 /* ���Ķ���ʹ� ���������� ����*/
)
RETURN VARCHAR2 /* ��ȯŸ�Ե� ���������� ���� */
IS retStr VARCHAR2(50);
BEGIN
    -- ���̵� ���� ó���ϱ� ���� ��� ����
    retStr := RPAD(SUBSTR(idstr, 1, 1), LENGTH(idstr), '*');
    RETURN retStr;
END;
/
--������ ���ڿ��� ����ŷ ó�� �Ǵ��� Ȯ��
SELECT fillAsterisk('hongildong') FROM dual;
SELECT fillAsterisk('oracle21c') FROM dual;

--������ �Լ��� ��� ���̺� ������ �� �ִ�.
SELECT * FROM member;
--member ���̺��� id �÷��� hidden ó���Ѵ�.
SELECT fillAsterisk(id) FROM member;

--����2-1] ���ν��� : MyMemberInsert()
/*
�ó�����] member ���̺� ���ο� ȸ�������� �Է��ϴ� ���ν����� �����Ͻÿ�
    �Ķ���� : In => ���̵�, �н�����, �̸�
                    Out => returnVal(����:1, ����:0)
*/
CREATE OR REPLACE PROCEDURE MyMemberInsert(
    /* Java���� �Է��� ������ ���� ���Ķ���� ���� */
    p_id IN VARCHAR2,
    p_pass IN VARCHAR2,
    p_name IN VARCHAR2,
    /* �Է¼��� ���θ� ��ȯ�� ���� ������ �ƿ��Ķ���� */
    returnVal OUT NUMBER
)
IS
BEGIN
    --���Ķ���͸� ���� INSERT ������ �ۼ�
    INSERT INTO MEMBER (id, pass, name)
        VALUES (p_id, p_pass, p_name);
    
    -- �Է��� ���������� ó���Ǹ� TRUE�� ��ȯ�Ѵ�.    
    IF SQL%found THEN
        -- �Է¿� ������ ���� ������ ���ͼ� �ƿ��Ķ���Ϳ� �����Ѵ�.
        returnVal := SQL%rowCount;
        -- ���� ��ȭ�� ����Ƿ� �ݵ�� COMMIT �ؾ� �Ѵ�.
        COMMIT;
    ELSE
        -- ������ ��쿡�� 0�� ��ȯ�Ѵ�.
        returnVal := 0;
    END IF;
    -- ���ν����� ������ RETURN ���� �ƿ��Ķ���Ϳ� ���� �Է��ϱ⸸ �ϸ� �ȴ�.
END;
/

--SET SERVEROUTPUT ON;

-- ���ε� ���� ����
VAR i_result VARCHAR2(10);
EXECUTE MyMemberInsert('pro01', '1234', '���ν���1', :i_result);
EXECUTE MyMemberInsert('pro02', '1234', '���ν���2', :i_result);
-- ���Ȯ��
PRINT i_result;
-- ���ڵ尡 �ԷµǾ����� Ȯ��
SELECT * FROM member;

--����3-1] ���ν��� : MyMemberDelete()
/*
�ó�����] member���̺��� ���ڵ带 �����ϴ� ���ν����� �����Ͻÿ�
    �Ķ���� : In => member_id(���̵�)
                    Out => returnVal(SUCCESS/FAIL ��ȯ)   
*/
CREATE OR REPLACE PROCEDURE MyMemberDelete(
    /* ���Ķ���� : ������ ���̵� */
    member_id IN VARCHAR2,
    /* �ƿ��Ķ���� : ���� ��� */
    returnVal OUT VARCHAR2
)
IS
BEGIN
    -- ���Ķ���ͷ� ���޵� ���̵� �����ϴ� DELETE ������
    DELETE FROM member WHERE id = member_id;
    
    IF SQL%Found THEN
        -- ȸ�� ���ڵ尡 ���������� �����Ǹ�..
        returnVal := 'SUCCESS';
        -- COMMIT �Ѵ�.
        COMMIT;
    ELSE
        -- ���ǿ� ��ġ�ϴ� ���ڵ尡 ���ٸ� FAIL �� ��ȯ�Ѵ�.
        returnVal := 'FAIL';
    END IF;
END;
/

-- ���ε� ���� ���� �� ���ν��� ����, ��� Ȯ��
VAR delete_var VARCHAR2(10);
EXECUTE MyMemberDelete('pro02', :delete_var);
PRINT delete_var; -- ���̵� �����ϴ� ��� SUCCESS
EXECUTE MyMemberDelete('test99', :delete_var);
PRINT delete_var; -- ���̵� ������ FAIL

--����4-1] ���ν��� : MyMemberAuth()
/*
�ó�����] ���̵�� �н����带 �Ű������� ���޹޾Ƽ� ȸ������ ���θ� �Ǵ��ϴ� ���ν����� �ۼ��Ͻÿ�. 
    �Ű����� : 
        In -> user_id, user_pass
        Out -> returnVal
    ��ȯ�� : 
        0 -> ȸ����������(�Ѵ�Ʋ��)
        1 -> ���̵�� ��ġ�ϳ� �н����尡 Ʋ�����
        2 -> ���̵�/�н����� ��� ��ġ�Ͽ� ȸ������ ����
    ���ν����� : MyMemberAuth
*/
CREATE OR REPLACE PROCEDURE MyMemberAuth(
    /* ���Ķ���� : Java���� �Է¹��� ���̵�, �н����� */
    user_id IN VARCHAR2,
    user_pass IN VARCHAR2,
    /* �ƿ��Ķ���� : ȸ������ ���θ� �Ǵ��� �� ��ȯ�� �� */
    returnVal OUT NUMBER
)
IS
    -- count(*)�� ���� ��ȯ�Ǵ� ���� ����
    member_count NUMBER(1):= 0;
    -- ��ȸ�� ȸ�������� �н����带 ����
    member_pw VARCHAR2(50);
BEGIN
    -- �ش� ���̵� �����ϴ��� �Ǵ��ϴ� SELECT ������
    SELECT COUNT(*) INTO member_count
    FROM member WHERE id = user_id;
    -- ȸ�� ���̵� �����ϴ� �����...
    IF member_count = 1 THEN
        --�н����� Ȯ���� ���� �ι�° ������ ����
        SELECT pass INTO member_pw
            FROM MEMBER WHERE id = user_id;
        -- ���Ķ���ͷ� ���޵� ��й�ȣ�� DB���� ������ ��й�ȣ ��    
        IF member_pw = user_pass THEN
            -- ��� ��ġ�ϴ� ���
            returnVal := 2;
        ELSE
            -- ���̵� ��ġ�ϴ� ���(��й�ȣ Ʋ��)
            returnVal := 1;
        END IF;
    ELSE
        --ȸ�������� Ʋ�� ���
        returnVal := 0;
    END IF;
END;
/
-- ���ε� ���� ����
VARIABLE member_auth NUMBER;

EXECUTE MyMemberAuth('hi', '1234', :member_auth);
/* �Ѵ� ��ġ�ϴ� ��� 2 */
PRINT member_auth; 

EXECUTE MyMemberAuth('hi', '1234��ȣƲ��', :member_auth);
/* ���̵� ��ġ�ϴ� ��� 1 */
PRINT member_auth; 

EXECUTE MyMemberAuth('hi���̵�Ʋ��', '1234', :member_auth);
/* ȸ�������� ���� ��� 0 */
PRINT member_auth;


