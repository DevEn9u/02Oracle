/***********
파일명 : Or11Constraint.sql
제약조건
설명 : 테이블 생성시 필요한 여러가지 제약조건에 대해 학습한다.
***********/
--study 계정에서 실습합니다.

/*
primary key : 기본키
- 참조무결성을 유지하기 위한 제약조건
- 하나의 테이블에는 하나의 기본키만 설정할 수 있다.
- 기본키로 설정된 컬럼은 중복된 값이나 Null값을 입력할 수 없다.
- 주로 레코드 하나를 특정하기 위해 사용된다.
*/

/*
형식1] 인라인방식 : 컬럼 생성시 우측에 제약조건을 기술한다.
    create table 테이블명 (
        컬럼명 자료형(크기) [constraint 제약명] primary key
    )
    ※ [] 대괄호 부분은 생략 가능하고, 생략시 제약명을 시스템이
    자동으로 부여한다.
*/
CREATE table tb_primary1 (
    idx number(10) primary key,
    user_id varchar2(30),
    user_name varchar2(50)
);
desc tb_primary1;

/*
제약조건 및 테이블 목록 확인하기
    tab : 현재 계정에 생성된 테이블의 목록을 확인할 수 있다.
    user_cons_columns : 테이블에 지정된 제약조건명과 컬럼명의
        간략한 정보를 저장한다.
    user_constraints : 테이블에 지정된 제약조건의 상세한 정보를 저장한다.
※ 이와 같이 제약조건이나 뷰, 프로시저등의 정보를 저장하고 있는
    시스템 테이블을 '데이터사전'이라고 한다.
*/
select * from tab;
select * from user_cons_columns;
select * from user_constraints;

--레코드 입력
insert into tb_primary1 values(1, 'jongro1', '종각');
insert into tb_primary1 values(2, 'cityhall', '시청');
/* 무결성 제약 조건 위배로 에러가 발생한다. PK로 지정된 컬럼 idx에는
중복된 값을 입력할 수 없다. */
insert into tb_primary1 values(2, 'cityError', '오류발생');

insert into tb_primary1 (idx, user_id, user_name)
    values (3, 'white', '화이트');
/* PK로 지정된 컬럼에는 NULL값을 입력할 수 없다. 에러발생됨 */
insert into tb_primary1 (idx, user_id, user_name)
    values ('', 'black', '블랙');

select * from tb_primary1;
/* update문은 정상이지만 idx 값을 이미 존재하는 2로 변경했으므로
제약조건 위배로 오류가 발생한다.*/
update tb_primary1 set idx = 2 where user_id = 'jongro1';

/*
형식2] 아웃라인 방식
    create table 테이블명 (
        컬럼명 자료형(크기),
        [constraintes 제약명] primary key (컬럼명)
    );
*/
CREATE table tb_primary2 (
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50),
    constraint my_pk1 primary key (user_id)
);
desc tb_primary2;
insert into tb_primary2 values(1, 'jongro1', '종각');
/* PK 지정시 my_pk1이라고 이름을 지정했으므로 에러 발생시 지정한
이름이 콘솔에 출력한다. */
insert into tb_primary2 values(2, 'jongro1', '종각Error');
select * from tb_primary2;

/*
형식3] 테이블 생성 후 alter문으로 제약조건 추가
    alter table 테이블명 add [constraint 제약명]
        primery key (컬럼명);
*/
create table tb_primary3 (
    idx number(10),
    user_id varchar2(30),
    user_name varchar2(50)
);
desc tb_primary3;
/* 테이블을 생성한 후 alter문으로 제약조건을 부여한다. 제약명은
필요에 따라 생략이 가능하다. */
alter table tb_primary3 add constraint tb_primary3_pk
    primary key (user_name);
--데이터 사전에서 제약조건 확인하기
select * from user_constraints;
--제약조건은 테이블을 대상으로 하므로 테이블이 삭제되면 같이 삭제된다.
drop table tb_primary3;
--확인시 휴지통에 들어간 것을 볼 수 있다.
select * from user_cons_columns;

