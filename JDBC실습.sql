/*
JDBC 프로그래밍 실습을 위한 워크시트
*/

--Java에서 member테이블에 CRUD 기능 구현하기
--member 테이블 생성
CREATE TABLE member (
    /* id, pass, name은 문자타입으로 선언하고 NULL값을 허용하지 않는 컬럼으로
    정의한다. 즉 반드시 입력값이 있어야 insert가 가능하다. */
	id VARCHAR2(30) NOT NULL,
	pass VARCHAR2(40) NOT NULL,
	name VARCHAR2(50) NOT NULL, 
    /* 날짜타입으로 선언함. NULL을 허용하는 컬럼으로 정의한다. 만약 입력값이
    없다면 현재시각(SYSDATE)을 DEFAULT로 입력한다. */
	regidate DATE DEFAULT SYSDATE,
    /* 아이디를 기본키(PK)로 지정한다. */
	PRIMARY KEY (id)
);

--member 테이블에 레코드(더미데이터) 입력
INSERT INTO member(id, pass, name) VALUES ('tjoeun01', '1234', '더조은IT');
/*
    입력 후 commit을 실행하지 않으면 오라클 외부 프로그램(Java, JSP)에서는
    새롭게 입력한 레코드를 확인할 수 없다. 입력된 레코드를 적용하기 위해
    반드시 commit을 실행해야 한다.
    Java를 통해 외부에서 입력되는 데이터는 자동으로 commit 되므로 별도의 처리는
    필요하지 않다.
*/
SELECT * FROM member;
COMMIT;

--like를 이용한 데이터 검색 기능 구현하기
SELECT * FROM member WHERE name LIKE '%조은%';
SELECT * FROM member WHERE regidate LIKE '___07_01';

---------------------------------------------------------
/*
JSP에서 JDBC연동하기 실습
*/
--먼저 system 계정으로 접속한 후 새로운 계정을 생성한다.

--C## 접두어 없이 계정을 생성하기 위한 세션변경
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
--새로운 사용자 계정 생성
CREATE USER musthave IDENTIFIED BY 1234;
--2개의 Role과 테이블스페이스까지 권한 부여
GRANT CONNECT, RESOURCE, unlimited tablespace TO musthave;

/*
CMD 환경에서 sqlplus를 통해 접속한 경우에는 다른 계정으로 전환시 
아래와 같이 conn 혹은 connect 명령어를 사용할 수 있다.
Developer에서는 좌측 접속창을 사용한다.
*/
conn musthave/1234;
show user;

--musthave 계정이 생성되면 접속창에 등록한 후 접속합니다.
--접속이 완료되면 member, board 테이블 생성 및 제약조건 설정을 진행합니다.
--테이블 목록 조회
SELECT * FROM TAB;

/* 테이블 및 시퀀스 생성을 위해 기존 생성된 객체가 있다면 삭제를 진행한 후
새롭게 생성한다. */
drop table member;
drop table board;
drop sequence seq_board_num;

--회원 테이블 생성
CREATE TABLE member (
    id varchar2(10) not null,
    pass varchar2(10) not null,
    name varchar2(30) not null,
    regidate date default sysdate not null,
    primary key (id) /* id컬럼을 기본키(PK)로 설정*/
);

--게시판 테이블 생성
CREATE TABLE board (
    num number primary key, /* 일련번호 (PK) */
    title varchar2(200) not null, /* 제목 */
    content varchar2(200) not null, /* 내용 */
    id varchar2(10) not null, /* 회원제 게시판이므로 회원아이디 필요*/
    postdate date default sysdate not null, /* 게시물의 작성일 */
    visitcount number(6) /* 게시물의 조회수 */
);

--외래키 설정
/*
자식테이블인 board가 부모테이블인 member를 참조하는 외래키를 설정한다.
board의 id 컬럼이 member의 기본키인 id 컬럼을 참조하도록 제약조건을 설정.
*/
alter table board
    add constraint board_mem_fk foreign key (id)
    references member (id); --제약조건명까지 포함해서 외래키 생성함.
    
