/**********
파일명 : Or15PLSQL.sql
PL/SQL
설명 : 오라클에서 제공하는 프로그래밍 언어
**********/


/*
PL/SQL(Procedural Language)
:일반 프로그래밍 언어에서 가지고 있는 요소를 모두 가지고 있으며
DB업무를 처리하기 위해 최적화된 언어이다.
*/
--HR계정에서 실습합니다.

--예제1] PL/SQL 맛보기
--화면상에 내용을 출력하고 싶을 때 ON으로 설정한다. OFF일때는 출력되지 않는다.
SET SERVEROUTPUT ON;

DECLARE --선언부 : 주로 변수를 선언한다.
    cnt NUMBER;
BEGIN --실행부 : 실행을 위한 로직을 기술한다.
    cnt := 10; --변수에 10을 대입. :=로 사용해야 한다.
    cnt := cnt + 1;
    dbms_output.put_line(cnt); --Java의 println()과 동일하다.
END;
/
/*
    PL/SQL 문장 끝에는 반드시 '/'를 붙여야 한다. 만약 존재하지 않으면
    호스트 환경으로 빠져나오지 못한다. 즉 PL/SQL문장을 탈출하기 위해 필요하다.
    호스트 환경: 쿼리문을 입력하기 위한 SQL> 프롬프트가 있는 상태
*/

--예제2] 일반변수 및 INTO
/* 시나리오] 사원테이블에서 사원번호가 120인 사원의 이름과 연락처를
출력하는 PL/SQL문을 작성하시오. */
SELECT * FROM employess WHERE employees_id = 120;
--시나리오 조건에 맞는 SELECT문을 작성한다.
SELECT CONCAT(first_name || ' ', last_name), phone_number
FROM employees WHERE employees_id = 120;

DECLARE
    /* 선언부에서 변수를 선언할 때는 테이블 생성시와 동일하게 선언한다.
    → 변수명 자료형(크기);
    단 기존에 생성된 컬럼의 타입과 크기를 참조하여 선언하는 것이 좋다.
    아래 '이름'의 경우 2개의 컬럼이 합쳐진 상태이므로 조금 더 넉넉한 크기로
    설정해주는 것이 좋다.*/
    empName VARCHAR2(50);
    empPhone VARCHAR2(30);
BEGIN
    /*
    실행부: SELECT절에서 가져온 결과를 선언부에서 선언한 변수에 1:1로
        대입하여 값을 저장한다. 이때 INTO를 사용한다.
    */
    SELECT
        CONCAT(first_name || ' ', last_name),
        phone_number
    INTO
        empName, empPhone
    FROM employees
    WHERE employee_id = 120;
    
    dbms_output.put_line(empName || ' ' || empPhone);
END;
/

--예제3] 참조변수1(하나의 컬럼 참조)
/*
    참조변수: 특정 테이블의 컬럼을 참조하는 변수로, 동일한 자료형과 크기로
        선언하고 싶을 때 사용한다.
        형식] 테이블명.컬럼명%type
            → 특정 테이블에서 '하나'의 컬럼만 참조한다.
*/
/*
시나리오] 부서번호 10인 사원의 사원번호, 급여, 부서번호를 가져와서
아래 변수에 대입후 화면상에 출력하는 PL/SQL문을 작성하시오.
단, 변수는 기존테이블의 자료형을 참조하는 '참조변수'로 선언하시오.
*/
--조건에 맞는 쿼리문 작성
SELECT employee_id, salary, department_id FROM employees
    WHERE department_id = 10;
    
DECLARE
    --사원테이블의 특정 컬럼의 타입과 크기를 그대로 참조하는 변수로 선언
    empId employees.employee_id%type; --NUMBER(6,0)과 같이 동일하게 선언됨.
    empSal employees.salary%type; --NUMBER(8,2)과 같이 동일하게 선언됨.
    deptId employees.department_id%type;
BEGIN
    SELECT employee_id, salary, department_id
        into empId, empsal, deptId
    FROM employees
    WHERE department_id = 10;
    
    dbms_output.put_line(empId || ' ' || empSal || ' ' || deptId);
END;
/

--예제4] 참조변수2(전체  컬럼 참조)
/*
시나리오] 사원번호가 100인 사원의 레코드를 가져와서
emp_row변수에 전체컬럼을 저장한 후 화면에 다음 정보를 출력하시오.
단, emp_row는 사원테이블이 전체컬럼을 저장할 수 있는 참조변수로 선언해야한다. 
출력정보 : 사원번호, 이름, 이메일, 급여
*/
DECLARE
    /* 사원테이블의 전체컬럼을 참조하는 참조변수로 선언한다.
    테이블명 뒤에 %rowtype을 붙여주면 된다. */
    emp_row employees%rowtype;
BEGIN
    /* 와일드카드 *를 통해 얻어온 전체컬럼을 변수 emp_row에 한번에 
    저장할 수 있다.*/
    SELECT *
        INTO emp_row
    FROM employees WHERE employee_id = 100;
    /* emp_row에는 전체컬럼의 정보가 저장되므로 출력시 변수명.컬럼명 형태로
    기술해야 한다.*/
    
    dbms_output.put_line(emp_row.employee_id || ' ' ||
                        emp_row.first_name || ' ' ||
                        emp_row.email || ' ' ||
                        emp_row.salary);
END;
/

