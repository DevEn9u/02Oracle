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