--시퀀스 생성
--board 테이블에 중복되지 않는 일련번호를 부여한다.
create sequence seq_board_num
    /* 증가치, 시작값, 최솟값을 모두 1로 설정 */
    increment by 1
    start with 1
    minvalue 1
    /* 최댓값, cycle, cache메모리 사용을 모두 no로 설정 */
    nomaxvalue
    nocycle
    nocache;
    
--더미 데이터 입력
/*
부모테이블인 member에 먼저 레코드를 삽입한 후 자식테이블인 board에 삽입해야 한다.
만약 자식테이블에 먼저 입력하면 부모키가 없다는 에러가 발생한다.
2개의 테이블은 서로 외래키(참조관계)가 설정되어 있으므로 참조 무결성을 유지하기 위해
순서대로 레코드를 삽입해야 한다.
*/
insert into member (id, pass, name) values ('musthave', '1234', '머스트해브');
insert into board (num, title, content, id, postdate, visitcount)
    values (
        seq_board_num.nextval, '제목1입니다', 
        '내용1입니다', 'musthave', sysdate, 0);

--커밋해서 실제 테이블에 적용
commit;

--본인이 주로 사용하는 아이디 추가 입력하기
INSERT INTO member VALUES ('kig1132', '1234', '데브엔', sysdate);
SELECT * FROM member;
/* 레코드 입력 후 커밋을 하지 않으면 외부 프로그램에서는 사용할 수 없다.
반드시 COMMIT 명령을 실행하여 실제 테이블에 적용한 후 사용해야 한다. */
COMMIT;

/**********************************
모델1 방식의 회원제 게시판 제작하기
***********************************/
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '지금은 봄입니다.', '봄의왈츠', 'musthave',
        sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '지금은 여름입니다.', '여름향기', 'musthave',
        sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '지금은 가을입니다.', '가을동화', 'musthave',
        sysdate, 0);
insert into board (num, title, content, id, postdate, visitcount)
    values (seq_board_num.nextval, '지금은 겨울입니다.', '겨울연가', 'musthave',
        sysdate, 0);

SELECT * FROM board;

--DAO의 selectCount()메서드 : board 테이블의 개시물 개수 카운트
SELECT count(*) FROM board;
SELECT count(*) FROM board WHERE title LIKE '%겨울%';
SELECT count(*) FROM board WHERE title LIKE '%서유기%';
--조건에 따라 0 혹은 그 이상의 정수값이 결과로 인출된다.(항상 결과값이 있다.)

--selectList()메서드 : 게시판 목록에 출력할 레코드를 정렬해서 인출
SELECT * FROM board ORDER BY num DESC;
SELECT * FROM board WHERE title LIKE '%봄%' ORDER BY num DESC;
SELECT * FROM board WHERE content LIKE '%내용%' ORDER BY num DESC;
SELECT * FROM board WHERE title LIKE '%삼국지%' ORDER BY num DESC;
--조건에 따라 인출되는 레코드가 아예 없을 수도 있다.

COMMIT;

--selectView() 메서드 : 게시물의 내용 상세보기
/* board 테이블에는 id만 저장되어 있으므로 이름까지 출력하기 위해
member 테이블과 join을 걸어서 쿼리문을 구성한다. */
SELECT *
    FROM board B INNER JOIN member M
        ON B.id = M.ID
WHERE num = 7; /* 2개 테이블의 모든 컬럼을 가져와서 인출한다. */

/* 내용보기에서 출력할 내용만 가져오면 되므로 아래와 같이 별칭을 이용해서
인출할 컬럼을 지정한다. */
SELECT B.*, M.name
    FROM board B INNER JOIN member M
        ON B.id = M.ID
WHERE num = 11;

--JOIN을 위한 참조컬럼명이 동일하므로 USING으로 간단하게 표현할 수 있다.
SELECT *
    FROM board INNER JOIN member
        USING(id)
WHERE num = 11;

--updateVisitCount() 메서드 : 게시물 조회시 visitcount 컬럼에 1을 증가시키는 작업
UPDATE board SET visitcount = visitcount + 1 WHERE num = 2;
SELECT * FROM board;


