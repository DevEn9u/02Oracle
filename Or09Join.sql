/*********
파일명 : Or09Join.SQL
테이블 조인
설명 : 두개 이상의 테이블을 동시에 참조하여 데이터를 가져와야 할 때
사용하는 SQL문
*********/

--HR계정에서 진행합니다.

/*
1] inner join(내부 조인)
- 가장 많이 사용하는 조인문으로 테이블간에 연결조건을 모두 만족하는
레코드를 검색할때 사용한다.
- 일반적으로 기본키(Primary key)와 외래키(foreign key)를 사용하여
join하는 경우가 대부분이다.
- 두 개의 테이블에 동일한 이름의 컬럼이 존재하면 "테이블명.컬럼명"
형태로 기술해야 한다.
- 테이블의 별칭을 사용하면 "별칭.컬럼명" 형태로 기술할 수 있다.

형식1(표준방식)
    select 컬럼1, 컬럼2
    from 테이블1 inner join 테이블2
        on 테이블1.기본키컬럼 = 테이블2.외래키컬럼
    where 조건1 and 조건2 ...;
*/

/*
시나리오] 사원테이블과 부서테이블을 조인하여 각 직원이 어떤 부서에서
    근무하는지 출력하시오. 단, 표준방식으로 작성하시오.
    출력결과: 사원아이디, 이름1, 이름2, 이메일, 부서번호, 부서명
*/
-- 아래 쿼리문은 에러 발생
select
    employee_id, first_name, email,
    department_id, department_name
from employees inner join departments
    on employees.department_id = departments.department_id;
/*
첫번째 쿼리문을 실행하면 열의 정의가 애매하다는 에러가 발섕한다.
부서번호를 뜻하는 department_id가 양쪽 테이블 모두에 존재하므로
어떤 테이블에서 가져와 인출해야할지 명시해야한다.
*/
select
    employee_id, first_name, email,
    employees.department_id, department_name
from employees inner join departments
    on employees.department_id = departments.department_id;
/* 실행결과에서는 소속된 부서가 없는 1명을 제외한 나머지 106명의
레코드가 인출된다. 즉, inner join은 조인한 테이블 양쪽 모두 만족하는
레코드가 인출된다.*/

-- AS(알리아스)를 통해 테이블에 별칭을 부여하면 간단하게 쿼리문을 작성할 수 있다.
select
    employee_id, first_name, email,
    Emp.department_id, department_name
from employees "Emp" inner join departments "Dep"
    on Emp.department_id = Dep.department_id;

--3개 이상의 테이블 조인하기
/*
시나리오] seattle(시애틀)에 위치한 부서에서 근무하는 직원의 정보를
    출력하는 쿼리문을 작성하시오. 단 표준방식으로 작성하시오. 
    출력결과] 사원이름, 이메일, 부서아이디, 부서명, 담당업무아이디, 
        담당업무명, 근무지역
    위 출력결과는 다음 테이블에 존재한다. 
    사원테이블 : 사원이름, 이메일, 부서아이디, 담당업무아이디
    부서테이블 : 부서아이디(참조), 부서명, 지역일련번호(참조)
    담당업무테이블 : 담당업무명, 담당업무아이디(참조)
    지역테이블 : 근무부서, 지역일련번호(참조)
*/
-- 1. locations 테이블을 통해 Seattle이 위치한 레코드의 일련번호를 참조한다.
select * from locations where city = initcap('seattle');
-- location_id가 1700인 것을 확인

-- 2. location_id를 통해 부서테이블의 레코드를 확인한다.
select * from departments where location_id = 1700;
-- 직원수가 21명인 것을 확인 

-- 3. location_id를 통해 사원테이블의 레코드를 확인한다.
select * from employees where department_id = 10; -- 1명
select * from employees where department_id = 30; -- 6명

-- 4. 담당업무명(job_id) 확인하기
select * from jobs where job_id = 'PU_MAN'; --Purchasing Manager
select * from jobs where job_id = 'PU_CLERK';--Purchasing Clerk

/*
5. join 쿼리문 작성
양쪽 테이블에 동시에 존재하는 컬럼인 경우에는
반드시 테이블명이나 별칭을 명시해야 한다.
*/
SELECT 
    first_name, last_name, email,
    departments.department_id, department_name,
    city, state_province,
    jobs.job_id, job_title
from locations
    inner join departments
        on locations.location_id = departments.location_id
    inner join employees
        on employees.department_id = departments.department_id
    inner join jobs
        on employees.job_id = jobs.job_id
    where city = initcap('seattle');