--PK는 테이블당 하나만 생성할 수 있으므로 에러가 발생한다.
create table tb_primary4 (
    idx number(10) primary key,
    user_id varchar2(30) primary key,
    user_name varchar2(50)
);
/* 
unique
- 값의 중복을 허용하지 않는 제약조건
- 숫자, 문자는 중복을 허용하지 않는다.
- 하지만 NULL값에 대해서는 중복을 허용한다.
- unique는 한 테이블에 2개 이상 적용할 수 있다.
*/
create table tb_unique (
    idx number unique not null, /* 인라인 방식으로 지정 */
    user_id varchar2(30),
    telephone varchar2(20),
    nickname varchar2(30),
    unique(telephone, nickname) /* 아웃라인 방식으로 2개 동시 지정 */
);
--데이터 사전에서 생성된 제약조건 확인
select * from user_cons_columns;

insert into tb_unique (idx, name, telephone, nickname)
    values (1, '아이린', '010-1111-1111', '레드벨벳');
insert into tb_unique (idx, name, telephone, nickname)
    values (2, '웬디', '010-2222-2222', '');
insert into tb_unique (idx, name, telephone, nickname)
    values (3, '슬기', '', '');
--unique는 중복을 허용하지 않지만 null은 여러개 입력할 수 있다.
select * from tb_unique;
--idx컬럼에 중복된 값이 입력되므로 오류가 발생한다.
insert into tb_unique (idx, name, telephone, nickname)
    values (2, '예리', '010-3333-3333', '');

insert into tb_unique values(4, '유비', '010-4444-4444', '촉');

insert into tb_unique values(5, '관우', '010-5555-5555', '촉');
--입력 오류 발생
insert into tb_unique values(6, '장비', '010-5555-5555', '촉');
/*
    telephone과 nickname은 동일한 제약명으로 설정되었으므로 두개의
    컬럼이 동시에 동일한 값을 가지는 경우가 아니라면 중복된 값이 허용된다.
    즉, 4번과 5번은 서로 다른 데이터로 인식하므로 입력되고, 6번의 경우에는
    동일한 데이터로 인식되어 에러가 발생한다.
*/

/*
Foreign key : 외래키, 참조키
- 외래키는 참조무결성을 유지하기 위한 제약조건
- 만약 테이블 간 외래키가 설정되어 있다면 자식 테이블에 참조값이
    존재할 경우 부모테이블의 레코드는 삭제할 수 없다.

형식1] 인라인 방식
    create table 테이블명 (
        컬럼명 자료형 [constraint 제약명]
            refernces 부모테이블명 (참조할 컬럼명)
    );
*/
create table tb_foreign1 (
    f_idx number(10) primary key,
    f_name varchar2(50),
    /* 자식테이블인 tb_foreign1에서 부모테이블인 tb_primary2의 
    user_id 컬럼을 참조하는 외래키를 생성한다. */
    f_id varchar2(30) constraint tb_foreign_fk1
        references tb_primary2(user_id)
);
--부모테이블에는 레코드 1개가 삽입되어 있음
select * from tb_primary2;
--자식테이블에는 레코드가 없는 상태
select * from tb_foreign1;
--오류발생. 부모테이블에는 'gildong' 이라는 user_id가 없음.
insert into tb_foreign1 values (1, '홍길동', 'gildong');
--입력성공. 부모테이블에 해당 아이디가 입력되어있음.
insert into tb_foreign1 values (1, '더조은', 'jongro1');
/* 자식테이블에서 참조하는 레코드가 있으므로, 부모테이블의 레코드를
삭제할 수 없다. 이 경우 반ㄷ싀 자식테이블의 레코드를 먼저 삭제한 후
부모테이블의 레코드를 삭제해야 한다. */
delete from tb_primary2 where user_id = 'jongro1';

--자식테이블의 레코드를 먼저 삭제한 후...
delete from tb_foreign1 where f_id = 'jongro1';
--부모테이블의 레코드를 삭제하면 정상 처리된다.
delete from tb_primary2 where user_id = 'jongro1';
/*
    2개의 테이블의 외래키(참조키)가 설정되어 있는 경우
    부모테이블에 참조할 경우 레코드가 없으면 자식테이블에 insert할 수 없다.
    자식테이블에 부모를 참조하는 경우 레코드가 남아있으면 부모테이블의
    레코드를 delete할 수 없다.
*/

