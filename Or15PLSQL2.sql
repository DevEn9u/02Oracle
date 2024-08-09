-----------------------------------
--제어문(조건문) : IF문, CASE문과 같은 조건문을 학습한다.

--예제7] IF문 기본
--시나리오] 변수에 저장된 숫자가 홀수 or 짝수인지 판단하는 PL/SQL을 작성하시오.
-- IF문 : 홀수와 짝수를 판단하는 IF문 작성
DECLARE
    -- 선언부에서 숫자타입의 변수를 선언
    NUM NUMBER;
BEGIN
    -- 초기값으로 10을 할당
    NUM := 10;
    -- 2로 나눈 나머지가 0인지 판단하여 홀짝 구분
    IF MOD(NUM, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE(NUM || '은/는 짝수');
    ELSE
        DBMS_OUTPUT.PUT_LINE(NUM || '은/는 홀수');
    END IF;
END;
/

--예제8] 제어문(조건문 : if-elsif)
/*
시나리오] 사원번호를 사용자로부터 입력받은 후 해당 사원이 어떤부서에서
근무하는지를 출력하는 PL/SQL문을 작성하시오. 단, if~elsif문을 사용하여
구현하시오.
*/
DECLARE
    --치환연산자를 통해 변수 초기화
    emp_id employees.employee_id%type := &emp_id;
    emp_name VARCHAR2(50); -- 일반변수
    emp_dept employees.department_id%type; --참조변수
    -- 필요하다면 선언부에서 변수를 초기화할 수 있음
    dept_name VARCHAR2(30) := '부서정보없음';
BEGIN
    -- 변수를 INTO절과 WHERE절에서 사용
    SELECT employee_id, last_name, department_id
        INTO emp_id, emp_name, emp_dept
    FROM employees
    WHERE employee_id = emp_id;
    
    /* 여러개의 조건을 사용할 경우 Java와 같이 else if를 사용하지 않고
    ELSIF로 기술해야 한다. 또한 중괄호 대신 THEN과 END IF를 사용한다. */
    IF emp_dept = 50 THEN
        dept_name := 'Shipping';
    ELSIF emp_dept = 60 THEN
        dept_name := 'IT';
    ELSIF emp_dept = 70 THEN
        dept_name := 'Publich Relations';
    ELSIF emp_dept = 80 THEN
        dept_name := 'Sales';
    ELSIF emp_dept = 90 THEN
        dept_name := 'Executive';
    ELSIF emp_dept = 100 THEN
        dept_name := 'Finance';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사원번호' || emp_id || '의 정보');
    DBMS_OUTPUT.PUT_LINE('이름: ' || emp_name
            ||', 부서번호: ' || emp_dept
            ||', 부서명: '|| dept_name);
END;
/

/*
CASE문
: Java의 switch문과 비슷한 조건문
형식]
    CASE 변수
        WHEN 값1 THEN '할당값1'
        WHEN 값2 THEN '할당값2'
        ... 값N
    END;
*/
-- 예제9] 제어문(조건문 : case~when)
-- 시나리오] 앞에서 if~elsif로 작성한 PL/SQL문을 case~when문으로 변경하시오.
DECLARE
    emp_id employees.employee_id%type := &emp_id;
    emp_name VARCHAR2(50);
    emp_dept employees.department_id%type;
    dept_name VARCHAR2(30) := '부서정보없음';
BEGIN
    SELECT employee_id, last_name, department_id
    INTO emp_id, emp_name, emp_dept
    FROM employees
    WHERE employee_id = emp_id;
    
    /* CASE~WHEN문이 IF문과 다른 점
     - 할당할 변수를 먼저 선언한 후 문장 내에서 조건을 판단하여
       하나의 값을 할당하는 방식
       따라서 변수를 중복으로 기술하지 않아도 된다.
    */
    dept_name :=
        CASE emp_dept
            WHEN 50 THEN 'Shipping'
            WHEN 60 THEN 'IT'
            WHEN 70 THEN 'Public Relations'
            WHEN 80 THEN 'Sales'
            WHEN 90 THEN 'Executive'
            WHEN 100 THEN 'Finance'
        END;
    DBMS_OUTPUT.PUT_LINE('사원번호' || emp_id || '의 정보');
    DBMS_OUTPUT.PUT_LINE('이름: ' || emp_name
            ||', 부서번호: ' || emp_dept
            ||', 부서명: '|| dept_name);