-- 테이블의 별칭을 사용하면 상대적으로 간단하게 쿼리문 작성 가능.
select 
    first_name, last_name, email,
    D.department_id, department_name,
    city, state_province,
    J.job_id, job_title
from locations L
    inner join departments D
        on L.location_id = D.location_id
    inner join employees E
        on E.department_id = departments.department_id
    inner join jobs J
        on E.job_id = J.job_id
    where city = initcap('seattle');

/*
형식2] 오라클 방식
    select 컬럼1, 컬럼2, ...
    from 테이블1, 테이블2
    where
        테이블1.기본키컬럼 = 테이블2.외래키컬럼
        and 조건1 and 조건2 ...;
표준방식에서 사용한 inner join과 on을 제거하고 조인의 조건을
where절에 표기하는 방식이다.
*/

/*
시나리오] 사원테이블과 부서테이블을 조인하여 각 직원이 어떤 부서에서
    근무하는지 출력하시오. 단, 오라클 방식으로 작성하시오.
    출력결과: 사원아이디, 이름1, 성, 이메일, 부서번호, 부서명
*/
select
    employee_id, first_name, last_name,
    email, Dep.department_id, department_name
from employees Emp, departments Dep
where Emp.department_id = Dep.department_id;

/*
시나리오] Seattle(시애틀)에 위치한 부서에서 근무하는 직원의 정보를
    출력하는 쿼리문을 작성하시오. 단 오라클 방식으로 작성하시오. 
    출력결과] 사원이름, 이메일, 부서아이디, 부서명, 담당업무아이디, 
        담당업무명, 근무지역
    위 출력결과는 다음 테이블에 존재한다. 
    사원테이블 : 사원이름, 이메일, 부서아이디, 담당업무아이디
    부서테이블 : 부서아이디(참조), 부서명, 지역일련번호(참조)
    담당업무테이블 : 담당업무명, 담당업무아이디(참조)
    지역테이블 : 근무부서, 지역일련번호(참조)
*/
select
    first_name, last_name, email,
    D.department_id, department_name,
    J.job_id, job_title,
    city, state_province
from locations L, departments D, employees E, jobs J
where
    L.location_id = D.location_id and
    D.department_id = E.department_id and
    E.job_id = J.job_id and
    lower(city) = 'seattle';


/*
2] Outer join(외부조인)
outer join은 inner join과 달리 두 테이블에 조인 조건이 정확히 일치하지
않아도 기준이 되는 테이블에서 레코드를 인출하는 방식이다.
outer join을 사용할 때는 반드시 기준이 되는 테이블을 결정하고 쿼리문을
작성해야한다.
    => left(왼쪽테이블), right(오른쪽테이블), full(양쪽테이블)

형식1(표준방식)
    select 컬럼1, 컬럼2...
    from 테이블1
        left[right, full] outer join
            on 테이블1.기본기 = 테이블2.참조키
    where 조건1 and 조건2 or 조건3 ...;
*/
/*
시나리오] 전체직원의 사원번호, 이름, 부서아이디, 부서명, 지역을
외부조인(left)을 통해 출력하시오.
*/
select
    employee_id, first_name, last_name,
    em.department_id, department_name, city
from employees Em
    left outer join departments De
        on Em.department_id = De.department_id
    left outer join locations Lo
        on De.location_id = lo.location_id;
/* 실행결과를 보면 내부조인과는 다르게 107개의 레코드가 인출된다.
부서가 지정되지 않은 사원까지 인출되기 때문인데. 이 경우 부서쪽에
레코드가 없으므로 null이 출력된다.*/

/*
형식2(오라클방식)
    select 컬럼1, 컬럼2
    from 테이블1, 테이블2
    where
        테이블1.기본키 = 테이블2.외래키 (+)
        and 조건1 and 조건2;
- 오라클 방식으로 변경시에는 outer join 연산자인 (+)를 붙여준다.
- 위의 경우 왼쪽 테이블이 기준이 된다.
- 기준이 되는 테이블을 변경할때는 테이블의 위치를 옮겨준다.
  (+)를 옮기지 않는다.
*/

/*
시나리오] 전체직원의 사원번호, 이름, 부서아이디, 부서명, 지역을
외부조인(left)을 통해 출력하시오. 단, 오라클 방식으로 작성하시오.
*/
select
    employee_id, first_name, last_name,
    em.department_id, department_name, city
from employees em, departments de, locations lo
where
    em.department_id = de.department_id (+) and
    de.location_id = lo.location_id (+);
    
