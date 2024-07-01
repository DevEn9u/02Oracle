/**************
파일명 : Or14View.sql
View(뷰)
설명 : View는 테이블로부터 생성된 가상의 테이블로 물리적으로는 존재하지
    않고 논리적으로 존재하는 테이블이다.
**************/

-- HR 계정에서 실습합니다.

/*
SELECT 쿼리문 실행히 해당 테이블이 없다면
"테이블 또는 뷰가 존재하지 않습니다" 라는 오류메세지가 나온다.
*/
SELECT * FROM member;

/*
뷰의 생성
형식] CREATE [OR REPLACE] VIEW 뷰의이름 [(컬럼1, 컬럼2, ...)]
    AS
    SELECT * FROM 테이블명 WHERE 조건
    혹은 JOIN이 있는 SELECT문
    GROUP BY가 추가된 SELECT문 등..
*/

/*
시나리오] HR계정의 사원테이블에서 담당업무가 ST_CLERK인 사원의 정보를
    조회할 수 있는 VIEW를 생성하시오.
    출력항목: employee_id, first_name, job_id, hire_date, department_id
*/
--1. 시나리오의 조건대로 SELECT문을 생성한다.
SELECT
    employee_id, first_name, last_name, job_id, hire_date, department_id
FROM employees WHERE job_id = 'ST_CLERK';
--2. 뷰 생성하기
CREATE VIEW view_employees
AS
    SELECT
        employee_id, first_name, last_name, job_id, hire_date, department_id
    FROM employees WHERE job_id = 'ST_CLERK';
--3. 데이터사전에서 확인하기
SELECT * FROM user_views;
--4. 뷰 실행하기
SELECT * FROM view_employees;

/*
뷰 수정하기
    : 뷰 생성 문장에 OR REPLACE만 추가하면 된다.
    해당 뷰가 존재하면 수정되고, 존재하지 않으면 새롭게 생성한다.
    따라서 최초로 뷰를 생성할 때부터 사용해도 무방하다.
*/

/*
시나리오] 앞에서 생성한 뷰를 다음과 같이 수정하시오.
    기존 컬럼인 employee_id, first_name, last_name, job_id,
    hird_date, department_id를 
    id, fname, jobid, hdate, deptid로 수정하여 뷰를 수정하시오.
*/
CREATE OR REPLACE VIEW view_employees (id, fname, jobid, hdate, deptid)
AS
    SELECT 
        employee_id, first_name, job_id, hire_date, department_id
    FROM employees WHERE job_id = 'ST_CLERK';
/*
    뷰 생성시 기존 테이블의 컬럼명을 변경해서 출력하고 싶다면 위와 같이
    변경할 컬럼명을 뷰 이름 뒤에 소괄호로 명시해주면 된다.
*/
SELECT * FROM view_employees;

/*
퀴즈] 담당업무 아이디가 ST_MAN인 사원의 사원번호, 이름, 이메일, 매니져아이디를
    조회할 수 있도록 작성하시오.
    뷰의 컬럼명은 e_id, name, email, m_id로 지정한다. 단, 이름은 
    first_name과 last_name이 연결된 형태로 출력하시오.
	뷰명 : emp_st_man_view
*/
CREATE OR REPLACE VIEW emp_st_man_view (e_id, name, email, m_id)
AS
    SELECT
        employee_id, first_name || ' ' || last_name, email, manager_id
    FROM employees WHERE job_id = 'ST_MAN';
SELECT * FROM emp_st_man_view;

--(강사님버젼) 문제의 조건대로 SELECT문 작성
SELECT employee_id, first_name || ' ' || last_name, email, manager_id
FROM employees WHERE job_id = 'ST_MAN';
--뷰 생성
CREATE OR REPLACE VIEW emp_st_man_view (e_id, name, email, m_id)
AS
    SELECT
        employee_id, first_name || ' ' || last_name, email, manager_id
    FROM employees WHERE job_id = 'ST_MAN';
SELECT * FROM emp_st_man_view;
--뷰를 통해 결과 확인
SELECT * FROM emp_st_man_view;

 /*
퀴즈] 사원번호, 이름, 연봉을 계산하여 출력하는 뷰를 생성하시오.
컬럼의 이름은 emp_id, l_name, annual_sal로 지정하시오.
연봉계산식 -> (급여+(급여*보너스율))*12
뷰이름 : v_emp_salary
단, 연봉은 세자리마다 컴마가 삽입되어야 한다. 
*/
CREATE OR REPLACE VIEW v_emp_salary (emp_id, l_name, annual_sal)
AS
    SELECT employee_id, last_name,                  
        TO_CHAR(((salary + salary * NVL(commission_pct, 0)) * 12), '999,000')
    FROM employees;
SELECT * FROM v_emp_salary;

/* (강사님 버젼) SELECT문 작성(NULL값이 있는 경우 사칙연산이 되지 않으므로 NVL()함수를 통해
0으로 변경해줘야 한다. */
SELECT
    employee_id, last_name, (salary + nvl((salary * commission_pct), 0)) * 12
FROM employees;
-- 뷰 생성
CREATE OR REPLACE VIEW v_emp_salary (emp_id, l_name, annual_sal)
AS
    SELECT
        employee_id, last_name, 
        ltrim(to_char((salary + (salary * nvl(commission_pct, 0))) * 12, '999,000'))
FROM employees;
--뷰 확인
SELECT * FROM v_emp_salary;

/*
뷰 생성시 연산식이 추가되어 논리적인 컬럼이 생성되는 경우에는 반드시
별칭으로 컬럼명을 명시해야 한다. 그렇지 않으면 뷰 생성시 에러가 발생한다.
*/
CREATE OR REPLACE VIEW v_emp_salary
AS
    SELECT
        employee_id, last_name, 
        (salary + nvl((salary * commission_pct), 0)) * 12
FROM employees;

 /*
-조인을 통한 View 생성
시나리오] 사원테이블과 부서테이블, 지역테이블을 조인하여 다음 조건에 맞는 
뷰를 생성하시오.
출력항목 : 사원번호, 전체이름, 부서번호, 부서명, 입사일자, 지역명
뷰의명칭 : v_emp_join
뷰의컬럼 : empid, fullname, deptid, deptname, hdate, locname
컬럼의 출력형태 : 
	fullname => first_name+last_name 
	hdate => 0000년00월00일
    locname => XXX주의 YYY (ex : Texas주의 Southlake)	
*/
--1. SELECT문 작성
SELECT
    employee_id, first_name || ' ' || last_name, department_id,
    department_name, TO_CHAR(hire_date, 'YYYY"년" MM"월" DD"일"'), 
    city || ', ' || state_province
FROM employees
    INNER JOIN departments USING(department_id)
    INNER JOIN locations USING(location_id);
--2. VIEW 생성
CREATE OR REPLACE VIEW v_emp_join (empid, fullname, deptid, deptname, 
    hdate, locname)
AS
    SELECT
        employee_id, first_name || ' ' || last_name, department_id,
        department_name, TO_CHAR(hire_date, 'YYYY"년" MM"월" DD"일"'), 
        city || ', ' || state_province
    FROM employees
        INNER JOIN departments USING(department_id)
        INNER JOIN locations USING(location_id);
--3. 복잡한 쿼리문을 view를 통해 간단히 조회할 수 있다.
SELECT * FROM v_emp_join;