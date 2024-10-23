-- �ʱ�ȭ�� �ڵ� (���� ����)
-- Ʈ���� ����
BEGIN
    FOR rec IN (SELECT trigger_name FROM user_triggers) LOOP
        EXECUTE IMMEDIATE 'DROP TRIGGER ' || rec.trigger_name;
    END LOOP;
END;
/

-- ������ ����
BEGIN
    FOR rec IN (SELECT sequence_name FROM user_sequences) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || rec.sequence_name;
    END LOOP;
END;
/

-- ���̺� ����
BEGIN
    FOR rec IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || rec.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

-- ���Ÿ���� authority�� ����, enabled�߰���
-- ȸ�� ���̺� (MEMBER)
CREATE TABLE MEMBER (
    id VARCHAR2(20) NOT NULL,         -- ����� ID
    name VARCHAR2(60) NOT NULL,       -- ����� �̸�, ��ȣ��
    email VARCHAR2(30) NOT NULL,      -- �̸���
    pass VARCHAR2(80) NOT NULL,       -- ��й�ȣ
    authority VARCHAR2(20) NOT NULL,  -- ȸ�� ���� �� ���Ѻο� (����(admin), �Ϲ�(normal), ���(corp))
                                      -- ������ �Է½� ROLE_ADMIN ������ 'ROLE_����'���� �Է��ؾ���
    phone VARCHAR2(30) NOT NULL,      -- ����ó
    business_number VARCHAR2(30),      -- ����ڹ�ȣ (�Ϲ� ȸ���� null)
    point NUMBER(3, 0) DEFAULT 0,     -- ����Ʈ (��� ȸ���� null)
    enabled NUMBER(1, 0) DEFAULT 1,   -- ���� Ȱ��ȭ ���� (1 - Ȱ��ȭ, 0 - ��Ȱ��ȭ)
                                      -- Spring Security ����� ���� �ʼ���
    PRIMARY KEY (id)                   -- id �÷��� �⺻ Ű�� ����
);

-- ȸ�� ���̺� ���� Ȯ��
SELECT * FROM MEMBER;

-- �Խ��� ���̺� (BOARD)
CREATE TABLE BOARD (
    board_idx VARCHAR2(20) NOT NULL,   -- �Խñ� �Ϸù�ȣ (������ ���)
    board_title VARCHAR2(50) NOT NULL,  -- ����
    postdate DATE DEFAULT SYSDATE NOT NULL, -- �ۼ� ��¥ (���� �ð����� �⺻�� ����)
    contents VARCHAR2(2000) NOT NULL,   -- ��Ÿ �����
    images VARCHAR2(200),                -- ÷�� �̹��� (�ٿ�ε� ����� ���� ����)
    writer VARCHAR2(20) NOT NULL,        -- �Խñ� �ۼ��� (member ���̺��� id ����)
    visitcount NUMBER(5, 0) DEFAULT 0,  -- �Խñ� ��ȸ��
    board_type VARCHAR2(10) NOT NULL,    -- �Խñ� ���� (����, ����)
    role VARCHAR2(20) NOT NULL,          -- �Խ��� ���� ���� (�����Խ��ǿ� admin�� ���� �ο�)
    PRIMARY KEY (board_idx),             -- board_idx �÷��� �⺻ Ű�� ����
    FOREIGN KEY (writer) REFERENCES MEMBER(id) -- writer �÷��� MEMBER ���̺��� id�� �ܷ� Ű ���� ����
);

-- �Խñ� �Ϸù�ȣ ������ ���� ������
CREATE SEQUENCE board_seq
    START WITH 1  -- ���� ��
    INCREMENT BY 1  -- ���� ��
    NOCACHE;  -- ĳ�� ��� �� ��
    
-- BOARD ���̺� ���ο� �Խñ��� �߰��� �� board_idx �ڵ� ����
CREATE OR REPLACE TRIGGER trg_board_before_insert
BEFORE INSERT ON BOARD
FOR EACH ROW
BEGIN
    IF :NEW.board_idx IS NULL THEN
        SELECT board_seq.NEXTVAL INTO :NEW.board_idx FROM dual;
    END IF;