/*
퀴즈] 2007년에 입사한 사원을 조회하시오. 단, 부서에 배치되지 않은
직원의 경우 <부서없음>으로 출력하시오. 단, 표준방식으로 작성하시오.
출력항목 : 사번, 이름, 성, 부서명
*/
select
    employee_id, first_name, last_name,
    hire_date, nvl(department_name, '<부서없음>')
from employees em left outer join departments de
    on em.department_id = de.department_id
where
   hire_date like '07%';
   
--강사님 버젼
-- 우선 저장된 레코드를 러프하게 확인한다.
select first_name, hire_date, to_char(hire_date, 'yyyy') from employees;
-- 2007년에 입사한 사원을 인출한다.
select first_name, hire_date from employees
where to_char(hire_date, 'yyyy') = '2007';
/* 외부조인을 표준방식으로 작성한 후 결과를 확인한다.
nvl()함수를 통해 null값을 지정한 값으로 변경햊분다. 결과는 19개 인출됨 */
select employee_id, first_name, last_name, nvl(department_name, '<부서없음>')
from employees E left outer join departments D
    on E.department_id = D.department_id
where to_char(hire_date, 'yyyy') = '2007';

/*
시나리오] 위 쿼리문을 오라클 방식으로 변경하시오.
*/
select employee_id, first_name, last_name, nvl(department_name, '<부서없음>')
from employees Em, departments Dm
where Em.department_id = Dm.department_id (+)
    and to_char(hire_date, 'yyyy') = '2007';

/*
3] self join(셀프조인)
셀프조인은 하나의 테이블에 있는 컬럼끼리 조인해야 하는 경우 사용한다.
즉 자기자신의 테이블과 조인을 맺는 것이다.
셀프조인에서는 별칭이 테이블을 구분하는 구분자의 역할을 하므로 굉장히
중요하다.
형식] select 별칭1.컬럼, 별칭2.컬럼 ...
        from 테이블A 별칭1, 테이블A 별칭2
        where 별칭1.컬럼 = 별칭2.컬럼;
*/

/*
시나리오] 사원테이블에서 각 사원의 매니저 아이디와 매니저 이름을 출력하시오.
    단, 이름은 first_name과 last_name을 하나로 연결해서 출력하시오.
*/
select 
    empclerk.employee_id "사원번호",
    empclerk.first_name || ' ' || empclerk.last_name "full_name",
    empclerk.manager_id "매니저사원번호",
    empManager.first_name || ' ' || empManager.last_name "Manager_full_name"
from employees empClerk, employees empManager
where empClerk.manager_id = empManager.employee_id;

/*
시나리오] self join을 사용하여 'Kimberely / Grant' 사원보다 입사일이
늦은 사원의 이름과 입사일을 출력하시오.
출력목록: first_name, last_name, hire_date
*/

-- Kimberely의 입사일 확인
select first_name, last_name, hire_date
from employees
where first_name = 'Kimberely' and last_name = 'Grant';
-- 입사일이 07/05/24인 것을 확인, 이 이후에 입사한 사원의 레코드 인출
select first_name, last_name, hire_date
from employees
where hire_date > '07/05/24' order by first_name;

-- self join으로 쿼리문 작성(킴벌리와 사원 입장의 테이블로 분할)
select clerk.first_name, clerk.last_name, clerk.hire_date
from employees Kim, employees Clerk
where kim.hire_date < clerk.hire_date and
    kim.first_name = 'Kimberely' and kim.last_name = 'Grant'
order by first_name;

/*
using: join문에서 주로 사용하는 on절을 대체할 수 있는 문장
    형식] on 테이블1.컬럼 = 테이블2.컬럼
            => using(컬럼)
*/
/*
시나리오] Seattle에 위치한 부서에서 근무하는 직원의 정보를
    출력하는 쿼리문을 작성하시오. 단 using을 사용해서 작성하시오.
    출력결과] 사원이름, 이메일, 부서아이디, 부서명, 담당업무아이디,
        담당업무명, 근무지역
*/
select 
    first_name, last_name, email, 
    department_id, departements.department_name,
    jobs.job_id, job_title, city, state_province
from locations inner join departments using(location_id)
    inner join employees using(department_id)
    inner join jobs using(job_id)
where city = initcap('seattle');
/*
    위 쿼리문은 using문을 사용하면서 인출하려는 데이터에 별칭을 붙였다.
    using절에 사용된 참조컬럼의 경우 select절에서 별칭을 붙이면 오히려
    에러가 발생한다.
    using절에 사용된 컬럼은 양쪽 테이블에 동시에 존재하는 컬럼이라는
    것을 전제로 작성되기 때문에 굳이 별칭을 사용할 필요가 없기 때문이다.
    즉 using은 테이블의 별칭 및 on절을 제거하여 좀 더 심플하게 
    join 쿼리문을 작성할 수 있게 해준다.
*/
select 
    first_name, last_name, email, 
    department_id, department_name,
    job_id, job_title, city, state_province