--updateEdit() 메서드 : 게시물 수정하기
UPDATE board
    set title = '수정테스트', content = 'update문으로 게시물을 수정해봅니다.'
    WHERE num = 2;
SELECT * FROM board;
COMMIT;

/*
모델1 게시판의 페이징 기능 추가를 위한 서브쿼리문
*/
--1. board 테이블의 게시물을 내림차순으로 정렬한다.
SELECT * FROM board ORDER BY num DESC;

--2. 내림차순으로 정렬된 상태에서 rownum을 통해 순차적인 번호를 부여한다.
SELECT tb.*, rownum FROM (
    SELECT * FROM board ORDER BY num DESC) tb;

--3. ROWNUM을 통해 각 페이지에서 출력할 게시물의 구간을 결정한다.
SELECT * FROM
    (SELECT tb.*, ROWNUM rNum FROM
       (SELECT * FROM board ORDER BY num DESC) tb
    )
--WHERE rNum >= 1 and rNum <= 10;
WHERE rNum >= 11 and rNum <= 20;
--WHERE rNum between 21 and 30;

/*4. 검색어가 있는 경우에는 WHERE절이 동적으로 추가된다. LIKE절은 가장 안쪽의
쿼리문에 추가하면 된다. 검색 조건에 맞는 게시물을 인출한 후 ROWNUM을
부여하게 된다.*/
SELECT * FROM
    (SELECT tb.*, ROWNUM rNum FROM
       (SELECT * FROM board 
        WHERE title LIKE '%9번째%'
        ORDER BY num DESC) tb
    )
WHERE rNum >= 1 and rNum <= 20;

-----------------------모델 2방식 테이블--------------------------
create table mvcboard (
    idx number primary key, /* 일련번호 */
    name varchar2(50) not null, /* 작성자 이름 */
    title varchar2(200) not null,/* 제목 */
    content varchar2(2000) not null, /* 내용 */
    postdate date default sysdate not null, /* 작성일 */
    ofile varchar2(200), /* 원본 파일명 */
    sfile varchar2(30), /* 서버에 저장된 파일명 */
    downcount number(5) default 0 not null, /* 파일 다운로드 횟수 */
    pass varchar2(50) not null, /* 패스워드 */
    visitcount number default 0 not null /* 게시물 조회수 */
);
--더미 데이터 입력
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용','1234');
insert into mvcboard (idx, name, title, content, pass)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용','1234');

commit;

SELECT * FROM mvcboard;

------------------------------------------------------------------------
/*
백엔드 2차 프로젝트 : 넥슨게임즈 계정 연동을 위한 계정 생성
*/

ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER ngadmin IDENTIFIED BY ng1234;
GRANT CONNECT, RESOURCE, unlimited tablespace TO ngadmin;

SELECT * FROM member;

/* 테이블 및 시퀀스 생성을 위해 기존 생성된 객체가 있다면 삭제를 진행한 후
새롭게 생성한다. */
drop table member;
drop table free_board;
drop table download_board;
drop table qna_board;
drop table comments;
drop sequence seq_board_num;

--회원 테이블 생성
CREATE TABLE member (
    id varchar2(10) not null,
    pass varchar2(10) not null,
    name varchar2(30) not null,
    email varchar2(30) not null,
    phone_number varchar2(30) not null,
    primary key (id) /* id컬럼을 기본키(PK)로 설정*/
);
ALTER TABLE member
ADD regidate DATE DEFAULT SYSDATE;