/*
형식2] 아웃라인 방식
    create table 테이블명 (
        컬럼명, 자료형,
        [constraint 제약명] forein key (컬럼명)
            references 부모테이블 (참조할 컬럼)
    );
*/
create table tb_foreign2 (
    f_id number primary key,
    f_name varchar2(30),
    f_date date,
    /* tb_foreign2 테이블의 f_id 컬럼이 부모테이블인 tb_primary1의
    idx 컬럼을 참조하는 외래키를 설정한다.*/
    foreign key (f_id) references tb_primary1 (idx)
);
select * from user_constraints;
/*
데이터사전에서 제약조건 확인시 플래그
P : Primary key
R : Reference integrity(참조 무결성), 즉 Foreign key를 뜻한다.
C : Check 혹은 Not Null
U : Unique
*/

/*
형식3] 테이블 생성 후 alter문으로 외래키 제약조건 추가
    alter table 테이블명 add [constraints 제약명]
        foreign key (컬럼명)
            references 부모테이블 (참조컬럼명)
*/
create table tb_foreign3 (
    f_id number primary key,
    f_name varchar2(30),
    f_idx number(10)
);

alter table tb_foreign3 add
    foreign key (f_idx) references tb_primary1 (idx);
/* 현재 tb_primary1 테이블은 tb_foreign2를 자식으로 둔 상태.
하나의 부모테이블에 둘 이상의 자식테이블이 외래키를 설정할 수 있다. */

/*
외래키 삭제시 옵션
[on delete cascade]
    : 부모레코드 삭제시 자식레코드까지 같이 삭제된다. 
    형식]
        컬럼명 자료형 references 부모테이블 (pk컬럼)
            on delete cascade;
[on delete set null]
    : 부모레코드 삭제시 자식레코드 값이 null로 변경된다.
    형식]  
        컬럼명 자료형 references 부모테이블 (pk컬럼)
            on delete set null            
            
※ 실무에서 스팸게시물을 남긴 회원과 그 게시글을 일괄적으로 삭제해야할때
사용할 수 있는 옵션이다. 단, 자식테이블의 모든 레코드가 삭제되므로 사용에
주의해야한다.
*/
create table tb_primary4 (
    user_id varchar2(30) primary key,
    user_name varchar2(100)
);
create table tb_foreign4 (
    f_idx number(10) primary key,
    f_name varchar2(30),
    user_id varchar2(30) constraint tb_foreign4_fk
        references tb_primary4 (user_id)
            on delete cascade
);
insert into tb_primary4 values ('stu1', '훈련생');
insert into tb_foreign4 values (1, '스팸1', 'stu1');
insert into tb_foreign4 values (2, '스팸2', 'stu1');
insert into tb_foreign4 values (3, '스팸3', 'stu1');
insert into tb_foreign4 values (4, '스팸4', 'stu1');
insert into tb_foreign4 values (5, '스팸5', 'stu1');
--레코드 확인하기
select * from tb_primary4;
select * from tb_foreign4;
/* 부모테이블에서 레코드를 삭제할 경우 on delete cascade 옵션에 의해
자식쪽까지 모든 레코드가 삭제된다. 만약 해당 옵션을 부여하지 않았다면
레코드는 삭제되지 않고 오류가 발생하게 된다.*/
delete from tb_primary4 where user_id = 'stu1';
--부모, 자식 테이블의 모든 레코드가 삭제된 것을 확인할 수 있다.
select * from tb_primary4;
select * from tb_foreign4;


