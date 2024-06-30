/**********
파일명 : Or10SubQuery.sql
서브쿼리
설명 : 쿼리문 안에 또 다른 쿼리문이 들어가는 형태로 select문
**********/

/*
단일행 서브쿼리
형식] SELECT * from 테이블명 where 컬럼 = (
            SELECT 컬럼 from 테이블명 where 조건
        );
    ※ 괄호 안의 서브쿼리는 반드시 하나의 결과를 인출해야 한다.
*/
/*
시나리오] 사원테이블에서 전체사원의 평균급여보다 낮은 급여를 받는 사원들을
        추출하여 출력하시오.
    출력항목 : 사원번호, 이름, 이메일, 연락처, 급여
*/
--1. 평균 급여 구하기 (결과 : 6462)
SELECT round(avg(salary)) from employees;
--2. 앞에서 구한 평균급여를 통해 평균급여보다 덜 받는 사원 인출 (결과: 56명)
select * from employees where salary < 6462;
/* 1, 2번을 아래와 같이 쿼리문을 작성하면 에러가 발생한다. 문맥상
맞는 것처럼 보이지만 그룹함수를 단일행에 적용한 잘못된 쿼리문이다. */
select * from employees where salary < round(avg(salary));
--서브쿼리문 작성하기
select * from employees where salary <(
    select round(avg(salary)) from employees
);

/*
시나리오] 전체 사원중 급여가 가장 적은 사원의 이름과 급여를 출력하는
        서브쿼리문을 작성하시오.
    출력항목: 이름, 성, 이메일, 급여
*/
--1. 최소급여를 확인(결과: 2100)
select min(salary) from employees;
--2-1. 그룹함수를 단일행에 사용했으므로 에러발생함
select first_name, last_name, email, salary from employees
    where salary = min(salary);
--2-2. 1에서 확인한 최소급여를 min(salry) 위치에 넣는다.
select first_name, last_name, email, salary from employees
    where salary = 2100;
--4. 2개의 쿼리문을 합쳐서 서브쿼리문 작성
select first_name, last_name, email, salary
    from employees where salary = (
        select min(salary) from employees
    );

/*
시나리오] 평균급여보다 많은 급여를 받는 사원들의 명단을 조회할 수 있는
서브쿼리문을 작성하시오.
출력내용 : 이름, 성, 담당업무명, 급여
※ 담당업무명은 jobs 테이블에 있으므로 join해야 한다.
*/
--평균급여 확인하기
SELECT round(avg(salary)) from employees;
--jobs 테이블을 inner join 하여 job_title도 인출
SELECT 
    first_name, last_name, job_title, salary
FROM employees INNER JOIN jobs using(job_id)
WHERE salary > 6462;
--서브쿼리문 작성
SELECT 
    first_name, last_name, job_title, salary
FROM employees INNER JOIN jobs using(job_id)
WHERE salary > (SELECT round(avg(salary)) from employees);

/*
복수행 서브쿼리
형식] SELECT * from 테이블명 where 컬럼 in (
            SELECT 컬럼 from 테이블명 where 조건
        );
    ※ 괄호 안의 서브쿼리는 2개 이상의 결과를 인출해야 한다.
    ※ 경우에 따라 1개의 결과가 나오더라도 에러가 발생하지는 않는다.
*/

/*
시나리오] 담당업무멸로 가장 높은 급여를 받는 사원의 명단을 조회하시오.
    출력목록: 사원아이디, 이름, 담당업무아이디, 급여
*/
--1. 담당업무멸로 가장 높은 급여를 확인
SELECT
    job_id, MAX(salary)
from employees GROUP BY job_id;
--2. 앞에서 나온 결과를 바탕으로 단순한 or 조건으로 쿼리문 작성
SELECT employee_id, first_name, last_name, job_id, salary
FROM employees WHERE
    (job_id = 'AD_PRES' AND salary = 24000) OR
    (job_id = 'AD_VP' AND salary = 17000) OR
    (job_id = 'IT_PROG' AND salary = 9000) OR
    (job_id = 'FI_MGR' AND salary = 12008);
