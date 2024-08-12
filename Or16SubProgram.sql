/**********
파일명 : Or16SubProgram.sql
PL/SQL
설명 : 오라클에서 제공하는 저장 프로시져, 함수, 그리고 프로시조 일종인
        트리거를 학습
**********/

/*
서브 프로그램(Sub Program)
- PL/SQL에서는 procedure와 함수라는 두가지 유형의 Sub Program이 있다.
- SELECT를 포함해서 다른 DML문을 이용하여 프로그래밍적인 요소를 통해
    사용 가능하다.
- Trigger는 Procedure의 일종으로 특정 레이블의 레코드의 변화가 있을 경우
    자동으로 실행된다.
- 함수는 쿼리문의 일부분으로 사용하기 위해 생성한다. 즉 외부 프로그램에서
    호출하는 경우는 거의 없다.
- procedure는 외부 프로그램에서 호출하기 위해 생성한다. 따라서 Java, JSP
    등에서 간단한 호출로 복잡한 쿼리를 실행할 수 있다.
*/

/*
1. 저장 프로시져(Stored Procedure)
- procedure는 return 문이 없는 대신 out 파라미터를 통해 값을 반환한다,
- 보안성을 높일 수 있고, 네트워크의 부하를 줄일 수 있다.
형식= CREATE[OR REPLACE] PROCEDURE 프로시저명
     [(매개변수 in 자료형, 매개변수 out 자료형)}
     IS [변수선언]
     BEGIN
        실행문장;
     END;
     /
※ 파리미터 설정시 자료형만 명시하고, 크기는 명시하지 않는다.
*/

--예제1] 사원의 급여를 가져와서 출력하는 프로시저 생성
--시나리오] 100번 사원의 급여를 select하여 출력하는 저장프로시저를 생성하시오.
--프로시저는 생성시 'OR REPLACE'를 추가하는 것이 바람직하다.
CREATE OR REPLACE PROCEDURE pcd_emp_salary
IS
    /*
    PL/SQL에서는 DECLARE절에 변수를 선언하지만, 프로시저에서는 IS절에서 선언한다.
    만약 변수가 없다면 내용을 생략할 수 있다.
    */
    --employees 테이블의 salary 컬럼을 참조하는 참조변수로 생성한다.
    v_salary employees.salary%type;
BEGIN
    --employee_id가 100번인 사원의 salary를 'INTO'를 이용해서 변수에 저장한다.
    SELECT salary INTO v_salary
    FROM employees
    WHERE employee_id = 100;
    
    dbms_output.put_line('사원번호 100의 급여는 : ' || v_salary || '입니다.');
END;
/

-- 데이터 사전에서 확인한다. 저장시 대문자로 저장되므로 변환함수를 이용한다.
SELECT * FROM user_source WHERE name LIKE UPPER('%pcd_emp_salary');

-- 첫 실행일 경우 최초로 한번 실행해야 출력이 된다.
SET SERVEROUTPUT ON;
-- 프로시저의 호출은 호스트 환경에서 EXECUTE 명령을 이용한다.
EXECUTE pcd_emp_salary;

--예제2] IN파라미터 사용하여 프로시저 생성
/*
시나리오] 사원의 이름을 매개변수로 받아서 사원테이블에서 레코드를 조회한후
해당사원의 급여를 출력하는 프로시저를 생성 후 실행하시오.
해당 문제는 in파라미터를 받은후 처리한다.
사원이름(first_name) : Bruce, Neena
*/
--PROCEDURE 생성시 IN 파라미터를 설정. first_name을 참조하는 참조변수로 param_name 선언
CREATE OR REPLACE PROCEDURE pcd_in_param_salary
    (param_name in employees.first_name%type)
IS
    valSalary NUMBER(10);
BEGIN
    --IS에서 생성한 변수 valSalary에 쿼리의 결과를 저장
    SELECT salary INTO valSalary
    FROM employees WHERE first_name = param_name;
    --결과 출력
    dbms_output.put_line(param_name || '의 급여는 ' || valSalary || ' 입니다.');