------------------------------------------------------------
--on delete set null 옵션 테스트
create table tb_primary5 (
    user_id varchar2(30) primary key,
    user_name varchar2(100)
);
create table tb_foreign5 (
    f_idx number(10) primary key,
    f_name varchar2(30),
    user_id varchar2(30) constraint tb_foreign5_fk
        references tb_primary5 (user_id)
            on delete set null
);
--부모테이블에 먼저 데이터 입력
insert into tb_primary5 values ('stu1', '훈련생');
--그리고 자식테이블에 데이터 입력
insert into tb_foreign5 values (1, '스팸1', 'stu1');
insert into tb_foreign5 values (2, '스팸2', 'stu1');
insert into tb_foreign5 values (3, '스팸3', 'stu1');
insert into tb_foreign5 values (4, '스팸4', 'stu1');
insert into tb_foreign5 values (5, '스팸5', 'stu1');
--레코드 확인
select * from tb_primary5;
select * from tb_foreign5;
/* on delete set null 옵션으로 자식테이블의 레코드는 삭제되지 않고
참조키 부분만 null값으로 변경된다. 따라서 더이상 참조할 수 없느 레코드로
변경된다. */
delete from tb_primary5 where user_id = 'stu1';
--부모테이블의 레코드는 삭제된다.
select * from tb_primary5;
--자식테이블의 레코드는 남아있다. 단 참조컬럼이 null로 변경된다.
select * from tb_foreign5;

/*
not null: null값을 허용하지 않는 제약조건
형식]
    create table 테이블명(
        컬럼명 자료형 not null,
        컬럼명 자료형 null => null을 허용한다는 의미로 작성했지만
                            이렇게 사용하지 않는다. null을 기술하지
                            않으면 자동으로 허용한다는 의미이다.
    );
*/
create table tb_not_null(
    idx number(10) primary key, /* PK이므로 NN(Not Null) */
    id varchar2(20) not null, /* NN */
    pw varchar2(30) null, /* Null 허용, 일반적으로 이렇게 쓰지 않음 */
    name varchar2(40) /*  Null 허용, 이와 같이 선언한다,. */
);
desc tb_not_null;

insert into tb_not_null values (1, 'hong1', '1111', '홍길동');
insert into tb_not_null values (2, 'hong2', '2222', '');
insert into tb_not_null values (3, 'hong3', '', '');
--id는 NN으로 지정되었기 때문에 Null값을 입력할 수 없다. 에러발생
insert into tb_not_null values (4, '', '', '');
--입력 성공. space도 문자이므로 입력된다.
insert into tb_not_null values (5, ' ', '5555', '오길동');
/* insert 쿼리에서 컬럼을 명시하지 않으면 Null값이 입력된다. 따라서
idx 컬럼에는 Null을 입력할 수 없으므로 에러가 발생한다. */
insert into tb_not_null (id, pw, name) values ('hong6', '6666', '육길동');

select * from tb_not_null;


/*
default : insert시 아무런 값도 입력하지 않았을 때 자동으로 삽입되는
    데이터를 지정할 수 있다.
*/
create table tb_default(
    id varchar2(30) not null,
    pw varchar2(50) default 'qwer'
);
select * from tb_default;
insert into tb_default values ('aaa', '1234'); --pw에 1234 입력됨
insert into tb_default (id) values ('bbb'); --컬럼을 제외하면 default값 입력됨
insert into tb_default values ('ccc', ''); --null값 입력됨
insert into tb_default values ('ddd', ' '); --공백(space) 입력됨
insert into tb_default values ('eee', default); --defualt값 입력됨
/*
    default값을 입력하려면 insert문에서 컬럼 자체를 제외시키거나
    default 키워드를 입력해야 한다.
*/

/*
check : Domain(자료형) 무결성을 유지하기 위한 제약조건으로 해당 컬럼에
    잘못된 데이터가 입력되지 않도록 유지하는 제약조건이다.
*/
create table tb_check1(
    gender char(1) not null
        constraint check_gender
            check (gender in ('M','F'))
);
insert into tb_check1 values ('M');
insert into tb_check1 values ('F');
-- check 제약조건 위배로 오류발생됨(M, F만 입력 가능)ㅌ
insert into tb_check1 values ('T');
-- 입력된 데이터('Trnas')가 컬럼(gender)의 크기(1)보다 크므로 오류 발생됨.
insert into tb_check1 values ('Trans');
select * from tb_check1;

--10 이하의 값만 입력할 수 있는 check 제약조건 지정
create table tb_check2 (
    sale_count number not null
        check (sale_count <= 10)
);
--9와 10은 입력 성공
insert into tb_check2 values (9);
insert into tb_check2 values (10);
--11은 제약조건 위배로 입력실패. 오류발생됨.
insert into tb_check2 values (11);


