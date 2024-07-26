-- system계정에서 새 계정 생성
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
CREATE USER modernize_t IDENTIFIED BY 1234;
GRANT CONNECT, RESOURCE, unlimited tablespace TO modernize_t;

------------------------------------------------------------
-- modernize_t 계정에서 테이블 생성
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
VALUES ('tjoeun', '1234', '더조은IT', 'tj@tjoeun.com', '010-1234-5678');
commit;
SELECT * FROM membership;

-- 로그인 처리를 위한 쿼리문
SELECT * FROM membership WHERE id = 'tjoeun' AND pass = '1234';
SELECT * FROM membership WHERE id = 'tjoeun' AND pass = '9999';


/*
기존 Model 2 방식의 게시판은 비회원제 게시판이므로 회원제로 변경하기 위해
name → id로 변경한다.
또한 pass도 필요없기 때문에 삭제한다.
*/
create table mvcboard (
    idx number primary key, /* 일련번호 */
    id varchar2(50) not null, /* 작성자 아이디 */
    title varchar2(200) not null,/* 제목 */
    content varchar2(2000) not null, /* 내용 */
    postdate date default sysdate not null, /* 작성일 */
    ofile varchar2(200), /* 원본 파일명 */
    sfile varchar2(30), /* 서버에 저장된 파일명 */
    downcount number(5) default 0 not null, /* 파일 다운로드 횟수 */
    visitcount number default 0 not null /* 게시물 조회수 */
);

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
insert into mvcboard (idx, id, title, content)
    values (seq_board_num.nextval, 'tjoeun', '자료실 제목1 입니다.','내용');
insert into mvcboard (idx, id, title, content)
    values (seq_board_num.nextval, 'tjoeun', '자료실 제목2 입니다.','내용');
insert into mvcboard (idx, id, title, content)
    values (seq_board_num.nextval, 'tjoeun', '자료실 제목3 입니다.','내용');
insert into mvcboard (idx, id, title, content)
    values (seq_board_num.nextval, 'tjoeun', '자료실 제목4 입니다.','내용');
insert into mvcboard (idx, id, title, content)
    values (seq_board_num.nextval, 'tjoeun', '자료실 제목5 입니다.','내용');

commit;

SELECT * FROM mvcboard;

--댓글 저장용 테이블 생성
create table comments (
    idx number primary key, /* 댓글의 일련번호 */
    board_idx number not null, /* 댓글이 작성된 게시물의 일련번호*/
    writer varchar2(30) not null, /* 작성자 아이디 */
    comments varchar2(2000) not null, /* 내용 */
    postdate date default sysdate /* 작성일 */
);
--코드용 코드 입력
INSERT INTO comments (idx, board_idx, writer, comments)
    VALUES (seq_board_num.nextval, ?, ?, ?);
INSERT INTO comments (idx, board_idx, writer, comments)
    VALUES (seq_board_num.nextval, 7, '나', '테스트댓글') ;
    
SELECT * FROM comments;

SELECT * FROM comments WHERE board_idx = 7  ORDER BY idx DESC;