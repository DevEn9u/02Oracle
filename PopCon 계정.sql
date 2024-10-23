-- 초기화용 코드 (전부 삭제)
-- 트리거 삭제
BEGIN
    FOR rec IN (SELECT trigger_name FROM user_triggers) LOOP
        EXECUTE IMMEDIATE 'DROP TRIGGER ' || rec.trigger_name;
    END LOOP;
END;
/

-- 시퀀스 삭제
BEGIN
    FOR rec IN (SELECT sequence_name FROM user_sequences) LOOP
        EXECUTE IMMEDIATE 'DROP SEQUENCE ' || rec.sequence_name;
    END LOOP;
END;
/

-- 테이블 삭제
BEGIN
    FOR rec IN (SELECT table_name FROM user_tables) LOOP
        EXECUTE IMMEDIATE 'DROP TABLE ' || rec.table_name || ' CASCADE CONSTRAINTS';
    END LOOP;
END;
/

-- 멤버타입을 authority로 변경, enabled추가함
-- 회원 테이블 (MEMBER)
CREATE TABLE MEMBER (
    id VARCHAR2(20) NOT NULL,         -- 사용자 ID
    name VARCHAR2(60) NOT NULL,       -- 사용자 이름, 상호명
    email VARCHAR2(30) NOT NULL,      -- 이메일
    pass VARCHAR2(80) NOT NULL,       -- 비밀번호
    authority VARCHAR2(20) NOT NULL,  -- 회원 구분 및 권한부여 (어드민(admin), 일반(normal), 기업(corp))
                                      -- 데이터 입력시 ROLE_ADMIN 식으로 'ROLE_권한'으로 입력해야함
    phone VARCHAR2(30) NOT NULL,      -- 연락처
    business_number VARCHAR2(30),      -- 사업자번호 (일반 회원은 null)
    point NUMBER(3, 0) DEFAULT 0,     -- 포인트 (기업 회원은 null)
    enabled NUMBER(1, 0) DEFAULT 1,   -- 계정 활성화 상태 (1 - 활성화, 0 - 비활성화)
                                      -- Spring Security 사용을 위해 필수적
    PRIMARY KEY (id)                   -- id 컬럼을 기본 키로 설정
);

-- 회원 테이블 생성 확인
SELECT * FROM MEMBER;

-- 게시판 테이블 (BOARD)
CREATE TABLE BOARD (
    board_idx VARCHAR2(20) NOT NULL,   -- 게시글 일련번호 (시퀀스 사용)
    board_title VARCHAR2(50) NOT NULL,  -- 제목
    postdate DATE DEFAULT SYSDATE NOT NULL, -- 작성 날짜 (현재 시간으로 기본값 설정)
    contents VARCHAR2(2000) NOT NULL,   -- 기타 내용들
    images VARCHAR2(200),                -- 첨부 이미지 (다운로드 기능은 따로 없음)
    writer VARCHAR2(20) NOT NULL,        -- 게시글 작성자 (member 테이블의 id 참조)
    visitcount NUMBER(5, 0) DEFAULT 0,  -- 게시글 조회수
    board_type VARCHAR2(10) NOT NULL,    -- 게시글 구분 (공지, 자유)
    role VARCHAR2(20) NOT NULL,          -- 게시판 사용시 권한 (공지게시판에 admin만 권한 부여)
    PRIMARY KEY (board_idx),             -- board_idx 컬럼을 기본 키로 설정
    FOREIGN KEY (writer) REFERENCES MEMBER(id) -- writer 컬럼을 MEMBER 테이블의 id와 외래 키 관계 설정
);

-- 게시글 일련번호 생성을 위한 시퀀스
CREATE SEQUENCE board_seq
    START WITH 1  -- 시작 값
    INCREMENT BY 1  -- 증가 값
    NOCACHE;  -- 캐시 사용 안 함
    