END;
/
--데이터사전에서 확인
SELECT * FROM user_source WHERE name LIKE UPPER('%pcd_in_param_salary');
--EXECUTE 명령어로 PROCEDURE 실행
EXECUTE pcd_in_param_salary('Bruce');
EXECUTE pcd_in_param_salary('Neena');


--예제3] OUT파라미터 사용하여 프로시저 생성
/*
시나리오] 위 문제와 동일하게 사원명을 매개변수로 전달받아서 급여를 조회하는
프로시저를 생성하시오. 단, 급여는 out파라미터를 사용하여 반환후 출력하시오
*/
/*
두가지 형식의 파라미터를 정의. 일반변수, 참조변수를 각각 사용해서 선언
파라미터는 용도에 따라 IN, OUT을 명시하고, 크기는 별도로 명시하지 않는다.
*/
CREATE OR REPLACE PROCEDURE pcd_out_param_salary
    (
        param_name IN VARCHAR2,
        param_salary OUT employees.salary%TYPE
    )
IS
    /* SELECT한 결과를 OUT 파라미터에 저장할 것이므로 별도의 변수가 필요하지 않아
    IS절은 비워둔다.*/
BEGIN
    /* IN 파라미터는 WHERE절의 조건으로 사용하고, SELECT한 결과는 INTO절에서
    OUT 파라미터에 저장한다.*/
    SELECT salary INTO param_salary
    FROM employees WHERE first_name = param_name;
END;
/
--호스트환경에서 바인드 변수를 선언한다. variable을 사용해도 된다.
VAR v_salary VARCHAR2(30);
/* 프로시저 호출시 각각의 파라미터를 사용한다. 특히 바인드변수는 :을 붙여야 한다.
OUT 파라미터인 param_salary에 저장된 값이 v_salary로 전달된다. */
EXECUTE pcd_out_param_salary('Matthew', :v_salary);
--프로시저 실행 후 OUT 파라미터를 통해 전달된 값을 출력한다. 
PRINT v_salary;

/*****
실습을 위해 employees 테이블을 레코드까지 전체 복사한다.
복사할 테이블명 : zcopy_employees
*****/
CREATE TABLE zcopy_employees
AS
SELECT * FROM employees WHERE 1 = 1;
DESC zcopy_employees;
SELECT COUNT(*) FROM zcopy_employees;

/*
시나리오] 사원번호와 급여를 매개변수로 전달받아 해당사원의 급여를 수정하고,
실제 수정된 행의 갯수를 반환받아서 출력하는 프로시저를 작성하시오.
*/
/* IN 파라미터는 사원번호와 급여를 전달받는다. OUT 파라미터는 UPDATE가
적용된 행의 개수를 반환하는 용도로 선언한다. */
CREATE OR REPLACE PROCEDURE pcd_update_salary
    (
        p_empid IN NUMBER,
        p_salary IN NUMBER,
        rCount OUT NUMBER
    )
IS --추가적인 변수 선언이 필요없으므로 생략
BEGIN
    --실제 업데이트를 처리하는 쿼리문으로 IN 파라미터를 통해 값을 설정한다.
    UPDATE zcopy_employees
        SET salary = p_salary
        WHERE employee_id = p_empid;
    
    /*
    SQL%notFound : 쿼리 실행 후 적용된 행이 없을 경우 TRUE 반환
        Found는 반대의 경우 반환
    SQL%rowCount : 쿼리 실행 후 적용된 행의 개수 반환
    */
    IF SQL%notFound THEN
        dbms_output.put_line(p_empId || '은/는 없는 사원입니다.');
    ELSE
        dbms_output.put_line(SQL%rowCount || '명의 자료가 수정되었습니다.');
        
        --실제 적용된 행의 개수를 반환하여 OUT 파라미터에 저장한다.
        rCount := SQL%rowCount;
    END IF;
    /*
    행의 변화가 있는 쿼리를 실행할 경우 반드시 COMMIT 해야 실제 테이블에
    적용되어 Oracle 외부에서 확인할 수 있다.
    */
    COMMIT;