END;
/

-------------------------------------------------
--제어문(반복문)
/*
반복문1 : Basic Loop문
    Java의 do~while문과 같이 조건 체크 없이 일단 LOOP로 진입한 후
    탈출 조건이 될 때까지 반복한다. 탈출시에는 EXIT를 사용한다.
*/
--예제10] 제어문(반복문 : basic loop)
DECLARE
    -- 변수를 NUMBER 타입으로 선언 후 0으로 초기화
    num NUMBER := 0;
BEGIN
    -- 조건 체크 없이 LOOP로 진입
    LOOP
        DBMS_OUTPUT.PUT_LINE(num);
        /* 증가연산자나 복합대입연산자가 없으므로 일반적인 방식으로
        변수를 증가시켜야 한다. */
        num := num + 1;
        /* num이 10을 초과하면 loop문을 탈출한다. exit는 Java의 break와
        동일하게 반복문을 탈출한다. */
        EXIT WHEN (num > 10);
    END LOOP;
END;
/

--예제11] 제어문(반복문 : basic loop)
--시나리오] Basic loop문으로 1부터 10까지의 정수의 합을 구하는 프로그램을 작성하시오.
DECLARE
    i NUMBER := 1;
    /* 누적합을 저장하기 위한 변수로, Java에서는 보통 sum이라는 변수명을 사용하지만,
    Oracle에서는 그룹함수 sum()이 있으므로(예약어) 사용에 주의해야 한다. */
    sumNum NUMBER := 0;
BEGIN
    LOOP
        -- 증가하는 변수 i를 누적해서 더해준다.
        sumNum := sumNum + i;
        i := i + 1;
        EXIT WHEN (i > 10);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1~10까지의 합 : ' || sumNum);
END;
/

/*
반복문2 : WHILE문
    Basic Loop와 다르게 조건을 먼저 확인한 후 실행한다.
    즉, 조건에 맞지 않는다면 한번도 실행되지 않을 수 있다.
    반복의 조건이 있으므로 특별한 경우가 아니라면 EXIT를 
    사용하지 않아도 된다.
*/
--예제12] 제어문(반복문 : while)
DECLARE
    num1 NUMBER := 0;
BEGIN
    --WHILE문 집입 전 조건을 먼저 확인한다.
    WHILE num1 < 11 LOOP
        -- 0~10까지 출력
        DBMS_OUTPUT.PUT_LINE('이번숫자는 : ' || num1);
        num1 := num1 + 1;
    END LOOP;
END;
/
--예제13] 제어문(반복문 : while)
/*
시나리오] while loop문으로 다음과 같은 결과를 출력하시오.
*
**
***
****
*****
*/
DECLARE
    --*를 누적해서 연결할 VARCHAR2 변수 선언
    starStr VARCHAR2(100);
    --반복을 위한 변수
    i NUMBER := 1;
BEGIN
    WHILE i <= 5 LOOP
        --반복문 내에서 *를 문자열에 연결
        starStr := starStr || '*';
        DBMS_OUTPUT.PUT_LINE(starStr);
        --i값 증가
        i := i + 1;
    END LOOP;
END;
/

--예제14] 제어문(반복문 : while) 
--시나리오] while loop문으로 1부터 10까지의 정수의 합을 구하는 프로그램을 작성하시오.
DECLARE
    i NUMBER := 1;
    sumNum NUMBER := 0;
BEGIN
    WHILE i <= 10 LOOP
        sumNum := sumNum + i;
        i := i + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('1~10까지 수의 합은 : ' || sumNum);