--게시판 테이블 생성(자유게시판, qna 게시판, 다운로드 게시판으로 나뉜다) 07.18기준 생성
CREATE TABLE free_board (
    idx number primary key, /* 일련번호 */
    name varchar2(50) not null, /* 작성자 이름 */
    title varchar2(200) not null,/* 제목 */
    content varchar2(2000) not null, /* 내용 */
    id varchar2(10) default 'test9999' not null,
    postdate date default sysdate not null, /* 작성일 */
    visitcount number default 0 not null /* 게시물 조회수 */
);
CREATE TABLE qna_board (
    idx number primary key, /* 일련번호 */
    name varchar2(50) not null, /* 작성자 이름 */
    title varchar2(200) not null,/* 제목 */
    content varchar2(2000) not null, /* 내용 */
    id varchar2(10) default 'test9999' not null,
    postdate date default sysdate not null, /* 작성일 */
    visitcount number default 0 not null /* 게시물 조회수 */
);
CREATE TABLE download_board (
    idx number primary key, /* 일련번호 */
    name varchar2(50) not null, /* 작성자 이름 */
    title varchar2(200) not null,/* 제목 */
    content varchar2(2000) not null, /* 내용 */   
    id varchar2(10) default 'test9999' not null,
    postdate date default sysdate not null, /* 작성일 */
    ofile varchar2(200), /* 원본 파일명 */
    sfile varchar2(30), /* 서버에 저장된 파일명 */
    downcount number(5) default 0 not null, /* 파일 다운로드 횟수 */
    visitcount number default 0 not null /* 게시물 조회수 */
);
CREATE TABLE comments (
    comm_idx number primary key, /* 댓글의 일련번호 */
    board_idx number not null, /* 댓글이 작성된 게시글의 일련번호 */
    name varchar2(50) not null, /* 작성자 이름 */
    content varchar2(1000) not null, 
    id varchar2(10) default 'test9999' not null,
    postdate date default sysdate not null,
    CONSTRAINT FK_comment FOREIGN KEY(board_idx) REFERENCES qna_board(idx)
);


--외래키 설정
/*
자식테이블인 board가 부모테이블인 member를 참조하는 외래키를 설정한다.
board의 id 컬럼이 member의 기본키인 id 컬럼을 참조하도록 제약조건을 설정.
*/
alter table free_board
    add constraint board_mem_fk foreign key (id)
    references member (id); --제약조건명까지 포함해서 외래키 생성함.

SELECT * FROM (SELECT Tb.*, ROWNUM rNum FROM (SELECT * FROM
    free_board ORDER BY idx DESC) Tb) WHERE rNum BETWEEN 1 AND 10;

--시퀀스 생성
--board 테이블에 중복되지 않는 일련번호를 부여한다.
create sequence seq_board_num
    /* 증가치, 시작값, 최솟값을 모두 1로 설정 */
    increment by 1
    start with 1
    minvalue 1
    /* 최댓값, cycle, cache메모리 사용을 모두 no로 설정 */
    nomaxvalue
    nocycle
    nocache;
    
insert into member (id, pass, name, email, phone_number) values
('musthave', '1234', '머스트해브', 'musthave@naver.com', '010-1111-2222');
insert into board (num, title, content, id, postdate, visitcount)
    values (
        seq_board_num.nextval, '제목1입니다', 
        '내용1입니다', 'musthave', sysdate, 0);

--커밋해서 실제 테이블에 적용
commit;
delete from member where name like '%asd%';

--더미 데이터 입력
insert into free_board (idx, name, title, content)
    values (seq_board_num.nextval, '김유신', '자료실 제목1 입니다.','내용');
insert into free_board (idx, name, title, content)
    values (seq_board_num.nextval, '장보고', '자료실 제목2 입니다.','내용');
insert into free_board (idx, name, title, content)
    values (seq_board_num.nextval, '이순신', '자료실 제목3 입니다.','내용');
insert into free_board (idx, name, title, content)
    values (seq_board_num.nextval, '강감찬', '자료실 제목4 입니다.','내용');
insert into free_board (idx, name, title, content)
    values (seq_board_num.nextval, '대조영', '자료실 제목5 입니다.','내용');

commit;

SELECT * FROM free_board;
SELECT COUNT(*) FROM free_board;

-- rownum으로 출력
SELECT tb.*, rownum FROM (
    SELECT * FROM free_board ORDER BY idx DESC) tb;


--시퀀스 생성
--comments 테이블에 중복되지 않는 일련번호를 부여한다.
create sequence seq_comments_num
    /* 증가치, 시작값, 최솟값을 모두 1로 설정 */
    increment by 1
    start with 1
    minvalue 1
    /* 최댓값, cycle, cache메모리 사용을 모두 no로 설정 */
    nomaxvalue
    nocycle
    nocache;