from locations inner join departments using(location_id)
    inner join employees using(department_id)
    inner join jobs using(job_id)
where city = initcap('seattle');

/*
 퀴즈] 2005년에 입사한 사원들중 California(STATE_PROVINCE) / 
 South San Francisco(CITY)에서 근무하는 사원들의 정보를 출력하시오.
 단, 표준방식과 using을 사용해서 작성하시오.
 
 출력결과] 사원번호, 이름, 성, 급여, 부서명, 국가코드, 국가명(COUNTRY_NAME)
        급여는 세자리마다 컴마를 표시한다. 
 참고] '국가명'은 countries 테이블에 입력되어있다. 
*/
select
    employee_id, first_name, last_name, 
    ltrim(to_char(salary, '$999,000')) "SALARY",
    department_name, country_id, country_name
from countries inner join locations using(country_id)
    inner join departments using(location_id)
    inner join employees using(department_id)
where
    substr(hire_date, 1, 2) = 05 and
    state_province = initcap('california') and
    city = 'South San Francisco';

-- 강사님 버젼
-- 2005년에 입사한 사원 인출(결과: 29명)
select first_name, hire_date from employees;
-- substr() 이용
select first_name, hire_date from employees
where substr(hire_date, 1, 2) = 05;
-- to_char() 이용
select first_name, hire_date from employees
where to_char(hire_date, 'yyyy') = 2005;
-- 문제에서 주어진 지역정보로 부서번호를 확인(결과: 지역번호 1500)
select * from locations where city = 'South San Francisco'
    and state_province = 'California';
-- 지역번호 1500을 통해 해당 위치에 있는 부서를 확인(결과: 부서번호 50)
select * from departments where location_id = 1500;
-- 앞에서 확인한 정보를 토대로 쿼리문 작성
select * from employees where department_id = 50 and
    to_char(hire_date, 'yyyy') = 2005;
/* 2005년에 입사했고, 50번부서(shipping)에 근무하는 사원의
정보를 인출해야 한다.*/
select 
    employee_id, first_name, last_name, to_char(salary, '$0,000'),
    department_name, country_id, country_name
from employees inner join departments using(department_id)
    inner join locations using(location_id)
    inner join countries using(country_id)
where to_char(hire_date, 'yyyy') = 2005 and
    city = 'South San Francisco' and
    state_province = 'California';

///////////////////////////////////////
/* 과제 24.06.28 */
/* 1. inner join 방식중 오라클방식을 사용하여 first_name이
Janette 인 사원의 부서ID와 부서명을 출력하시오.
출력목록] 부서ID, 부서명 */

/* 오라클 방식
    select 컬럼1, 컬럼2, ...
    from 테이블1, 테이블2
    where
        테이블1.기본키컬럼 = 테이블2.외래키컬럼
        and 조건1 and 조건2 ...;
*/
select dep.department_id, department_name
from employees emp, departments dep
    where emp.department_id = dep.department_id
    and first_name = 'Janette';
/*
    오라클 방식은 표준방식에서 INNER JOIN 대신 comma(,)를 이용해서 테이블을
    JOIN하고 ON절 대신 WHERE절에 JOIN될 컬럼을 명시한다.
*/

/*
2. inner join 방식중 SQL표준 방식을 사용하여 사원이름과 함께 
그 사원이 소속된 부서명과 도시명을 출력하시오.
출력목록] 사원이름, 부서명, 도시명
*/

select first_name, last_name, department_name, city
from employees e
inner join departments d
    on e.department_id  = d.department_id
inner join locations l
    on d.location_id = l.location_id;

--    select 컬럼1, 컬럼2
--    from 테이블1 inner join 테이블2
--        on 테이블1.기본키컬럼 = 테이블2.외래키컬럼

/*
3. 사원의 이름(FIRST_NAME)에 'A'가 포함된 모든사원의 이름과 부서명을 
출력하시오.
출력목록] 사원이름, 부서명
*/
select first_name, last_name, department_name
from employees e, departments d
where e.department_id = d.department_id and
first_name like '%A%';