-- BOARD 테이블에 새로운 게시글이 추가될 때 board_idx 자동 생성
CREATE OR REPLACE TRIGGER trg_board_before_insert
BEFORE INSERT ON BOARD
FOR EACH ROW
BEGIN
    IF :NEW.board_idx IS NULL THEN
        SELECT board_seq.NEXTVAL INTO :NEW.board_idx FROM dual;
    END IF;
END;
/

-- 게시판 테이블 생성 확인
SELECT * FROM BOARD;

-- 팝업 게시판 테이블 (POPUP_BOARD)
CREATE TABLE POPUP_BOARD (
    board_idx VARCHAR2(20) PRIMARY KEY,         -- 게시글 일련번호, 기본 키 (시퀀스 사용)
    board_title VARCHAR2(100) NOT NULL,          -- 제목
    postdate DATE DEFAULT SYSDATE NOT NULL,     -- 작성 날짜 (기본값: 현재 날짜)
    start_date VARCHAR2(10),                    -- 팝업 진행 시작 날짜
    end_date VARCHAR2(10),                      -- 팝업 진행 마지막 날짜
    contents VARCHAR2(2000) NOT NULL,           -- 기타 내용들
    popup_addr VARCHAR2(100),                     -- 팝업 주소지
    thumb VARCHAR2(200),                         -- 게시글 목록에 표시할 썸네일
    category VARCHAR2(30),                       -- 게시글 검색용 카테고리
    writer VARCHAR2(20) NOT NULL,               -- 게시글 작성자 (member 테이블의 id 참조)
    visitcount NUMBER(5, 0) DEFAULT 0,         -- 게시글 조회수 (기본값: 0)
    role VARCHAR2(20) NOT NULL,                 -- 게시판 사용 시 권한 (어드민(admin), 기업(corp)만 부여)
    popup_fee NUMBER(5, 0) DEFAULT 0,          -- 팝업스토어 입장료 (기본값: 0)
    likes_count NUMBER(5, 0) DEFAULT 0,          -- 좋아요 개수 (기본값: 0)
    open_days VARCHAR2(50),
    open_hours VARCHAR2(50),
    FOREIGN KEY (writer) REFERENCES MEMBER(id) -- writer 컬럼을 MEMBER 테이블의 id와 외래 키 관계 설정
    
);

-- 팝업 게시글 일련번호 생성을 위한 시퀀스
CREATE SEQUENCE popup_board_idx_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- POPUP_BOARD 테이블에 새로운 팝업 게시글이 추가될 때 board_idx 자동 생성
CREATE OR REPLACE TRIGGER trg_popup_board_idx
BEFORE INSERT ON POPUP_BOARD
FOR EACH ROW
BEGIN
    IF :NEW.board_idx IS NULL THEN
        SELECT popup_board_idx_seq.NEXTVAL INTO :NEW.board_idx FROM dual;
    END IF;
END;
/

-- 팝업 게시판 테이블 생성 확인
SELECT * FROM POPUP_BOARD;

-- 댓글 테이블 (COMMENTS)
CREATE TABLE COMMENTS (
    com_idx VARCHAR2(20) PRIMARY KEY,             -- 댓글 일련번호, 기본 키 (시퀀스 사용)
    board_idx VARCHAR2(20),                        -- 게시글 일련번호 (boards 테이블의 board_idx 참조)
    popup_board_idx VARCHAR2(20),                  -- 팝업 게시글 일련번호 (popup_board 테이블의 board_idx 참조)
    com_writer VARCHAR2(20) NOT NULL,             -- 댓글 작성자 (member 테이블의 id 참조)
    com_contents VARCHAR2(2000) NOT NULL,         -- 댓글 내용
    com_postdate DATE DEFAULT SYSDATE NOT NULL,  -- 댓글 작성 날짜 (기본값: 현재 날짜)
    com_img VARCHAR2(40),                          -- 리뷰에 첨부할 이미지
    CONSTRAINT chk_comment_type CHECK (
        (board_idx IS NOT NULL AND popup_board_idx IS NULL) OR 
        (board_idx IS NULL AND popup_board_idx IS NOT NULL)
    ),  -- 댓글은 반드시 하나의 게시글만 참조해야 함
    FOREIGN KEY (board_idx) REFERENCES BOARD(board_idx) ON DELETE CASCADE,   -- board_idx 외래 키 설정
    FOREIGN KEY (popup_board_idx) REFERENCES POPUP_BOARD(board_idx) ON DELETE CASCADE, -- popup_board_idx 외래 키 설정
    FOREIGN KEY (com_writer) REFERENCES MEMBER(id) -- com_writer 외래 키 설정
);