END;
/
-- 프로시저 실행을 위한 바인드 변수 생성
VARIABLE r_count NUMBER;
-- 100번 사원의 이름과 급여를 확인한다.
SELECT first_name, salary FROM zcopy_employees WHERE employee_id = 100;
-- PROCEDURE 실행. 바인드변수에는 반드시 COLON(:)을 붙여야 한다.
EXECUTE pcd_update_salary(100, 30000, :r_count);
-- UPDATE가 적용된 행의 개수 확인
PRINT r_count;
SELECT first_name, salary FROM zcopy_employees WHERE employee_id = 100;

-----------------------------------------
/*
2. 함수(Function)
- 사용자가 PL/SLQ문을 사용하여 오라클에서 제공하는 내장함수와 같은
  기능을 정의한 것이다.
- 함수는 IN 파라미터만 사용할 수 있고, 반드시 반환될 값의 자료형을
  명시해야 한다.
- 프로시저는 여러개의 결과값을 얻어올 수 있지만, 함수는 반드시 하나의
  값을 반환해야 한다.
- 함수는 쿼리문의 일부분으로 사용된다.
※ 파라미터와 반환타입을 명시할 때 크기는 기술하지 않는다.
*/

/*
시나리오] 2개의 정수를 전달받아서 두 정수 사이의 모든 수를 더해서
결과를 반환하는 함수를 정의하시오.
실행예) 2, 7 -> 2+3+4+5+6+7 = ??
*/
-- 함수는 IN 파라미터만 있으므로 IN은 주로 생략한다.
CREATE OR REPLACE FUNCTION calSumBetween (
    num1 IN NUMBER,
    num2 NUMBER
)
RETURN
    -- 함수는 반환값이 필수이므로 반드시 반환타입을 명시해야 한다.
    NUMBER
IS
    -- 변수 선언(선택사항 : 필요없는 경우 생략 가능)
    sumNum NUMBER;
BEGIN
    sumNum := 0;
    
    -- FOR 루프문으로 숫자 사이의 합을 계산한 후 반환
    FOR i IN num1 .. num2 LOOP
        sumNum := sumNum + i;
    END LOOP;
    -- 결과를 반환한다.
    RETURN sumNum;
END;
/
-- 실행방법1 : 쿼리문의 일부로 사용한다.
SELECT calSumBetween(1, 10) FROM dual;

-- 실행방법2 : 바인드 변수를 통한 실행명령으로 주로 디버깅용으로 사용한다.
VAR hapText VARCHAR2(50);
EXECUTE :hapText := calSumBetween(1, 100);
PRINT hapText;

-- 데이터 사전에서 확인하기
SELECT * FROM user_source WHERE name = upper('calSumBetween');

/*
연습문제] 
퀴즈] 주민번호를 전달받아서 성별을 판단하는 함수를 정의하시오.
999999-1000000 -> '남자' 반환
999999-2000000 -> '여자' 반환
단, 2000년 이후 출생자는 3이 남자, 4가 여자임.
함수명 : findGender()
*/
--substr() 함수를 통해 성별에 해당하는 문자 하나를 잘라낸다.
SELECT SUBSTR('999999-1000000', 8, 1) FROM dual;

CREATE OR REPLACE FUNCTION findGender (ssn VARCHAR2)
-- 반환타입은 VARCHAR2
RETURN VARCHAR2
IS
    -- 주빈번호에서 성별에 해당하는 문자를 잘라 저정할 judgeGender 변수 선언
    judgeGender VARCHAR2(10);
    -- 리턴값을 저장할 변수
    returnVal VARCHAR2(50);
BEGIN
    judgeGender := substr(ssn, 8, 1);
    /*
    [선생님 답변]
    if judgeGender = '1' then
        returnVal := '남자';
    elsif judgeGender = '3' then
        returnVal := '남자';
    elsif judgeGender = '2' then
        returnVal := '여자';
    elsif judgeGender = '4' then
        returnVal := '여자';
    else returnVal := '알 수 없음';
    */
    
    IF judgeGender IN ('1', '3') THEN
        returnVal := '남자';
    ELSIF judgeGender IN ('2', '4') THEN
        returnVal := '여자';
    ELSE
        returnVal := '잘못된 주민번호';
    END IF;
    -- 함수는 반드시 반환값이 있어야 한다.
    RETURN returnVal;