END;
/
/*
반복문3 : FOR문
    반복의 횟수를 지정하여 사용할 수 있는 반복문으로 반복을 위한 변수를
    별도로 선언하지 않아도 된다. 그러므로 특별한 이유가 없다면 선언부를
    기술하지 않아도 된다.
*/
--예제15] 제어문(반복문 : for)
DECLARE
    -- 선언부에 선언한 변수가 없다.
BEGIN
    -- 반복을 위한 변수는 별도의 선언 없이 FOR문에서 사용할 수 있다.
    FOR num2 IN 0 .. 10 LOOP
        DBMS_OUTPUT.PUT_LINE('FOR문 짱인듯 : ' || num2);
    END LOOP;
END;
/

-- 변수 선언이 필요 없다면 DECLARE는 생략 가능하다.
BEGIN
    FOR num3 IN REVERSE 0 .. 10 LOOP
        DBMS_OUTPUT.PUT_LINE('거꾸로 FOR문 짱인듯 : ' || num3);
    END LOOP;
END;
/

--예제16] 제어문(반복문 : for) 
--연습문제] for loop문으로 구구단을 출력하는 프로그램을 작성하시오. 
BEGIN
    FOR dan IN 2..9 LOOP
        DBMS_OUTPUT.PUT_LINE(dan || '단');
        FOR su IN 1..9 LOOP
            DBMS_OUTPUT.PUT_LINE(dan|| ' x ' || su || '=' || dan * su);
        END LOOP;
    END LOOP;
END;
/

DECLARE
    newStr VARCHAR2(1000);
BEGIN
    FOR dan IN 2..9 LOOP
        FOR su IN 1..9 LOOP
            newStr := newStr || dan || ' x ' || su || '=' || dan * su || ' ';
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(dan || '단: ' || newStr);
        newStr := '';
    END LOOP;
END;
/
/*
커서(Cursor)
    :SELECT 쿼리에 의해 여러 행이 반환되는 경우 각 행에 접근하기 위한 개체
    선언 방법]
        CURSOR 커서명 IS
            SELECT 쿼리문. 단 INTO절이 없는 형태로 기술한다.
            
        OPEN CURSOR
            : 쿼리를 실행하라는 의미. 즉 OPEN할때 CURSOR 선언시 SELECT문이
              실행되어 결과셋을 얻게 된다. CURSOR는 그 결과셋의 첫번째 행에
              위치하게 된다.
        FETCH~INTO~
            : 결과셋에서 하나의 행을 읽어들이는 작업으로 결과셋의 인출(FETCH)
              후에 CURSOR는 다음 행으로 이동한다.
        CLOSE CURSOR
            : 커서 닫기로 결과셋의 자원을 반납한다. SELECT 문장이 모두 처리된 후
              CURSOR를 닫아준다.
              
        CURSOR의 속성
            %Found : 가장 최근에 인출(FETCH)이 행을 return 하면 True, 아니면
                False를 반환한다.
            %NotFound : %Found의 반대 값을 반환.
            %RowCount : 지금까지 return된 행의 개수 반환.
*/
--예제17] Cursor
--시나리오] 부서테이블의 레코드를 Cursor를 통해 출력하는 PL/SQL문을 작성하시오.
DECLARE
    -- 부서테이블의 전체컬럼을 참조하는 참조변수로 선언
    v_dept departments%rowtype;
    /* 커서 선언 : 부서테이블의 모든 레코드를 조회하는 SELECT문으로
        INTO절이 없는 형태로 쿼리문을 작성한다. 쿼리의 실행결과가
        cur1에 저장된다.*/
    CURSOR cur1 IS
        SELECT
            department_id, department_name, location_id
        FROM departments;
BEGIN
    /* 해당 쿼리문을 수행해서 결과셋(ResultSet)을 얻어온다. 결과셋이란
    쿼리문을 수행한 후 반환되는 레코드의 결과를 말한다. */
    OPEN cur1;
    
    -- basic 루프문으로 얻어온 결과셋의 개수만큼 반복하여 인출한다.
    LOOP
        FETCH cur1 INTO
            -- FETCH(인출)한 결과는 참조변수에 각각 INTO(저장)한다.
            v_dept.department_id,
            v_dept.department_name,
            v_dept.location_id;
        
        -- 탈출 조건으로 더 이상 인출할 행이 없으면 EXIT가 실행된다.
        EXIT WHEN cur1%notfound;
        
        DBMS_OUTPUT.PUT_LINE(v_dept.department_id || ' ' ||
                        v_dept.department_name || ' ' ||
                        v_dept.location_id);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('인출된 행의 개수: ' || cur1%rowcount);
        -- 커서의 자원 반납
        CLOSE cur1;