/* 1번 쿼리에서 19개의 결과가 인출되었지만 쿼리를 직접 기술하는 것은
불편하므로 4개만으로 결과를 확인해보았다. */
--3. 2개의 컬럼을 이용해야 하므로 좌측항과 우측항을 in으로 연결한다.
SELECT employee_id, first_name, last_name, job_id, salary
FROM employees WHERE
    (job_id, salary) IN (
        SELECT
            job_id, MAX(salary)
        from employees GROUP BY job_id
);
    
/*
복수행 연산자: any
    메인쿼리의 비교조건이 서버쿼리의 검색결과와 하나 이상 일치하면
    참이 되는 연산자. 즉 둘중 하나만 만족하면 해당 레코드를 인출한다.
*/
/*
시나리오] 전체 사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를
    받는 직원들을 인출하는 서브쿼리문을 작성하시오. 단 둘 중 하나만
    만족하더라도 인출하시오.
*/
--20번 부서의 급여를 확인(결과: 6000, 13000)
SELECT first_name, salary FROM employees where department_id = 20;
--위 결과를 단순한 or문으로 작성
SELECT first_name, salary FROM employees
where salary > 13000 or salary > 6000;
/* 둘 중 하나만 만족하면 되므로 복수행 연산자 any를 이용해서 서브쿼리를
만들면 된다. 즉 6000 혹은 13000보다 큰 조건으로 쿼리문이 실행된다. */
SELECT first_name, salary FROM employees
where salary > any (
    SELECT salary FROM employees where department_id = 20
    );
--결과적으로 6000보다 크면 조건에 만족한다. (결과: 55명)

/*
복수행 연산자: all
    메인쿼리의 비교조건이 서버쿼리의 검색결과와 모두 일치해야
    레코드를 인출한다.
*/
/*
시나리오] 전체 사원중에서 부서번호가 20인 사원들의 급여보다 높은 급여를
    받는 직원들을 인출하는 서브쿼리문을 작성하시오. 단 두 조건을 모두 만족하는
    레코드만 인출하시오.
*/
SELECT first_name, salary FROM employees
where salary > 13000 or salary > 6000;
/*
    6000 이상이고 동시에 13000 이상이어야 하므로 결과적으로 13000 이상인
    레코드만 인출한다. (결과: 5명)
*/
SELECT first_name, salary FROM employees
where salary > all (
    SELECT salary FROM employees where department_id = 20
    );

/*
rownum : 테이블에서 레코드를 조회한 순서대로 순번이 부여되는 가상의
    컬럼을 말한다. 해당 컬럼은 모든 테이블에 논리적으로 존재한다.
*/
--모든 계정에 논리적으로 존재하는 테이블
select * from dual;
/* 정렬없이 모든 레코드를 가져와서 레코드에 rownum을 부여한다.
이 경우 rownum은 순서대로 출력된다. */
select employee_id, first_name, rownum from employees;
/* 이름이나 사원번호를 통해 정렬하면 rownum이 
섞여 나오기도 하고 순서대로 나오기도 한다. */
select employee_id, first_name, rownum from employees order by first_name;
select employee_id, first_name, rownum from employees order by employee_id;
/*
rownum을 우리가 정렬한 순서대로 재부여하기 위해 서브쿼리를 사용한다.
from절 뒤에는 원래 테이블이 들어오는데, 아래의 서브쿼리에서는 employees 테이블의
전체 레코드를 대상으로 하되 이름을 정렬한 상태로 레코드를 가져오게 되므로
테이블을 대체할 수 있게 된다.
또한 정렬된 상태에서 rownum을 통해 순차적인 순번이 부여된다.
*/
SELECT first_name, ROWNUM FROM
    (SELECT * FROM employees ORDER BY first_name ASC);

/*
이름을 기준으로 정렬된 레코드에 rownum을 부여하였으므로 where절에
아래와 같은 조건을 통해 구간을 정해 select할 수 있다.
*/
SELECT * FROM
    (SELECT tb.*, ROWNUM rNum FROM
       (SELECT * FROM employees ORDER BY first_name ASC) tb
    )