END;
/
--실행확인
select findGender('999999-1000000') from dual;
select findGender('999999-3000000') from dual;
select findGender('999999-4000000') from dual;
select findGender('999999-6000000') from dual;

/*
시나리오] 사원의이름(first_name)을 매개변수로 전달받아서
부서명(department_name)을 반환하는 함수를 작성하시오.
함수명 : func_deptName
*/

-- 1단계 : 2개의 테이블을 JOIN 해서 결과 확인
SELECT
    first_name, last_name, department_id, department_name
FROM employees INNER JOIN departments USING(department_id)
WHERE first_name = 'Nancy';

-- 2단계 : 함수 작성(사원의 이름을 인파라미터로 정의)
CREATE OR REPLACE FUNCTION func_deptName (
    param_name VARCHAR2
)
RETURN
    -- 부서명을 반환하므로 문자형으로 반환타입 선언
    VARCHAR2
IS
    -- 부서테이블을 부서명으로 참조하는 참조변수 선언
    return_deptname departments.department_name%TYPE;
BEGIN
    --USING을 사용한 INNER JOIN을 통해 부서명을 인출하여 변수에 저장하는 쿼리문 작성
    SELECT
        department_name INTO return_deptname
    FROM employees INNER JOIN departments USING(department_id)
    WHERE first_name = param_name;
    
    RETURN return_deptname;
END;
/
SELECT func_deptName('Nancy') FROM dual;
SELECT func_deptName('Diana') FROM dual;
------------------------------------------------
/*
3. Trigger
- 자동으로 실행되는 procedure로 직접 실행은 불가능하다.
- 주로 테이블에 입력된 레코드의 변화가 있을 때 자동으로 실행된다.
*/

-- Trigger 실습을 위해 departments 테이블을 복사한다.
-- original 테이블은 레코드까지 전체를 복사.
CREATE TABLE trigger_dept_original
AS
SELECT * FROM departments;

-- backup 테이블은 스키마(구조)만 복사.
CREATE TABLE trigger_dept_backup
AS
SELECT * FROM departments WHERE 1 = 0;
--레코드 확인
SELECT * FROM trigger_dept_original;
SELECT * FROM trigger_dept_backup;


--예제1] trig_dept_backup
/*
시나리오] 테이블에 새로운 데이터가 입력되면 해당 데이터를 백업테이블에 저장하는
트리거를 작성해보자.
*/
CREATE OR REPLACE TRIGGER trig_dept_backup
    /* 타이밍: AFTER이므로 이벤트 발생 후 */
    AFTER
    /* 이벤트 : 레코드 입력 후 발생 됨 */
    INSERT
    /* Trigger를 적용할 테이블명 */
    ON  trigger_dept_original
    /*
    행 단위 트리거를 정의한다. 즉 하나의 행이 변화할 때마다 트리거가 수행된다.
    만약 문장(테이블)단위 트리거로 정의하려면 해당 문장을 제거한다.
    이 경우 쿼리를 실행하면 트리거도 딱 한 번만 실행된다.
    */
    FOR EACH ROW
BEGIN
    /* INSERT 이벤트가 발생되면 TRUE를 반환하여 IF문이 실행된다. */
    IF Inserting THEN
        dbms_output.put_line('insert 트리거 발생');
        /*
        새로운 레코드가 입력되었으므로 임시 테이블 ':NEW'에 저장되고
        해당 레코드를 통해 backup 테이블에 입력할 수 있다.
        이와 같이 임시테이블은 행 단위 트리거에서만 사용할 수 있다.
        */
        INSERT INTO trigger_dept_backup
        VALUES (
            :NEW.department_id,
            :NEW.department_name,
            :NEW.manager_id,
            :NEW.location_id
        );
    END IF;
END;
/
-- 실행확인
-- original 테이블에 레코드 삽입
INSERT INTO trigger_dept_original values (101, '개발팀', 10, 100);
INSERT INTO trigger_dept_original values (102, 'CS팀', 10, 100);
INSERT INTO trigger_dept_original values (103, '영업팀', 10, 100);
-- 삽입된 레코드 확인
SELECT * FROM trigger_dept_original;
-- 자동으로 백업된 레코드 확인
SELECT * FROM trigger_dept_backup;