END;
/
    


--예제18] Cursor
/*
시나리오] Cursor를 사용하여 사원테이블에서 커미션이 null이 아닌 사원의
사원번호, 이름, 급여를 출력하시오. 출력시에는 이름의 오름차순으로 정렬하시오.
*/
--조검ㄴ에 맞는 쿼리문을 생성. 35개 행이 인출됨.
SELECT * FROM employees WHERE commission_pct IS NOT NULL
ORDER BY last_name ASC;

--PL/SQL문 작성
DECLARE
    -- 작성한 쿼리문을 통해 커서 생성
    CURSOR curEmp IS
        SELECT employee_id, last_name, salary
        FROM employees
        WHERE commission_pct IS NOT NULL
        ORDER BY last_name ASC;
    -- 사원 테이블의 전체 컬럼을 참조하는 참조변수 선언
    varEmp employees%rowType;
BEGIN
    -- 커서를 OPEN해서 쿼리 실행
    OPEN curEmp;
    --BASIC LOOP를 통해 커서에 저장된 결과셋 인출
    LOOP
        -- 인출한 정보는 참조변수에 저장
        FETCH curEmp
            INTO varEmp.employee_id, varEmp.last_name, varEmp.salary;
        -- 인출할 정보가 없다면 LOOP문 탈출
        EXIT WHEN curEmp%notFound;
        DBMS_OUTPUT.PUT_LINE(varEmp.employee_id || ' ' ||
                            varEmp.last_name || ' ' ||
                            varEmp.salary);
        END LOOP;
        --커서를 닫아서 자원해제
        CLOSE curEmp;
END;
/
--예제19] 연관배열(Associative Array)
/*
시나리오] 다음의 조건에 맞는 연관배열을 생성한 후 값을 할당하시오.
    연관배열 자료형 명 : avType, 값의자료형:문자형, 키의자료형:문자형
    key : girl, boy
    value : 트와이스, 방탄소년단
    변수명 : var_array
*/
/*
컬렉션(배열)
    : 일반 프로그래밍 언어에서 사용하는 배열타입을 PL/SQL문에서는
    테이블타입이라고 한다. 1,2 차원 배열을 생각해보면 테이블(표)와 같은 형태이기 때문이다.
1. 연관배열(Associative Array)
    : Key와 Value의 쌍으로 구성된 collection으로 Java의 Map과 유사하다.
    형식]
        Type 연과배열자료형 IS
            TABLE OF Value의 타입
            INDEX OF Key의 타입;
*/
DECLARE
    --연관배열 자료형 생성
    TYPE avType IS
        TABLE OF VARCHAR2(30) /* Value의 자료형 선언 */
        INDEX BY VARCHAR2(10); /* Key의 자료형 선언 */
    --생성한 자료형을 통해 연관배열 변수 생성
    var_array avType;
BEGIN
    --연관배열에 값 할당
    var_array('girl') := '트와이스';
    var_array('boy') := '방탄소년단';
    
    DBMS_OUTPUT.PUT_LINE(var_array('girl'));
    DBMS_OUTPUT.PUT_LINE(var_array('boy'));
END;
/

--예제20] 연관배열(Associative Array)
/*
시나리오] 100번 부서에 근무하는 사원의 이름을 저장하는 연관배열을 생성하시오.
key는 숫자, value는 full_name 으로 지정하시오.
*/
-- 100번 부서에 근무하는 사원 출력: 6명
SELECT * FROM employees WHERE department_id = 100;
-- Fullname을 출력하기 위한 쿼리문 작성
SELECT first_name || ' ' || last_name
    FROM employees WHERE department_id = 100;