END;
/

-- �Խ��� ���̺� ���� Ȯ��
SELECT * FROM BOARD;

-- �˾� �Խ��� ���̺� (POPUP_BOARD)
CREATE TABLE POPUP_BOARD (
    board_idx VARCHAR2(20) PRIMARY KEY,         -- �Խñ� �Ϸù�ȣ, �⺻ Ű (������ ���)
    board_title VARCHAR2(100) NOT NULL,          -- ����
    postdate DATE DEFAULT SYSDATE NOT NULL,     -- �ۼ� ��¥ (�⺻��: ���� ��¥)
    start_date VARCHAR2(10),                    -- �˾� ���� ���� ��¥
    end_date VARCHAR2(10),                      -- �˾� ���� ������ ��¥
    contents VARCHAR2(2000) NOT NULL,           -- ��Ÿ �����
    popup_addr VARCHAR2(100),                     -- �˾� �ּ���
    thumb VARCHAR2(200),                         -- �Խñ� ��Ͽ� ǥ���� �����
    category VARCHAR2(30),                       -- �Խñ� �˻��� ī�װ�
    writer VARCHAR2(20) NOT NULL,               -- �Խñ� �ۼ��� (member ���̺��� id ����)
    visitcount NUMBER(5, 0) DEFAULT 0,         -- �Խñ� ��ȸ�� (�⺻��: 0)
    role VARCHAR2(20) NOT NULL,                 -- �Խ��� ��� �� ���� (����(admin), ���(corp)�� �ο�)
    popup_fee NUMBER(5, 0) DEFAULT 0,          -- �˾������ ����� (�⺻��: 0)
    likes_count NUMBER(5, 0) DEFAULT 0,          -- ���ƿ� ���� (�⺻��: 0)
    open_days VARCHAR2(50),
    open_hours VARCHAR2(50),
    FOREIGN KEY (writer) REFERENCES MEMBER(id) -- writer �÷��� MEMBER ���̺��� id�� �ܷ� Ű ���� ����
    
);

-- �˾� �Խñ� �Ϸù�ȣ ������ ���� ������
CREATE SEQUENCE popup_board_idx_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- POPUP_BOARD ���̺� ���ο� �˾� �Խñ��� �߰��� �� board_idx �ڵ� ����
CREATE OR REPLACE TRIGGER trg_popup_board_idx
BEFORE INSERT ON POPUP_BOARD
FOR EACH ROW
BEGIN
    IF :NEW.board_idx IS NULL THEN
        SELECT popup_board_idx_seq.NEXTVAL INTO :NEW.board_idx FROM dual;
    END IF;
END;
/

-- �˾� �Խ��� ���̺� ���� Ȯ��
SELECT * FROM POPUP_BOARD;

-- ��� ���̺� (COMMENTS)
CREATE TABLE COMMENTS (
    com_idx VARCHAR2(20) PRIMARY KEY,             -- ��� �Ϸù�ȣ, �⺻ Ű (������ ���)
    board_idx VARCHAR2(20),                        -- �Խñ� �Ϸù�ȣ (boards ���̺��� board_idx ����)
    popup_board_idx VARCHAR2(20),                  -- �˾� �Խñ� �Ϸù�ȣ (popup_board ���̺��� board_idx ����)
    com_writer VARCHAR2(20) NOT NULL,             -- ��� �ۼ��� (member ���̺��� id ����)
    com_contents VARCHAR2(2000) NOT NULL,         -- ��� ����
    com_postdate DATE DEFAULT SYSDATE NOT NULL,  -- ��� �ۼ� ��¥ (�⺻��: ���� ��¥)
    com_img VARCHAR2(40),                          -- ���信 ÷���� �̹���
    CONSTRAINT chk_comment_type CHECK (
        (board_idx IS NOT NULL AND popup_board_idx IS NULL) OR 
        (board_idx IS NULL AND popup_board_idx IS NOT NULL)
    ),  -- ����� �ݵ�� �ϳ��� �Խñ۸� �����ؾ� ��
    FOREIGN KEY (board_idx) REFERENCES BOARD(board_idx) ON DELETE CASCADE,   -- board_idx �ܷ� Ű ����
    FOREIGN KEY (popup_board_idx) REFERENCES POPUP_BOARD(board_idx) ON DELETE CASCADE, -- popup_board_idx �ܷ� Ű ����
    FOREIGN KEY (com_writer) REFERENCES MEMBER(id) -- com_writer �ܷ� Ű ����
);


