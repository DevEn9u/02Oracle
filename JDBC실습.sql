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