--문제의 조건을 통한 쿼리의 결과에서 다수행이 인출되므로 CURSOR를 사용해야 한다.
DECLARE
    --쿼리문을 통해 커서를 생성
    CURSOR emp_cur IS
        SELECT first_name || ' ' || last_name FROM employees
        WHERE department_id = 100;
    --연관배열 자료형 생성(Key: 숫자형-BINARY_INTEGER, Value: 문자형-VARCHAR2(30))
    TYPE nameAvType IS
        TABLE OF VARCHAR2(30)
        INDEX BY BINARY_INTEGER;
    --연관배열 변수 생성
    names_arr nameAvType;
    --사원의 이름과 인덱스로 사용할 변수 생성
    fname VARCHAR2(50);
    idx NUMBER := 1;
BEGIN
    /* 커서를 OPEN하여 쿼리문을 실행한 후 얻어온 결과셋의 개수만큼
    반복하여 사원명을 인출한다. */
    OPEN emp_cur;
    LOOP
        --이름을 변수에 입력
        FETCH emp_cur INTO fname;
        --연관배열 변수에 사원이름을 입력
        EXIT WHEN emp_cur%NotFound;
        names_arr(idx) := fname;
        idx := idx + 1;
    END LOOP;
    --모든 인출이 완료되면 커서를 닫는다.
    CLOSE emp_cur;
    
    --연관배열변수.COUNT: 연관배열에 저장된 요소의 개수를 반환
    FOR i IN 1 .. names_arr.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(names_arr(i));
    END LOOP;
END;
/

/*
2. VArray(Variable Array)
    : 고정길이를 가진 배열로, 일반 프로그래밍 언어에서 사용하는 배열과
    동이하다. 크기에 제한이 있어서 선언시 크기(원소의 개수)를 지정하면
    이보다 큰 배열로 만들 수 없다.
    형식] TYPE 배열타입명 IS
            ARRAY(배열크기) OF 값의 타입;
*/
--예제21] VArray(Variable Array)
DECLARE
    --VArray 타입 선언. 크기는 5, 저장할 데이터의 타입은 VARCHAR2 타입으로 지정.
    TYPE vaType IS
        ARRAY(5) OF VARCHAR2(20);
    -- VArray 타입의 배열변수 선언
    v_arr vaType;
    -- 인덱스로 사용할 변수 선언
    cnt NUMBER := 0;
BEGIN
    --생성자를 통한 값의 초기화. 총 5개중 3개만 할당.
    v_arr := vaType('First', 'Second', 'Third', '', '');
    
    --Basic 루프문으로 배열의 원소를 출력한다.(※인덱스는 1부터 시작)
    loop
        cnt := cnt + 1;
        --탈출 조건은 WHEN 대신 IF를 사용할 수도 있다.
        IF cnt > 5 THEN
            EXIT;
        END IF;
        --배열처럼 인덱스를 통해 출력한다.
        DBMS_OUTPUT.PUT_LINE(v_arr(cnt));
    END LOOP;
    
    --배열에 원소 재할당
    v_arr(3) := '우리는';
    v_arr(4) := 'JAVA';
    v_arr(5) := '개발자다';
    
    --FOR 루프문으로 출력
    FOR i IN 1 .. 5 LOOP
        DBMS_OUTPUT.PUT_LINE(v_arr(i));
    END LOOP;
END;
/

--예제22] VArray(Variable Array)
/*
시나리오] 100번 부서에 근무하는 사원의 사원번호를 인출하여 VArray에 저장한 후
출력하는 PL/SQL을 작성하시오.
*/
--6개의 레코드가 인출됨
SELECT * FROM employees WHERE department_id = 100;

DECLARE
    /* VArray 자료형 선언 : 배열에 저장될 값은 사원아이디 컬럼을 참조하여
        생성한다.*/
    TYPE vaType1 IS
        ARRAY(6) OF employees.employee_id%Type;
    --배열변수 선언 및 생성자를 통해 초기화를 진행한다.
    va_one vaType1 := vaType1('', '', '', '', '', '');
    cnt NUMBER := 1;