-- ��� �Ϸù�ȣ ������ ���� ������
CREATE SEQUENCE comment_idx_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- COMMENTS ���̺� ���ο� ����� �߰��� �� com_idx �ڵ� ����
CREATE OR REPLACE TRIGGER trg_comment_idx
BEFORE INSERT ON COMMENTS
FOR EACH ROW
BEGIN
    IF :NEW.com_idx IS NULL THEN
        SELECT comment_idx_seq.NEXTVAL INTO :NEW.com_idx FROM dual;
    END IF;
END;
/

-- ��� ���̺� ���� Ȯ��
SELECT * FROM COMMENTS;

-- ���ƿ� ���̺� (LIKES)
CREATE TABLE LIKES (
    likes_idx VARCHAR2(20) PRIMARY KEY,          -- ���ƿ� �Ϸù�ȣ, �⺻ Ű
    member_id VARCHAR2(20),                       -- ���ƿ並 ���� ȸ�� ID (member ���̺� ����)
    board_id VARCHAR2(20),                         -- ���ƿ� ��� �Խñ� �Ϸù�ȣ (board ���̺� ����)
    FOREIGN KEY (member_id) REFERENCES MEMBER (id), -- ���ƿ� ���̺� ȸ�� ID �ܷ� Ű �߰�
    FOREIGN KEY (board_id) REFERENCES POPUP_BOARD (board_idx) -- ���ƿ� ���̺� �Խñ� ID �ܷ� Ű �߰�
);

-- ���ƿ� �Ϸù�ȣ ������ ���� ������
CREATE SEQUENCE likes_idx_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- ���ƿ� ���̺� ���ο� ���ƿ䰡 �߰��� �� likes_idx �ڵ� ����
CREATE OR REPLACE TRIGGER trg_likes_idx
BEFORE INSERT ON LIKES
FOR EACH ROW
BEGIN
    IF :NEW.likes_idx IS NULL THEN
        SELECT likes_idx_seq.NEXTVAL INTO :NEW.likes_idx FROM dual;
    END IF;
END;
/

-- ���ƿ� ���̺� ���� Ȯ��
SELECT * FROM LIKES;

-- �̹��� ���̺� (IMAGES)
CREATE TABLE IMAGES (
    image_idx VARCHAR2(20) PRIMARY KEY,
    image_url VARCHAR2(255) NOT NULL,
    image_type VARCHAR2(20) NOT NULL,
    associated_id VARCHAR2(20) NOT NULL,
    upload_date DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT chk_image_type CHECK (image_type IN ('BOARD', 'POPUP', 'COMMENT'))
);

-- �̹��� �Ϸù�ȣ ������ ���� ������
CREATE SEQUENCE image_idx_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- IMAGES ���̺� ���ο� �̹����� �߰��� �� image_idx �ڵ� ����
CREATE OR REPLACE TRIGGER trg_image_idx
BEFORE INSERT ON IMAGES
FOR EACH ROW
BEGIN
    IF :NEW.image_idx IS NULL THEN
        SELECT image_idx_seq.NEXTVAL INTO :NEW.image_idx FROM dual;
    END IF;
END;
/
-- �̹��� ���̺� ���� Ȯ��
SELECT * FROM IMAGES;

-- ���̺� ��� Ȯ��
SELECT table_name FROM user_tables;
-- ������ ��� Ȯ��
SELECT sequence_name FROM user_sequences;
-- Ʈ���� ��� Ȯ��
SELECT trigger_name FROM user_triggers;


