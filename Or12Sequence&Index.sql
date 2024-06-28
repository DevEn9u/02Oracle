/***********
파일명 : Or12Sequence&Index.sql
시퀀스 & 인덱스
설명 : 테이블의 기본기 필드에 순차적인 일련번호를 부여하는 시퀀스와
    검색속도를 향상시킬 수 있는 인덱스
***********/

--Study 계정에서 학습합니다.

/*
시퀀스(Sequence)
- 테이블의 컬럼(필드)에 중복되지 않는 순차적인 일련번호를 부여한다.
- 시퀀스는 테이블 생성 후 별도로 만들어야 한다. 즉 시퀀스는 테이블과
    독립적으로 저장되고 생성된다.
    
[시퀀스 생성구문]
create sequence 시퀀스명
    [Increment by N] => 증가치 설정
    [Start with N] => 시작값 지정
    [Minvalue n | NoMinvalue] => 시퀀스 최솟값 지정 : default1
    [Maxvalue n | NoMaxvalue] => 시퀀스 최댓값 지정 : default1.00E + 28
    [Cycle | NoCycle] => 최대/최소값에 도달할 경우 처음부터 다시
                        시작할지 여부를 설정(cycle로 지정하면 최댓값까지
                        증가후 다시 시작값부터 재시작됨)
    [Cache | NoCache => cache 메모리에 오라클서버갑 시퀀스값을
                        할당하는가 여부를 지정               

시퀀스 생성시 주의사항
1) start with에 minvalue보다 작은 값을 지정할 수 없다. 즉 start with값은
minvalue와 같거나 커야 한다.
2) nocycle로 설정하고 시퀀스를 계속 얻어올 때 maxvalue에 지정값을
초과하면 에러가 발생한다.
3) primary key에는 cycle 옵션을 절대 지정하면 안된다.
*/

create table tb_goods (
    idx number(10) primary key,
    g_name varchar2(30)
);
insert into tb_goods values (1, '허니버터칩');
-- idx는 PK로 지정된 컬럼이므로 중복값이 입력되면 에러 발생됨
insert into tb_goods values (1, '먹태깡');

--시퀀스 생성
CREATE SEQUENCE seq_serial_num
    INCREMENT BY 1  /* 증가치 : 1 */
    START WITH 100  /* 초기값(시작값) : 100 */
    MINVALUE 99     /* 최솟값 : 99 */
    MAXVALUE 110    /* 최댓값 : 110 */
    CYCLE           /* 최댓값 도달시 최솟값부터 재시작할지 여부 : Yes */
    NOCACHE;        /* 캐시메모리 사용 여부 : No */

--데이터사전에서 생성된 시퀀스 정보 확인
SELECT * FROM user_sequences;
/* 시퀀스 생성 후 최초 실행시에는 CURRVAL을 실행할 수 없어 에러가 발생한다.
NEXTVAL을 먼저 실행해서 시퀀스를 얻어온 후 사용해야 한다. */
SELECT seq_serial_num.CURRVAL FROM dual;
/* 다음 입력할 시퀀스를 반환한다. 실행할 때마다 설정한 증가치만큼 증가된
값이 반환된다. */
SELECT seq_serial_num.NEXTVAL FROM dual;
/*
시퀀스의 NEXTVAL을 사용하면 계속 새로운 값을 반환하므로 아래와 같이
INSERT문에 사용할 수 있다. 또한 같은 문장을 여러번 실행하더라도 문제없이
입력된다.
*/
insert into tb_goods values (seq_serial_num.NEXTVAL, '먹태깡');
/*
단, 시퀀스의 CYCLE 옵션에 의해 최댓값에 도달하면 다시 처음부터 시퀀ㅅ스가
생성되므로 무결성 제약 조건에 위밴되어 에러가 발생한다.
즉 PK 컬럼에 사용할 시퀀스는 CYCLE 옵션을 사용하면 안된다.
*/
SELECT * FROM tb_goods;

/*
시퀀스 수정 : 테이블과 동일하게 ALTER 명령어 사용
    단, START WITH는 수정할 수 없다.

형식] ALTER SEQUENCE 시퀀스명
        [Increment by N] => 증가치 설정
        [Minvalue n | NoMinvalue]
        [Maxvalue n | NoMaxvalue] 
        [Cycle | NoCycle]
        [Cache | NoCache
*/
ALTER SEQUENCE seq_serial_num
    INCREMENT BY 1
    MINVALUE 99
    NOMAXVALUE /* 최댓값을 사용하지 않음 => 시퀀스가 표현할 수 있는 최대범위 사용 */
    NOCYCLE /* CYCLE 사용하지 않음 */
    NOCACHE; /* CACHE 메모리 사용하지 않음 */

--시퀀스 삭제
DROP SEQUENCE seq_serial_num;
SELECT * FROM user_sequences;

/*
일반적인 시퀀스 생성은 아래와 같이 하면 된다.
PK로 지정된 컬럼에 일련번호를 입력하는 용도로 주로 사용되므로
MAXVALUE, CYCLE, CACHE는 사용하지 않는 것을 권장한다.
*/
CREATE SEQUENCE seq_serial_num
    INCREMENT BY 1
    START WITH 1
    MINVALUE 1
    NOMAXVALUE
    NOCYCLE
    NOCACHE;

/*
인덱스(INDEX)
- 행의 검색속도를 향상시킬 수 있는 개체
- 인덱스는 명시적(CREATE INDEX)과 자동적(PRIMARY KEY, UNIQUE)으로
    생성할 수 있다.
- 컬럼에 대한 인덱스가 없으면 테이블 전체를 검색한다.
- 즉 인덱스는 쿼리의 성능을 향상시키는 것이 목적이다.
- 인덱스는 아래와 같은 경우세 설정한다.
    1) WHERE 조건이나 JOIN 조건에 자주 사용하는 컬럼
    2) 광범위한 값을 포함하는 컬럼
    3) 많은 NULL값을 포함하는 컬럼
*/

--인덱스 생성
CREATE INDEX tb_goods_name_idx ON tb_goods (g_name);
/* 데이터 사전에서 인덱스 정보 확인. 결과를 보면 PK 혹은 UNIQUE로
지정된 컬럼은 자동으로 인덱스가 생성되어 있는 것을 볼 수 있다. */
SELECT * FROM user_ind_columns;
--인덱스 삭제
DROP INDEX tb_goods_name_idx;
/*
    인덱스는 수정이 불가능하다. 필요하다면 삭제 후 다시 생성해야 한다.
*/
