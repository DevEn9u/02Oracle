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