--���̺� �׽�Ʈ�� ���̵�����
-- MEMBER ���̺� ���� ������ �߰�
-- ��й�ȣ�� qwer1234
INSERT INTO MEMBER (id, name, email, pass, authority, phone, business_number, point, enabled) VALUES
('user01', 'ȫ�浿', 'user01@example.com', '$2a$10$jFhRboc.PRJxz4yHLvTXbes0IHodjKa/iObQQyhef1n0d/6AGAvaa', 'ROLE_NORMAL', '010-1234-5678', NULL, 0, 1);
INSERT INTO MEMBER (id, name, email, pass, authority, phone, business_number, point, enabled) VALUES
('admin', 'admin', 'user02@example.com', '$2a$10$jFhRboc.PRJxz4yHLvTXbes0IHodjKa/iObQQyhef1n0d/6AGAvaa', 'ROLE_ADMIN', '010-2345-6789', NULL, 0, 1);
INSERT INTO MEMBER (id, name, email, pass, authority, phone, business_number, point, enabled) VALUES
('user03', '�̿���', 'user03@example.com', '$2a$10$jFhRboc.PRJxz4yHLvTXbes0IHodjKa/iObQQyhef1n0d/6AGAvaa', 'ROLE_CORP', '010-3456-7890', '123-45-67890', 0, 1);

-- BOARD ���̺� ���� ������ �߰�
INSERT INTO BOARD (board_idx, board_title, postdate, contents, images, writer, visitcount, board_type, role) VALUES
(NULL, '�����Խ��� ù ��° ��', SYSDATE, '�����Խ��ǿ� ���� ���� ȯ���մϴ�!', NULL, 'user01', 0, '����', 'ROLE_NORMAL');
INSERT INTO BOARD (board_idx, board_title, postdate, contents, images, writer, visitcount, board_type, role) VALUES
(NULL, '��������: ���� �ȳ�', SYSDATE, '���� ������ ����˴ϴ�. ���� �ٶ��ϴ�.', NULL, 'admin', 0, '����', 'ROLE_ADMIN');

-- POPUP_BOARD ���̺� ���� ������ �߰�
INSERT INTO POPUP_BOARD (board_idx, board_title, postdate, start_date, end_date, contents, popup_addr, thumb, category, writer, visitcount, role, popup_fee, likes_count) VALUES
(NULL, 'Ư�� �˾� �̺�Ʈ', SYSDATE, '2024-10-14', '2024-10-30', 'Ư�� �̺�Ʈ�� �����ϼ���!', '����Ư���� ���α�', '/uploads/images/598019c9-84b1-44d8-a65f-b9b8529efc1b.jpg', '�̺�Ʈ', 'user01', 0, 'ROLE_NORMAL', 0, 0);
INSERT INTO POPUP_BOARD (board_idx, board_title, postdate, start_date, end_date, contents, popup_addr, thumb, category, writer, visitcount, role, popup_fee, likes_count) VALUES
(NULL, '����ǰ ��� �ȳ�', SYSDATE, '2024-10-14', '2024-10-30', '����ǰ�� Ȯ���ϼ���!', '�λ걤����', '/uploads/images/59b2cb9f-8971-4bd5-b9cb-bf5c088ee40d.jpg', '��ǰ', 'user02', 0, 'ROLE_ADMIN', 0, 0);
INSERT INTO POPUP_BOARD (board_idx, board_title, postdate, start_date, end_date, contents, popup_addr, thumb, category, writer, visitcount, role, popup_fee, likes_count) VALUES
(NULL, '���� ���� �ȳ�', SYSDATE, '2024-10-14', '2024-10-30', '���� ���Ͽ� ���� ���� �ٶ��ϴ�!', '�뱸������', '/uploads/images/598019c9-84b1-44d8-a65f-b9b8529efc1b.jpg', '����', 'user03', 0, 'ROLE_CORP', 0, 0);

-- COMMENTS ���̺� ���� ������ �߰�
INSERT INTO COMMENTS (com_idx, board_idx, popup_board_idx, com_writer, com_contents, com_postdate, com_img) VALUES
(NULL, '1', NULL, 'admin', 'ù ��° �ۿ� ����� ����ϴ�.', SYSDATE, NULL);
INSERT INTO COMMENTS (com_idx, board_idx, popup_board_idx, com_writer, com_contents, com_postdate, com_img) VALUES
(NULL, '2', NULL, 'user01', '���� �ȳ� �� �ý��ϴ�.', SYSDATE, NULL);
INSERT INTO COMMENTS (com_idx, board_idx, popup_board_idx, com_writer, com_contents, com_postdate, com_img) VALUES
(NULL, '3', NULL, 'user03', '�� ��° �� �ʹ� �����ϳ׿�!', SYSDATE, NULL);

