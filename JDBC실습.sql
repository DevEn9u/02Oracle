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