/*
4. “city : Toronto / state_province : Ontario” 에서 근무하는 
모든 사원의 이름, 업무명, 부서번호 및 부서명을 출력하시오.
출력목록] 사원이름, 업무명, 부서ID, 부서명
*/
select first_name, last_name, job_id, e.department_id, department_name
from employees e, departments d, locations l
where 
    e.department_id = d.department_id and
    d.location_id = l.location_id and
    l.city = 'Toronto' and
    l.state_province = 'Ontario';

--강사님 버젼
SELECT
    first_name, last_name, job_id, department_id, department_name
FROM locations
    INNER join departments USING(location_id)
    INNER join employees USING(department_id)
    INNER join jobs USING(job_id)
WHERE
    city = 'Toronto' AND state_province = 'Ontario';

/*
5. Equi Join을 사용하여 커미션(COMMISSION_PCT)을 받는 모든 사원의 
이름, 부서명, 도시명을 출력하시오. 
출력목록] 사원이름, 부서ID, 부서명, 도시명
*/
SELECT first_name, last_name, e.department_id, department_name, city
FROM employees e, departments d, locations l
WHERE
    e.department_id = d.department_id and
    d.location_id = l.location_id and
    commission_pct IS NOT NULL;

/*
6. inner join과 using 연산자를 사용하여 50번 부서(DEPARTMENT_ID)에
속하는 모든 담당업무(JOB_ID)의 고유목록(distinct)을 
부서의 도시명(CITY)을 포함하여 출력하시오.
출력목록] 담당업무ID, 부서ID, 부서명, 도시명
*/
SELECT DISTINCT job_id, department_id, department_name, city
FROM employees
    INNER JOIN departments USING(department_id)
    INNER JOIN locations USING(location_id)
WHERE department_id = 50;

/*
7. 담당업무ID가 FI_ACCOUNT인 사원들의 메니져는 누구인지 출력하시오. 
단, 레코드가 중복된다면 중복을 제거하시오. 
출력목록] 이름, 성, 담당업무ID, 급여
*/
SELECT DISTINCT
    eManager.first_name, eManager.last_name, 
    eManager.job_id, eManager.salary 
FROM employees eClerk, employees eManager
WHERE eClerk.manager_id = eManager.employee_id
and eClerk.job_id = 'FI_ACCOUNT';

--강사님 버젼
--1. 담당업무가 FI_ACCOUNT인 사원들의 매니저 아이디 조회
SELECT employee_id, first_name, manager_id FROM employees
WHERE job_id = 'FI_ACCOUNT';
--2. 매니저 아이디가 108번이므로 사원번호 조회
SELECT * FROM employees WHERE employee_id = 108;
--3. 셀프조인을 통해서 해당 사원의 매니저 정보를 출력한다.
SELECT DISTINCT
    empManager.first_name, empManager.last_name, 
    empManager.job_id, empManager.salary
FROM employees empClerk, employees empManager /* 사원과 매니저 입장의 테이블로 구분 */
WHERE empClerk.manager_id = empManager.employee_id
AND empClerk.job_id = 'FI_ACCOUNT'; /* 사원입장의 담당업무 */


/*
8. 각 부서의 메니져가 누구인지 출력하시오. 
출력결과는 부서번호를 오름차순 정렬하시오.
출력목록] 부서번호, 부서명, 이름, 성, 급여, 담당업무ID
※ departments 테이블에 각 부서의 메니져가 있습니다.
*/
SELECT
    e.department_id, department_name, first_name, last_name,
    salary, job_id
FROM employees e, departments d
WHERE
    e.employee_id = d.manager_id
ORDER BY department_id;
/* 위 쿼리문은 JOIN의 조건으로 사용한 컬럼이 서로 다르므로 USING절은 사용할 수 없다. */

/*
9. 담당업무명이 Sales Manager인 사원들의 입사년도와 입사년도(hire_date)별 
평균 급여를 출력하시오. 출력시 년도를 기준으로 오름차순 정렬하시오. 
출력항목 : 입사년도, 평균급여
*/
SELECT
    to_char(hire_date, 'yyyy'), avg(salary)
FROM employees e, jobs j
WHERE
    e.job_id = j.job_id AND
    job_title = 'Sales Manager'
--   group by 안에는 별칭 작성 불가
    GROUP BY to_char(hire_date, 'yyyy'); 

--강사님 버젼
SELECT 
    to_char(hire_date, 'yyyy') hyear, AVG(salary)
FROM employees INNER JOIN jobs USING(job_id)
WHERE job_title = 'Sales Manager'
GROUP BY to_char(hire_date, 'yyyy') /* 연도별로 그룹을 묶어준다. */
ORDER BY hyear; /* ORDER BY 절이 제일 늦게 실행되고, 별칭 사용 가능하다. */