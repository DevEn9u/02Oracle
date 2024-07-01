/***********
���ϸ� : Or12Sequence&Index.sql
������ & �ε���
���� : ���̺��� �⺻�� �ʵ忡 �������� �Ϸù�ȣ�� �ο��ϴ� ��������
    �˻��ӵ��� ����ų �� �ִ� �ε���
***********/

--Study �������� �н��մϴ�.

/*
������(Sequence)
- ���̺��� �÷�(�ʵ�)�� �ߺ����� �ʴ� �������� �Ϸù�ȣ�� �ο��Ѵ�.
- �������� ���̺� ���� �� ������ ������ �Ѵ�. �� �������� ���̺��
    ���������� ����ǰ� �����ȴ�.
    
[������ ��������]
create sequence ��������
    [Increment by N] => ����ġ ����
    [Start with N] => ���۰� ����
    [Minvalue n | NoMinvalue] => ������ �ּڰ� ���� : default1
    [Maxvalue n | NoMaxvalue] => ������ �ִ� ���� : default1.00E + 28
    [Cycle | NoCycle] => �ִ�/�ּҰ��� ������ ��� ó������ �ٽ�
                        �������� ���θ� ����(cycle�� �����ϸ� �ִ񰪱���
                        ������ �ٽ� ���۰����� ����۵�)
    [Cache | NoCache => cache �޸𸮿� ����Ŭ������ ����������
                        �Ҵ��ϴ°� ���θ� ����               

������ ������ ���ǻ���
1) start with�� minvalue���� ���� ���� ������ �� ����. �� start with����
minvalue�� ���ų� Ŀ�� �Ѵ�.
2) nocycle�� �����ϰ� �������� ��� ���� �� maxvalue�� ��������
�ʰ��ϸ� ������ �߻��Ѵ�.
3) primary key���� cycle �ɼ��� ���� �����ϸ� �ȵȴ�.
*/

create table tb_goods (
    idx number(10) primary key,
    g_name varchar2(30)
);
insert into tb_goods values (1, '��Ϲ���Ĩ');
-- idx�� PK�� ������ �÷��̹Ƿ� �ߺ����� �ԷµǸ� ���� �߻���
insert into tb_goods values (1, '���±�');

--������ ����
CREATE SEQUENCE seq_serial_num
    INCREMENT BY 1  /* ����ġ : 1 */
    START WITH 100  /* �ʱⰪ(���۰�) : 100 */
    MINVALUE 99     /* �ּڰ� : 99 */
    MAXVALUE 110    /* �ִ� : 110 */
    CYCLE           /* �ִ� ���޽� �ּڰ����� ��������� ���� : Yes */
    NOCACHE;        /* ĳ�ø޸� ��� ���� : No */

--�����ͻ������� ������ ������ ���� Ȯ��
SELECT * FROM user_sequences;
/* ������ ���� �� ���� ����ÿ��� CURRVAL�� ������ �� ���� ������ �߻��Ѵ�.
NEXTVAL�� ���� �����ؼ� �������� ���� �� ����ؾ� �Ѵ�. */
SELECT seq_serial_num.CURRVAL FROM dual;
/* ���� �Է��� �������� ��ȯ�Ѵ�. ������ ������ ������ ����ġ��ŭ ������
���� ��ȯ�ȴ�. */
SELECT seq_serial_num.NEXTVAL FROM dual;
/*
�������� NEXTVAL�� ����ϸ� ��� ���ο� ���� ��ȯ�ϹǷ� �Ʒ��� ����
INSERT���� ����� �� �ִ�. ���� ���� ������ ������ �����ϴ��� ��������
�Էµȴ�.
*/
insert into tb_goods values (seq_serial_num.NEXTVAL, '���±�');
/*
��, �������� CYCLE �ɼǿ� ���� �ִ񰪿� �����ϸ� �ٽ� ó������ ����������
�����ǹǷ� ���Ἲ ���� ���ǿ� ����Ǿ� ������ �߻��Ѵ�.
�� PK �÷��� ����� �������� CYCLE �ɼ��� ����ϸ� �ȵȴ�.
*/
SELECT * FROM tb_goods;

/*
������ ���� : ���̺�� �����ϰ� ALTER ��ɾ� ���
    ��, START WITH�� ������ �� ����.

����] ALTER SEQUENCE ��������
        [Increment by N] => ����ġ ����
        [Minvalue n | NoMinvalue]
        [Maxvalue n | NoMaxvalue] 
        [Cycle | NoCycle]
        [Cache | NoCache
*/
ALTER SEQUENCE seq_serial_num
    INCREMENT BY 1
    MINVALUE 99
    NOMAXVALUE /* �ִ��� ������� ���� => �������� ǥ���� �� �ִ� �ִ���� ��� */
    NOCYCLE /* CYCLE ������� ���� */
    NOCACHE; /* CACHE �޸� ������� ���� */

--������ ����
DROP SEQUENCE seq_serial_num;
SELECT * FROM user_sequences;

/*
�Ϲ����� ������ ������ �Ʒ��� ���� �ϸ� �ȴ�.
PK�� ������ �÷��� �Ϸù�ȣ�� �Է��ϴ� �뵵�� �ַ� ���ǹǷ�
MAXVALUE, CYCLE, CACHE�� ������� �ʴ� ���� �����Ѵ�.
*/
CREATE SEQUENCE seq_serial_num
    INCREMENT BY 1
    START WITH 1
    MINVALUE 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

/*
�ε���(INDEX)
- ���� �˻��ӵ��� ����ų �� �ִ� ��ü
- �ε����� �����(CREATE INDEX)�� �ڵ���(PRIMARY KEY, UNIQUE)����
    ������ �� �ִ�.
- �÷��� ���� �ε����� ������ ���̺� ��ü�� �˻��Ѵ�.
- �� �ε����� ������ ������ ����Ű�� ���� �����̴�.
- �ε����� �Ʒ��� ���� ��켼 �����Ѵ�.
    1) WHERE �����̳� JOIN ���ǿ� ���� ����ϴ� �÷�
    2) �������� ���� �����ϴ� �÷�
    3) ���� NULL���� �����ϴ� �÷�
*/

--�ε��� ����
CREATE INDEX tb_goods_name_idx ON tb_goods (g_name);
/* ������ �������� �ε��� ���� Ȯ��. ����� ���� PK Ȥ�� UNIQUE��
������ �÷��� �ڵ����� �ε����� �����Ǿ� �ִ� ���� �� �� �ִ�. */
SELECT * FROM user_ind_columns;
--�ε��� ����
DROP INDEX tb_goods_name_idx;
/*
    �ε����� ������ �Ұ����ϴ�. �ʿ��ϴٸ� ���� �� �ٽ� �����ؾ� �Ѵ�.
*/