-- LIKES ���̺� ���� ������ �߰�
INSERT INTO LIKES (likes_idx, member_id, board_id) VALUES
(NULL, 'user01', '1');
INSERT INTO LIKES (likes_idx, member_id, board_id) VALUES
(NULL, 'admin', '2');
INSERT INTO LIKES (likes_idx, member_id, board_id) VALUES
(NULL, 'user03', '3');


-- �������� ���̺� ����
CREATE TABLE BOOKING (
    booking_num VARCHAR2(20) PRIMARY KEY,           -- �����ȣ (6�ڸ� ���� ����)
    popup_idx VARCHAR2(20),                         -- �˾��Խù� �Ϸù�ȣ (NOT NULL�� �����ؾ���)
    member_id VARCHAR2(20) NOT NULL,                -- �α����� ������ ���̵�
    visit_date DATE NOT NULL,                       -- �˾� ���� ��¥
    booking_date DATE DEFAULT SYSDATE NOT NULL,     -- ���� ������
    price NUMBER(5,0) DEFAULT 0,                    -- �ο������� ��ģ �� ����
    headcount NUMBER(2,0) DEFAULT 1,                -- �ο� ��
    is_paid NUMBER(2,0) DEFAULT 0,                  -- ���� ���� ���� ��(0�϶� �����̿Ϸ� / 1�϶� �����Ϸ�)
    is_canceled NUMBER(2,0) DEFAULT 0               -- ��� ���� ( ��� �� 1 )
);

-- ���� �Ϸù�ȣ�� ���� ���� �����Ͽ� �ִ� �Լ�
CREATE OR REPLACE FUNCTION booking_num_seq
RETURN NUMBER IS
    rand_num NUMBER;
    count_num NUMBER;
BEGIN
    LOOP
        rand_num := TRUNC(DBMS_RANDOM.VALUE(100000, 999999)); -- 6�ڸ� �������� ����
        -- �ߺ��� ���� ��� count_num = 1
        SELECT COUNT(*) INTO count_num FROM BOOKING WHERE booking_num = rand_num;
        -- �ߺ�Ȯ��
        EXIT WHEN count_num = 0;
    END LOOP;
    RETURN rand_num;
END;
/

-- popup_idx �ܷ�Ű �߰�
ALTER TABLE BOOKING
ADD CONSTRAINT fk_popup_idx
FOREIGN KEY (popup_idx) REFERENCES POPUP_BOARD(board_idx) ON DELETE CASCADE;
-- member_id �ܷ�Ű �߰�
ALTER TABLE BOOKING
ADD CONSTRAINT fk_member_id
FOREIGN KEY (member_id) REFERENCES MEMBER(id) ON DELETE CASCADE;
-- �˾� ������ �������� popup_title �߰�
ALTER TABLE BOOKING
ADD popup_title VARCHAR2(100);

SELECT b.*, pb.board_title AS popup_title
FROM BOOKING b
JOIN POPUP_BOARD pb ON b.popup_idx = pb.board_idx;



-- ���̵����� �Է�
INSERT INTO BOOKING (booking_num, popup_idx, member_id, visit_date, booking_date, price, headcount, is_paid, is_canceled, popup_title)
VALUES
(booking_num_seq, NULL, 'user01', sysdate, sysdate, 0, 2, 0, 0, '���̵�����');

SELECT * FROM BOOKING;

COMMIT;

/**************************************/
-- ����Ʈ ���̺�
CREATE TABLE point (
    p_user VARCHAR2(20) NOT NULL,  -- ����Ʈ�� ���/������ ���� (member ���̺��� id ����)
    p_change NUMBER(4, 0) NOT NULL, -- ����� ����Ʈ (��� �Ǵ� ����)
    p_change_date DATE NOT NULL,     -- ����Ʈ ���� �Ͻ�
    CONSTRAINT pk_point PRIMARY KEY (p_user, p_change_date), -- ���� �⺻Ű ���� (������ ���� �Ͻ� ����)
    CONSTRAINT fk_member FOREIGN KEY (p_user) REFERENCES member(id) -- member ���̺���� �ܷ�Ű ����
);