-- 댓글 일련번호 생성을 위한 시퀀스
CREATE SEQUENCE comment_idx_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- COMMENTS 테이블에 새로운 댓글이 추가될 때 com_idx 자동 생성
CREATE OR REPLACE TRIGGER trg_comment_idx
BEFORE INSERT ON COMMENTS
FOR EACH ROW
BEGIN
    IF :NEW.com_idx IS NULL THEN
        SELECT comment_idx_seq.NEXTVAL INTO :NEW.com_idx FROM dual;
    END IF;
END;
/

-- 댓글 테이블 생성 확인
SELECT * FROM COMMENTS;

-- 좋아요 테이블 (LIKES)
CREATE TABLE LIKES (
    likes_idx VARCHAR2(20) PRIMARY KEY,          -- 좋아요 일련번호, 기본 키
    member_id VARCHAR2(20),                       -- 좋아요를 누른 회원 ID (member 테이블 참조)
    board_id VARCHAR2(20),                         -- 좋아요 대상 게시글 일련번호 (board 테이블 참조)
    FOREIGN KEY (member_id) REFERENCES MEMBER (id), -- 좋아요 테이블 회원 ID 외래 키 추가
    FOREIGN KEY (board_id) REFERENCES POPUP_BOARD (board_idx) -- 좋아요 테이블 게시글 ID 외래 키 추가
);

-- 좋아요 일련번호 생성을 위한 시퀀스
CREATE SEQUENCE likes_idx_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- 좋아요 테이블에 새로운 좋아요가 추가될 때 likes_idx 자동 생성
CREATE OR REPLACE TRIGGER trg_likes_idx
BEFORE INSERT ON LIKES
FOR EACH ROW
BEGIN
    IF :NEW.likes_idx IS NULL THEN
        SELECT likes_idx_seq.NEXTVAL INTO :NEW.likes_idx FROM dual;
    END IF;
END;
/

-- 좋아요 테이블 생성 확인
SELECT * FROM LIKES;

-- 이미지 테이블 (IMAGES)
CREATE TABLE IMAGES (
    image_idx VARCHAR2(20) PRIMARY KEY,
    image_url VARCHAR2(255) NOT NULL,
    image_type VARCHAR2(20) NOT NULL,
    associated_id VARCHAR2(20) NOT NULL,
    upload_date DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT chk_image_type CHECK (image_type IN ('BOARD', 'POPUP', 'COMMENT'))
);

-- 이미지 일련번호 생성을 위한 시퀀스
CREATE SEQUENCE image_idx_seq
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;

-- IMAGES 테이블에 새로운 이미지가 추가될 때 image_idx 자동 생성
CREATE OR REPLACE TRIGGER trg_image_idx
BEFORE INSERT ON IMAGES
FOR EACH ROW
BEGIN
    IF :NEW.image_idx IS NULL THEN
        SELECT image_idx_seq.NEXTVAL INTO :NEW.image_idx FROM dual;
    END IF;
END;
/
-- 이미지 테이블 생성 확인
SELECT * FROM IMAGES;

-- 테이블 목록 확인
SELECT table_name FROM user_tables;
-- 시퀀스 목록 확인
SELECT sequence_name FROM user_sequences;
-- 트리거 목록 확인
SELECT trigger_name FROM user_triggers;


