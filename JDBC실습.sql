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