--where rNum >= 1 and rNum <= 10;
--where rNum >= 11 and rNum <= 20;
where rNum between 21 and 30;

-----------------------------------------------------
/*
1.사원번호가 7782인 사원과 담당 업무가 같은 사원을 표시(사원이름과 담당 업무)하시오.
*/
SELECT * FROM emp where empno = 7782;
SELECT * FROM emp where job = 'MANAGER';
-- 서브쿼리문 적용
SELECT * FROM emp WHERE job = (
    SELECT job FROM emp WHERE empno = 7782
);

--02.사원번호가 7499인 사원보다 급여가 많은 사원을 표시(사원이름과 담당 업무)하시오.
SELECT * from emp WHERE sal > (
    SELECT sal FROM emp WHERE empno = 7499
);
--03.최소 급여를 받는 사원의 이름, 담당 업무 및 급여를 표시하시오(그룹함수 사용).
SELECT empno, ename, job, sal FROM emp WHERE sal = (
    SELECT min(sal) FROM emp
);
--04.평균 급여가 가장 적은 직급(job)과 평균 급여를 표시하시오.
SELECT job, AVG(sal) AS avg_sal
FROM emp
GROUP BY job
HAVING AVG(sal) = (
    SELECT MIN(avg_sal)
    FROM (
        SELECT job, AVG(sal)
        FROM emp
        GROUP BY job
    )
);

SELECT job, AVG(sal) FROM emp WHERE sal IN (
    SELECT MIN(AVG(sal)) FROM emp group by job
);
--05.각부서의 최소 급여를 받는 사원의 이름, 급여, 부서번호를 표시하시오.
SELECT ename, sal, deptno from emp WHERE
    (deptno, sal) IN (
        SELECT
            deptno, min(sal)
        from emp GROUP BY deptno
);
/*
06.담당 업무가 분석가(ANALYST)인 사원보다 급여가 적으면서 
업무가 분석가(ANALYST)가 아닌 사원들을 표시(사원번호, 이름, 담당업무, 급여)하시오.
*/
SELECT empno, ename, job, sal FROM emp WHERE sal < (
    SELECT sal FROM emp WHERE job = 'ANALYST');
/*
07.이름에 K가 포함된 사원과 같은 부서에서 일하는 
사원의 사원번호와 이름을 표시하는 질의를 작성하시오.
*/
SELECT * FROM emp WHERE deptno in (
    SELECT deptno from emp where ename like '%K%'
);

--08.부서 위치가 DALLAS인 사원의 이름과 부서번호 및 담당 업무를 표시하시오.
SELECT empno, ename, sal FROM emp INNER JOIN dept USING (deptno)
WHERE loc = 'DALLAS';

/*
09.평균 급여 보다 많은 급여를 받고 이름에 K가 포함된 사원과 같은 부서에서 
근무하는 사원의 사원번호, 이름, 급여를 표시하시오.
*/
--평균급여보다많은 급여를 받는다.
SELECT * FROM emp WHERE sal > (
    SELECT AVG(sal) FROM emp
);
--이름에 k가포함되어있다.
SELECT deptno FROM emp WHERE ename LIKE '%K%'; 

SELECT empno, ename, sal FROM emp WHERE sal > ALL (SELECT AVG(sal) FROM emp)
    AND deptno IN (
    SELECT deptno FROM emp WHERE ename LIKE '%K%'
);
--10.담당 업무가 MANAGER인 사원이 소속된 부서와 동일한 부서의 사원을 표시하시오.
SELECT * FROM emp WHERE deptno IN (
    SELECT deptno FROM emp WHERE job = 'MANAGER'
);
/*
11.BLAKE와 동일한 부서에 속한 사원의 이름과 입사일을 
표시하는 질의를 작성하시오(단. BLAKE는 제외)
*/
SELECT ename, hiredate FROM emp WHERE deptno IN(
    SELECT deptno FROM emp WHERE ename = 'BLAKE')
    AND NOT ename = 'BLAKE';