--테이블 테스트용 더미데이터
-- MEMBER 테이블에 더미 데이터 추가
-- 비밀번호는 qwer1234
INSERT INTO MEMBER (id, name, email, pass, authority, phone, business_number, point, enabled) VALUES
('user01', '홍길동', 'user01@example.com', '$2a$10$jFhRboc.PRJxz4yHLvTXbes0IHodjKa/iObQQyhef1n0d/6AGAvaa', 'ROLE_NORMAL', '010-1234-5678', NULL, 0, 1);
INSERT INTO MEMBER (id, name, email, pass, authority, phone, business_number, point, enabled) VALUES
('admin', 'admin', 'user02@example.com', '$2a$10$jFhRboc.PRJxz4yHLvTXbes0IHodjKa/iObQQyhef1n0d/6AGAvaa', 'ROLE_ADMIN', '010-2345-6789', NULL, 0, 1);
INSERT INTO MEMBER (id, name, email, pass, authority, phone, business_number, point, enabled) VALUES
('user03', '이영희', 'user03@example.com', '$2a$10$jFhRboc.PRJxz4yHLvTXbes0IHodjKa/iObQQyhef1n0d/6AGAvaa', 'ROLE_CORP', '010-3456-7890', '123-45-67890', 0, 1);

-- BOARD 테이블에 더미 데이터 추가
INSERT INTO BOARD (board_idx, board_title, postdate, contents, images, writer, visitcount, board_type, role) VALUES
(NULL, '자유게시판 첫 번째 글', SYSDATE, '자유게시판에 오신 것을 환영합니다!', NULL, 'user01', 0, '자유', 'ROLE_NORMAL');
INSERT INTO BOARD (board_idx, board_title, postdate, contents, images, writer, visitcount, board_type, role) VALUES
(NULL, '공지사항: 점검 안내', SYSDATE, '서버 점검이 진행됩니다. 참고 바랍니다.', NULL, 'admin', 0, '공지', 'ROLE_ADMIN');

-- POPUP_BOARD 테이블에 더미 데이터 추가
INSERT INTO POPUP_BOARD (board_idx, board_title, postdate, start_date, end_date, contents, popup_addr, thumb, category, writer, visitcount, role, popup_fee, likes_count) VALUES
(NULL, '특별 팝업 이벤트', SYSDATE, '2024-10-14', '2024-10-30', '특별 이벤트에 참여하세요!', '서울특별시 종로구', '/uploads/images/598019c9-84b1-44d8-a65f-b9b8529efc1b.jpg', '이벤트', 'user01', 0, 'ROLE_NORMAL', 0, 0);
INSERT INTO POPUP_BOARD (board_idx, board_title, postdate, start_date, end_date, contents, popup_addr, thumb, category, writer, visitcount, role, popup_fee, likes_count) VALUES
(NULL, '신제품 출시 안내', SYSDATE, '2024-10-14', '2024-10-30', '신제품을 확인하세요!', '부산광역시', '/uploads/images/59b2cb9f-8971-4bd5-b9cb-bf5c088ee40d.jpg', '제품', 'user02', 0, 'ROLE_ADMIN', 0, 0);
INSERT INTO POPUP_BOARD (board_idx, board_title, postdate, start_date, end_date, contents, popup_addr, thumb, category, writer, visitcount, role, popup_fee, likes_count) VALUES
(NULL, '여름 세일 안내', SYSDATE, '2024-10-14', '2024-10-30', '여름 세일에 많은 참여 바랍니다!', '대구광역시', '/uploads/images/598019c9-84b1-44d8-a65f-b9b8529efc1b.jpg', '세일', 'user03', 0, 'ROLE_CORP', 0, 0);