BEGIN
    /*
    Java의 확장 for문과 비슷하게 쿼리의 결과셋의 개수만큼 자동으로
    반복하는 형태로 사용한다. SELECT절의 employee_id가 변수 i에
    할당되고 이를 통해 인출할 수 있다.
    */
    FOR i IN (SELECT employee_id FROM employees
                    WHERE department_id = 100) LOOP
        --인출한 데이터를 배열에 순서대로 저장한다.
        va_one(cnt) := i.employee_id;
        cnt := cnt + 1;
    END LOOP;
    
    --배열의 크기만큼 반복하여 각 요소를 출력
    FOR j IN 1 .. va_one.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(va_one(j));
    END LOOP;
END;
/

/*
3. 중첩테이블(Nested Table)
    : VArray와 비슷한 구조의 배열로, 배열의 크기를 명시하지 않으므로
        동적으로 배열의 크기가 설정된다.
    형식] TYPE 중첩테이블명 IS
            TABLE OF 값의 타입;
*/
--예제23] 중첩테이블(Nested Table)
DECLARE
    --중첩테이블의 자료형을 생성한 후 변수 선언
    TYPE ntType IS
        TABLE OF VARCHAR2(30);
    nt_array ntType;
BEGIN
    --생성자를 통해 값을 할당. 이때 크기가 4인 중첩테이블이 생성됨.
    nt_array := ntType('첫번째', '두번째', '세번째', '');
    
    --4번째 값까지는 정상적으로 할당 및 출력된다.
    
    DBMS_OUTPUT.PUT_LINE(nt_array(1));
    DBMS_OUTPUT.PUT_LINE(nt_array(2));
    DBMS_OUTPUT.PUT_LINE(nt_array(3));
    nt_array(4) := '네번째값 할당';
    
    DBMS_OUTPUT.PUT_LINE(nt_array(4));
    /*
    에러발생
    ORA-06533: 첨자가 개수를 넘었습니다 
    - 즉 자동으로 배열이 확장되지는 않는다.
    */
    --nt_array(5) := '다섯번째값 할당 되냐???';
    
    /*
    크기를 확장할 때는 생성자를 통해 배열의 크기를 동적으로 확장한다.
    */
    nt_array := ntType('1a', '2b', '3c', '4d', '5e', '6f', '7g');
    
    FOR i IN 1 .. 7 LOOP
        DBMS_OUTPUT.PUT_LINE(nt_array(i));
    END LOOP;
END;
/

--예제24] 중첩테이블(Nested Table) 
--시나리오] 중첩테이블과 for문을 통해 사원테이블의 전체 레코드의 사원번호와 이름을 출력하시오.
DECLARE
    /* 중첩테이블 자료형 선언 및 변수 선언 : 사원테이블의 전체컬럼을 참조하는
        참조변수로 선언했으므로 하나의 레코드(Row)를 저장할 수 있는
        타입이 된다. */
    TYPE ntType IS
        TABLE OF employees%rowtype;
    nt_array ntType;
BEGIN
    --크기를 지정하지 않은 상태로 생성자를 통해 중첩 테이블을 초기화
    nt_array := ntType();
    /* 사원테이블의 레코드 수 만큼 반복하면서 레코드를 하나씩 인출해준다. */
    FOR rec IN (SELECT * FROM employees) LOOP
        --중첩테이블의 마지막 부분을 확장하면서 null을 삽입(EXTEND 메서드)
        nt_array.EXTEND;
        --마지막 인덱스 값을 얻어온 후 사원정보를 출력(LAST 메서드)
        nt_array(nt_array.LAST) := rec;
    END LOOP;
    
    --중첩테이블의 첫번째 인덱스(FIRST 메서드)부터 마지막 인덱스(LAST 메서드)까지 출력
    FOR i IN nt_array.FIRST .. nt_array.LAST LOOP
    DBMS_OUTPUT.PUT_LINE(nt_array(i).employee_id ||
            '>' || nt_array(i).first_name);
    END LOOP;
END;
/