-- INSERT comments dummy data
insert into comments (comm_idx, board_idx, name, content, id)
    values (seq_comments_num.nextval, 21, '머스트해브',
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
--JDBC > Callable Statement 인터페이스 사용하기

--Study 계정에서 학습합니다.

--예제 1-1]함수 :  fillAsterisk()
/*
시나리오] 매개변수로 회원아이디(문자열)을 받으면 첫 문자를 제외한 나머지 부분을
        '*'로 변환하는 함수를 생성하시오.
        실행 예) oracle21c => o********
*/
--SUBSTR(문자열 혹은 컬럼, 시작 인덱스, 길이) : 시작 인덱스부터 길이만큼 잘라내는 메서드
SELECT SUBSTR('hongildong', 1, 1) FROM dual;
--RPAD(문자열 혹은 컬럼, 길이, 채울 문자) : 문자열의 남은 길이를 문자로 채운다.
SELECT RPAD('h', 10, '*') FROM dual;
/* 문자열(아이디)의 첫 글자를 제외한 나머지 부분을 '*'로 채운다.
  아이디를 게시판에 출력할 때 히든(마스킹)처리할 때 활용할 수 있다.*/
SELECT RPAD(SUBSTR('hongildong', 1, 1), LENGTH('hongildong'), '*')
FROM dual;

-- 함수 생성
CREATE OR REPLACE FUNCTION fillAsterisk(
    idStr VARCHAR2 /* 인파라미터는 문자형으로 설정*/
)
RETURN VARCHAR2 /* 반환타입도 문자형으로 설정 */
IS retStr VARCHAR2(50);
BEGIN
    -- 아이디를 히든 처리하기 위한 기능 구현
    retStr := RPAD(SUBSTR(idstr, 1, 1), LENGTH(idstr), '*');
    RETURN retStr;
END;
/
--전달한 문자열이 마스킹 처리 되는지 확인
SELECT fillAsterisk('hongildong') FROM dual;
SELECT fillAsterisk('oracle21c') FROM dual;

--생성한 함수는 즉시 테이블에 적용할 수 있다.
SELECT * FROM member;
--member 테이블의 id 컬럼을 hidden 처리한다.
SELECT fillAsterisk(id) FROM member;

--예제2-1] 프로시저 : MyMemberInsert()
/*
시나리오] member 테이블에 새로운 회원정보를 입력하는 프로시저를 생성하시오
    파라미터 : In => 아이디, 패스워드, 이름
                    Out => returnVal(성공:1, 실패:0)
*/
CREATE OR REPLACE PROCEDURE MyMemberInsert(
    /* Java에서 입력한 내용을 받을 인파라미터 정의 */
    p_id IN VARCHAR2,
    p_pass IN VARCHAR2,
    p_name IN VARCHAR2,
    /* 입력성공 여부를 반환할 숫자 형식의 아웃파라미터 */
    returnVal OUT NUMBER
)
IS
BEGIN
    --인파라미터를 통해 INSERT 쿼리문 작성
    INSERT INTO MEMBER (id, pass, name)
        VALUES (p_id, p_pass, p_name);
    
    -- 입력이 정상적으로 처리되면 TRUE를 반환한다.    
    IF SQL%found THEN
        -- 입력에 성공한 행의 개수를 얻어와서 아웃파라미터에 저장한다.
        returnVal := SQL%rowCount;
        -- 행의 변화가 생기므로 반드시 COMMIT 해야 한다.
        COMMIT;
    ELSE
        -- 실패한 경우에는 0을 반환한다.
        returnVal := 0;
    END IF;
    -- 프로시저는 별도의 RETURN 없이 아웃파라미터에 값을 입력하기만 하면 된다.
END;
/

--SET SERVEROUTPUT ON;

-- 바인드 변수 생성
VAR i_result VARCHAR2(10);
EXECUTE MyMemberInsert('pro01', '1234', '프로시저1', :i_result);
EXECUTE MyMemberInsert('pro02', '1234', '프로시저2', :i_result);
-- 결과확인
PRINT i_result;
-- 레코드가 입력되었는지 확인
SELECT * FROM member;