-- COMMENTS 테이블에 더미 데이터 추가
INSERT INTO COMMENTS (com_idx, board_idx, popup_board_idx, com_writer, com_contents, com_postdate, com_img) VALUES
(NULL, '1', NULL, 'admin', '첫 번째 글에 댓글을 남깁니다.', SYSDATE, NULL);
INSERT INTO COMMENTS (com_idx, board_idx, popup_board_idx, com_writer, com_contents, com_postdate, com_img) VALUES
(NULL, '2', NULL, 'user01', '점검 안내 잘 봤습니다.', SYSDATE, NULL);
INSERT INTO COMMENTS (com_idx, board_idx, popup_board_idx, com_writer, com_contents, com_postdate, com_img) VALUES
(NULL, '3', NULL, 'user03', '두 번째 글 너무 유익하네요!', SYSDATE, NULL);

-- LIKES 테이블에 더미 데이터 추가
INSERT INTO LIKES (likes_idx, member_id, board_id) VALUES
(NULL, 'user01', '1');
INSERT INTO LIKES (likes_idx, member_id, board_id) VALUES
(NULL, 'admin', '2');
INSERT INTO LIKES (likes_idx, member_id, board_id) VALUES
(NULL, 'user03', '3');


-- 예약정보 테이블 생성
CREATE TABLE BOOKING (
    booking_num VARCHAR2(20) PRIMARY KEY,           -- 예약번호 (6자리 랜덤 숫자)
    popup_idx VARCHAR2(20),                         -- 팝업게시물 일련번호 (NOT NULL로 변경해야함)
    member_id VARCHAR2(20) NOT NULL,                -- 로그인한 계정의 아이디
    visit_date DATE NOT NULL,                       -- 팝업 예약 날짜
    booking_date DATE DEFAULT SYSDATE NOT NULL,     -- 예약 시행일
    price NUMBER(5,0) DEFAULT 0,                    -- 인원수까지 합친 총 가격
    headcount NUMBER(2,0) DEFAULT 1,                -- 인원 수
    is_paid NUMBER(2,0) DEFAULT 0,                  -- 결제 진행 사항 중(0일때 결제미완료 / 1일때 결제완료)
    is_canceled NUMBER(2,0) DEFAULT 0               -- 취소 사항 ( 취소 시 1 )
);

-- 예약 일련번호에 랜덤 숫자 생성하여 넣는 함수
CREATE OR REPLACE FUNCTION booking_num_seq
RETURN NUMBER IS
    rand_num NUMBER;
    count_num NUMBER;
BEGIN
    LOOP
        rand_num := TRUNC(DBMS_RANDOM.VALUE(100000, 999999)); -- 6자리 랜덤숫자 생성
        -- 중복이 있을 경우 count_num = 1
        SELECT COUNT(*) INTO count_num FROM BOOKING WHERE booking_num = rand_num;
        -- 중복확인
        EXIT WHEN count_num = 0;
    END LOOP;
    RETURN rand_num;
END;
/

-- popup_idx 외래키 추가
ALTER TABLE BOOKING
ADD CONSTRAINT fk_popup_idx
FOREIGN KEY (popup_idx) REFERENCES POPUP_BOARD(board_idx) ON DELETE CASCADE;
-- member_id 외래키 추가
ALTER TABLE BOOKING
ADD CONSTRAINT fk_member_id
FOREIGN KEY (member_id) REFERENCES MEMBER(id) ON DELETE CASCADE;
-- 팝업 제목을 가져오는 popup_title 추가
ALTER TABLE BOOKING
ADD popup_title VARCHAR2(100);

SELECT b.*, pb.board_title AS popup_title
FROM BOOKING b
JOIN POPUP_BOARD pb ON b.popup_idx = pb.board_idx;



-- 더미데이터 입력
INSERT INTO BOOKING (booking_num, popup_idx, member_id, visit_date, booking_date, price, headcount, is_paid, is_canceled, popup_title)
VALUES
(booking_num_seq, NULL, 'user01', sysdate, sysdate, 0, 2, 0, 0, '더미데이터');

SELECT * FROM BOOKING;

COMMIT;