--예제2] trig_dept_delete
/*
시나리오] 원본테이블에서 레코드가 삭제되면 백업테이블의 레코드도 같이
삭제되는 트리거를 작성해보자.
*/
CREATE OR REPLACE TRIGGER trig_dept_delete
    -- original 테이블에서 레코드를 삭제한 후 행 단위로 트리거를 실행
    AFTER
    DELETE
    ON trigger_dept_original
    FOR EACH ROW
BEGIN
    dbms_output.put_line('delete 트리거 발생됨');
    /*
    레코드가 삭제된 이후 이벤트가 발생되어 트리거가 호출되므로
    :OLD 임시테이블을 사용한다.
    */
    IF deleting THEN
        DELETE FROM trigger_dept_backup
            WHERE department_id = :OLD.department_id;
    END IF;
END;
/
-- 레코드를 삭제하면 트리거가 자동 호출됨
delete from trigger_dept_original where department_id=101;
-- 레코드 확인
SELECT * FROM trigger_dept_original;
SELECT * FROM trigger_dept_backup;

/*
FOR EACH ROW 옵션에 따른 트리거 실행횟수 테스트
생성1 : 오리지널 테이블에 업데이트 이후 행단위로 발생되는 트리거 생성
*/
--예제3] trigger_update_test
CREATE OR REPLACE TRIGGER trigger_update_test
    AFTER UPDATE
    ON trigger_dept_original
    FOR EACH ROW
BEGIN
    IF updating THEN
        dbms_output.put_line('update 트리거 발생됨')
        /* 업데이트 이벤트가 감지되면 backup 테이블에 레코드를 입력한다. */
        INSERT INTO trigger_dept_backup
        VALUES(
            :OLD.department_id,
            :OLD.department_name,
            :OLD.manager_id,
            :OLD.location_id
        );
    END IF;
END;
/

-- 5개의 레코드가 인출됨
SELECT * FROM trigger_dept_original WHERE
    department_id >= 10 AND department_id <= 50;
-- 위 조건을 그대로 사용하여 레코드 업데이트
UPDATE trigger_dept_original SET department_name = '5개 업데이트'
WHERE department_id >= 10 AND department_id <= 50;
--업데이트 된 레코드 확인
SELECT * FROM trigger_dept_original;
/* 원본테이블에서 한번의 쿼리로 5개의 레코드가 수정되었으므로,
백업테이블에도 5개의 레코드가 입력된다. */
SELECT * FROM trigger_dept_backup;
/*
    즉 행단위 트리거는 적용된 행의 개수만큼 반복 실행된다.
*/

/*
생성2 : 오리지널 테이블에 업데이트 이후 테이블(문장) 단위로 발생되는
    트리거 생성
*/
CREATE OR REPLACE TRIGGER trigger_update_test
    AFTER UPDATE
    ON trigger_dept_original
    /* FOR EACH ROW */
BEGIN
    IF updating THEN
        /* 업데이트 이벤트가 감지되면 backup 테이블에 레코드를 입력한다. */
        INSERT INTO trigger_dept_backup
        VALUES(
            /*
            테이블 단위 트리거에서는 임시 테이블(:NEW, :OLD)을
            사용할 수 없어 생성 시도시 에러가 발생한다.
            따라서 임의의 값을 사용해야 한다.
            :OLD.department_id,
            :OLD.department_name,
            :OLD.manager_id,
            :OLD.location_id
            */
            999, to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss'), 99, 9
        );
    END IF;
END;
/
-- 업데이트 실행(2번째 실행이며, 5개의 레코드가 업데이트됨)
UPDATE trigger_dept_original SET department_name = '5개업뎃2nd'
WHERE department_id >= 10 AND department_id <= 50;
--업데이트 된 레코드 확인
SELECT * FROM trigger_dept_original;
/* 오리지널 테이블에서 5개의 레코드가 수정되었으므로, 테이블 단위 트리거이므로
백업테이블에서는 1개의 레코드만 삽입된다. */
SELECT * FROM trigger_dept_backup;