--예제5] 복합변수
/*
복합변수
    :class를 정의하듯 필요한 자료형을 몇가지를 묶어서 생성하는 변수
    형식]
        type 복합변수자료형 IS RECORD(
            컬럼명1 자료형(크기),
            컬럼명2 테이블명.컬럼명%type
        );
    앞에서 선언한 자료형을 기반으로 변수를 생성한다.
    복합변수 자료형을 만들 때는 일반변수와 참조변수 2가지를 복합해서
    사용할 수 있다.
*/
-- 이름은 concat으로 연결한 후 출력한다.
SELECT employee_id, first_name || ' ' || last_name, job_id
FROM employees WHERE employee_id = 100;

DECLARE
    -- 3개의 값을 저장할 수 있는 복합변수자료형을 선언한다.
    TYPE emp_3type IS RECORD(
        /* 사원테이블을 참조하는 참조변수로 선언 */
        emp_id employees.employee_id%type,
        /* 일반변수로 선언 */
        emp_name VARCHAR2(50),
        emp_job employees.job_id%type
    );
    /* 앞에서 생성한 자료형을 통해 복합변수를 선언한다. 이 변수는 3개의 값을
    저장할 수 있다. */
    record3 emp_3type;
BEGIN
    SELECT employee_id, first_name || ' ' || last_name, job_id
        INTO record3
    FROM employees WHERE employee_id = 100;
    
    dbms_output.put_line(record3.emp_id || ' ' ||
                       record3.emp_name || ' ' ||
                       record3.emp_job);
END;
/

/*아래 절차에 따라 PL/SQL문을 작성하시오.
1.복합변수생성
- 참조테이블 : employees
- 복합변수자료형의 이름 : empTypes
        멤버1 : emp_id -> 사원번호
        멤버2 : emp_name -> 사원의전체이름(이름+성)
        멤버3 : emp_salary -> 급여
        멤버4 : emp_percent -> 보너스율
위에서 생성한 자료형을 이용하여 복합변수 rec2를 생성후 사원번호 108번의 정보를 할당한다.
2.1의 내용을 출력한다.
3.위 내용을 완료한후 치환연산자를 사용하여 사원번호를 사용자로부터
입력받은 후 해당 사원의 정보를 출력할수있도록 수정하시오.[보류]
*/
--퀴즈에서 주어진 조건을 만족하는 쿼리문 작성
SELECT
    employee_id, first_name || ' ' || last_name, salary,
    nvl(commission_pct, 0)
FROM employees WHERE employee_id = 108;


DECLARE
    TYPE empTypes IS RECORD(
        -- 4개의 벰버를 가진 복합변수자료형 선언
        emp_id employees.employee_id%type,
        emp_name VARCHAR2(50),
        emp_salary employees.salary%type,
        emp_percent employees.commission_pct%type
    );
    -- 복합변수자료형을 통해 변수를 생성한다.
    rec2 empTypes;
BEGIN
    SELECT
        employee_id,
        first_name || ' ' || last_name,
        salary,
        commission_pct
        INTO rec2
    FROM employees WHERE employee_id = 108;
    
    dbms_output.put_line('사원번호 / 사원명 / 급여 / 보너스율');
    dbms_output.put_line(rec2.emp_id || ' ' ||
                       rec2.emp_name || ' ' ||
                       rec2.emp_salary || ' ' ||
                       rec2.emp_percent);
END;
/


/*
치환연산자 : PL/SQL에서 사용자로부터 데이터를 입력받을 때 사용하는 연산자로
    변수앞에 &를 붙여주면 된다. 실행시 입력창이 뜬다.
*/
DECLARE
    TYPE empTypes IS RECORD(
        -- 4개의 벰버를 가진 복합변수자료형 선언
        emp_id employees.employee_id%type,
        emp_name VARCHAR2(50),
        emp_salary employees.salary%type,
        emp_percent employees.commission_pct%type
    );
    -- 복합변수자료형을 통해 변수를 생성한다.
    rec2 empTypes;
    -- 치환연산자를 통해 입력받은 값을 할당할 변수를 선언한다.
    inputNum number(3);
BEGIN
    SELECT
        employee_id,
        first_name || ' ' || last_name,
        salary,
        commission_pct
        INTO rec2
    FROM employees WHERE employee_id = &inputNum;
    
    dbms_output.put_line(rec2.emp_id || ' ' ||
                       rec2.emp_name || ' ' ||
                       rec2.emp_salary || ' ' ||
                       rec2.emp_percent);
END;
/

-- 예제6] 바인드변수
/*
바인드변수
    : 호스트 환경에서 선언된 변수로, 비 PL/SQL 변수이다.
      호스트 환경이란 PL/SQL 블럭을 제외한 나머지 부분을 말한다.
      콘솔에서는 SQL> 프롬프트가 있는 상태를 말한다.
      형식]
        var 변수명 자료형;
        혹은
        variable 변수명 자료형;
*/
set serveroutput on;
-- 호스트 환경에서 바인드 변수 선언
VAR return_var = NUMBER;

DECLARE -- 선언부에서는 이와 같이 아무 내용이 없을 수도 있다.
BEGIN
    -- 바인드변수는 일반변수와의 구분을 위해 :(colon)을 추가해야 한다.
    :return_var := 999;
    dbms_output.put_line(:return_var);
END;
/

PRINT return_var;
/*
호스트 환경에서 바인드 변수를 출력할 때는 PRINT를 사용한다.
CMD에서는 개별적으로 실행해도 문제가 없지만, developer에서는 바인드 변수로부터
마지막 PRINT문까지 블럭으로 묶은 후 실행해야 결과가 정상적으로 나온다.
*/