/**************************************/
-- 포인트 테이블
CREATE TABLE point (
    p_user VARCHAR2(20) NOT NULL,  -- 포인트를 사용/적립할 유저 (member 테이블의 id 참조)
    p_change NUMBER(4, 0) NOT NULL, -- 변경된 포인트 (양수 또는 음수)
    p_change_date DATE NOT NULL,     -- 포인트 변동 일시
    CONSTRAINT pk_point PRIMARY KEY (p_user, p_change_date), -- 복합 기본키 설정 (유저와 변동 일시 조합)
    CONSTRAINT fk_member FOREIGN KEY (p_user) REFERENCES member(id) -- member 테이블과의 외래키 관계
);

ALTER TABLE member
MODIFY (point NUMBER(5, 0));


ALTER TABLE member
ADD register_date DATE DEFAULT sysdate;

--쿠폰샵 테이블
CREATE TABLE coupon_shop (
    coupon_idx VARCHAR2(30) PRIMARY KEY,             -- 쿠폰 일련 번호 (기본 키)
    coupon_name VARCHAR2(50) NOT NULL,               -- 쿠폰 이름
    coupon_description VARCHAR2(200) NOT NULL,       -- 쿠폰 설명
    image_url VARCHAR2(255),                         -- 쿠폰 이미지 URL
    points NUMBER(5,0) NOT NULL,                     -- 쿠폰 가격 (포인트)
    expiry_date DATE                                 -- 쿠폰 사용 마감 기한
);
-- 유효기간을 정하는 트리거 설정
CREATE OR REPLACE TRIGGER trg_set_expiry_date
BEFORE INSERT ON coupon_shop
FOR EACH ROW
BEGIN
    IF :NEW.expiry_date IS NULL THEN
        :NEW.expiry_date := ADD_MONTHS(SYSDATE, 1);
    END IF;
END;
/
-- 쿠폰 일련번호에 랜덤 숫자 생성하여 넣는 함수
CREATE OR REPLACE FUNCTION coupon_idx_seq
RETURN VARCHAR2 IS
    rand_str VARCHAR2(6);
    count_num NUMBER;
    max_attempts CONSTANT NUMBER := 100; -- 최대 시도 횟수
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
        rand_str := generate_random_string(); -- 랜덤 문자열 생성
        SELECT COUNT(*) INTO count_num FROM COUPON_SHOP WHERE coupon_idx = rand_str;

        EXIT WHEN count_num = 0; -- 중복 확인

        attempts := attempts + 1;
        IF attempts >= max_attempts THEN
            RAISE_APPLICATION_ERROR(-20001, 'Unable to generate unique coupon index after maximum attempts');
        END IF;
    END LOOP;
    RETURN rand_str;
END;
/

-- 쿠폰샵 더미데이터 삽입
INSERT INTO coupon_shop (coupon_idx, coupon_name, coupon_description, image_url, points) VALUES
(coupon_idx_seq(), '25% 할인 쿠폰', '모든 카테고리에서 사용 가능한 25% 할인 쿠폰', '/uploads/images/d7b666d9-e37d-4426-ac70-1b807f54c8be.jpg', 2500);

-- 쿠폰 구매 테이블
CREATE TABLE coupon_purchases (
    purchase_idx VARCHAR2(30) PRIMARY KEY,           -- 구매 일련번호 (기본 키)
    coupon_idx VARCHAR2(30) NOT NULL,                -- 구매한 쿠폰의 일련번호 (coupon_shop의 외래키)
    coupon_name VARCHAR2(50) NOT NULL,               -- 구매한 쿠폰의 이름
    paid_points NUMBER NOT NULL,                     -- 지불한 포인트(구매한 쿠폰의 가격)
    user_id VARCHAR2(30),                            -- 구매한 유저의 ID (member 테이블의 외래키)
    purchase_date DATE DEFAULT SYSDATE               -- 쿠폰 구매 일시
);
drop table coupon_purchases;