ALTER TABLE member
MODIFY (point NUMBER(5, 0));


ALTER TABLE member
ADD register_date DATE DEFAULT sysdate;

--������ ���̺�
CREATE TABLE coupon_shop (
    coupon_idx VARCHAR2(30) PRIMARY KEY,             -- ���� �Ϸ� ��ȣ (�⺻ Ű)
    coupon_name VARCHAR2(50) NOT NULL,               -- ���� �̸�
    coupon_description VARCHAR2(200) NOT NULL,       -- ���� ����
    image_url VARCHAR2(255),                         -- ���� �̹��� URL
    points NUMBER(5,0) NOT NULL,                     -- ���� ���� (����Ʈ)
    expiry_date DATE                                 -- ���� ��� ���� ����
);
-- ��ȿ�Ⱓ�� ���ϴ� Ʈ���� ����
CREATE OR REPLACE TRIGGER trg_set_expiry_date
BEFORE INSERT ON coupon_shop
FOR EACH ROW
BEGIN
    IF :NEW.expiry_date IS NULL THEN
        :NEW.expiry_date := ADD_MONTHS(SYSDATE, 1);
    END IF;
END;
/
-- ���� �Ϸù�ȣ�� ���� ���� �����Ͽ� �ִ� �Լ�
CREATE OR REPLACE FUNCTION coupon_idx_seq
RETURN VARCHAR2 IS
    rand_str VARCHAR2(6);
    count_num NUMBER;
    max_attempts CONSTANT NUMBER := 100; -- �ִ� �õ� Ƚ��
    attempts NUMBER := 0;

    FUNCTION generate_random_string RETURN VARCHAR2 IS
        chars VARCHAR2(62) := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        result VARCHAR2(6) := '';
    BEGIN
        FOR i IN 1..6 LOOP
            result := result || SUBSTR(chars, TRUNC(DBMS_RANDOM.VALUE(1, LENGTH(chars) + 1)), 1);
        END LOOP;
        RETURN result;
    END generate_random_string;

BEGIN
    LOOP
        rand_str := generate_random_string(); -- ���� ���ڿ� ����
        SELECT COUNT(*) INTO count_num FROM COUPON_SHOP WHERE coupon_idx = rand_str;

        EXIT WHEN count_num = 0; -- �ߺ� Ȯ��

        attempts := attempts + 1;
        IF attempts >= max_attempts THEN
            RAISE_APPLICATION_ERROR(-20001, 'Unable to generate unique coupon index after maximum attempts');
        END IF;
    END LOOP;
    RETURN rand_str;
END;
/

-- ������ ���̵����� ����
INSERT INTO coupon_shop (coupon_idx, coupon_name, coupon_description, image_url, points) VALUES
(coupon_idx_seq(), '25% ���� ����', '��� ī�װ����� ��� ������ 25% ���� ����', '/uploads/images/d7b666d9-e37d-4426-ac70-1b807f54c8be.jpg', 2500);

-- ���� ���� ���̺�
CREATE TABLE coupon_purchases (
    purchase_idx VARCHAR2(30) PRIMARY KEY,           -- ���� �Ϸù�ȣ (�⺻ Ű)
    coupon_idx VARCHAR2(30) NOT NULL,                -- ������ ������ �Ϸù�ȣ (coupon_shop�� �ܷ�Ű)
    coupon_name VARCHAR2(50) NOT NULL,               -- ������ ������ �̸�
    paid_points NUMBER NOT NULL,                     -- ������ ����Ʈ(������ ������ ����)
    user_id VARCHAR2(30),                            -- ������ ������ ID (member ���̺��� �ܷ�Ű)
    purchase_date DATE DEFAULT SYSDATE               -- ���� ���� �Ͻ�
);
drop table coupon_purchases;