--예제3-1] 프로시저 : MyMemberDelete()
/*
시나리오] member테이블에서 레코드를 삭제하는 프로시저를 생성하시오
    파라미터 : In => member_id(아이디)
                    Out => returnVal(SUCCESS/FAIL 반환)   
*/
CREATE OR REPLACE PROCEDURE MyMemberDelete(
    /* 인파라미터 : 삭제할 아이디 */
    member_id IN VARCHAR2,
    /* 아웃파라미터 : 삭제 결과 */
    returnVal OUT VARCHAR2
)
IS
BEGIN
    -- 인파라미터로 전달된 아이디를 삭제하는 DELETE 쿼리문
    DELETE FROM member WHERE id = member_id;
    
    IF SQL%Found THEN
        -- 회원 레코드가 정상적으로 삭제되면..
        returnVal := 'SUCCESS';
        -- COMMIT 한다.
        COMMIT;
    ELSE
        -- 조건에 일치하는 레코드가 없다면 FAIL 을 반환한다.
        returnVal := 'FAIL';
    END IF;
END;
/

-- 바인드 변수 생성 및 프로시저 실행, 결과 확인
VAR delete_var VARCHAR2(10);
EXECUTE MyMemberDelete('pro02', :delete_var);
PRINT delete_var; -- 아이디가 존재하는 경우 SUCCESS
EXECUTE MyMemberDelete('test99', :delete_var);
PRINT delete_var; -- 아이디가 없으면 FAIL

--예제4-1] 프로시저 : MyMemberAuth()
/*
시나리오] 아이디와 패스워드를 매개변수로 전달받아서 회원인지 여부를 판단하는 프로시저를 작성하시오. 
    매개변수 : 
        In -> user_id, user_pass
        Out -> returnVal
    반환값 : 
        0 -> 회원인증실패(둘다틀림)
        1 -> 아이디는 일치하나 패스워드가 틀린경우
        2 -> 아이디/패스워드 모두 일치하여 회원인증 성공
    프로시저명 : MyMemberAuth
*/
CREATE OR REPLACE PROCEDURE MyMemberAuth(
    /* 인파라미터 : Java에서 입력받은 아이디, 패스워드 */
    user_id IN VARCHAR2,
    user_pass IN VARCHAR2,
    /* 아웃파라미터 : 회원인증 여부를 판단한 후 반환할 값 */
    returnVal OUT NUMBER
)
IS
    -- count(*)를 통해 반환되는 값을 저장
    member_count NUMBER(1):= 0;
    -- 조회한 회원정보의 패스워드를 저장
    member_pw VARCHAR2(50);
BEGIN
    -- 해당 아이디가 존재하는지 판단하는 SELECT 쿼리문
    SELECT COUNT(*) INTO member_count
    FROM member WHERE id = user_id;
    -- 회원 아이디가 존재하는 경우라면...
    IF member_count = 1 THEN
        --패스워드 확인을 위해 두번째 쿼리문 실행
        SELECT pass INTO member_pw
            FROM MEMBER WHERE id = user_id;
        -- 인파라미터로 전달된 비밀번호와 DB에서 가져온 비밀번호 비교    
        IF member_pw = user_pass THEN
            -- 모두 일치하는 경우
            returnVal := 2;
        ELSE
            -- 아이디만 일치하는 경우(비밀번호 틀림)
            returnVal := 1;
        END IF;
    ELSE
        --회원정보가 틀린 경우
        returnVal := 0;
    END IF;
END;
/
-- 바인드 변수 생성
VARIABLE member_auth NUMBER;

EXECUTE MyMemberAuth('hi', '1234', :member_auth);
/* 둘다 일치하는 경우 2 */
PRINT member_auth; 

EXECUTE MyMemberAuth('hi', '1234암호틀림', :member_auth);
/* 아이디만 일치하는 경우 1 */
PRINT member_auth; 

EXECUTE MyMemberAuth('hi아이디틀림', '1234', :member_auth);
/* 회원정보가 없는 경우 0 */
PRINT member_auth;


