-- #####################################################################
-- ### 서브쿼리07 과제
-- #####################################################################


-- 01. employees, jobs 테이블에서 평균 급여보다 적게 급여를 받는 직원의
-- 이름, 직급, 급여를 출력 하시오
select * from jobs;
select * from employees;

select e.first_name, j.job_title, e.salary from employees e, jobs j
where e.job_id = j.job_id and 
                            salary < (select avg(salary) from employees);


-- 02. employees, departments, jobs 테이블을 조인하고
-- 최저 급여 부터 평균 급여를 받는 직원의 이름, 급여, 부서명, 직급을 출력 하시오
select * from departments;
select * from jobs;
select * from employees;

select e.first_name, e.salary, d.department_name, j.job_title from employees e, jobs j, departments d
where e.job_id = j.job_id and e.department_id = d.department_id and
                            salary >= (select min(salary) from employees)
                            and salary <= (select avg(salary) from employees);


-- 03. PROFESSOR, DEPARTMENT 테이블에서 바비 교수보다 입사일이 빠른 교수 중에서  
-- 김도형 교수보다 급여가 많은 교수의 이름, 급여, 입사일, 학과명을 출력 하시오
select * from professor;
select * from department;

SELECT p.name, p.salary, p.hire_date, d.department_name
FROM professor p
JOIN department d ON p.department_id = d.department_id
WHERE p.hire_date < (SELECT hire_date FROM professor WHERE name = '바비')
AND p.salary > (SELECT salary FROM professor WHERE name = '김도형');



-- 04. EMP, DEPT 테이블에서 감우성 차장에게 보고하는 직원들의 사번, 이름, 직급, 
-- 급여, 입사일, 부서명 출력, 단 가장 오래 근무한 직원부터 출력되게 하시오.
SELECT e.emp_no, e.name, e.position, e.salary, e.hire_date, d.dept_name
FROM emp e
JOIN dept d ON e.dept_no = d.dept_no
WHERE e.manager_id = (SELECT emp_no FROM emp WHERE name = '감우성' AND position = '차장')
ORDER BY e.hire_date ASC;



-- 05. EMP2, DEPT2 테이블에서 과장 직급의 최소급여보다 같거나 적게 받는 직원의 이름, 
-- 급여, 직급과 부서명을 출력 하시오 
-- 단, 숫자는 3자리마다 콤마로 표시하고 급여를 적게 받는 직원부터 출력하시오.
SELECT e.name, 
       TO_CHAR(e.salary, '999,999') AS formatted_salary, 
       e.position, 
       d.dept_name
FROM emp2 e
JOIN dept2 d ON e.dept_no = d.dept_no
WHERE e.salary <= (SELECT MIN(salary) FROM emp2 WHERE position = '과장')
ORDER BY e.salary ASC;



-- 06. PROFESSOR, DEPARTMENT 테이블에서 학과별로 입사일이 가장 빠른 교수의 학과명, 
-- 이름, 입사일, 급여를 출력 하시오. 단, 학과번호로 오름차순 정렬하여 출력 하시오
SELECT d.department_name, p.name, p.hire_date, p.salary
FROM professor p
JOIN department d ON p.department_id = d.department_id
WHERE p.hire_date = (SELECT MIN(p2.hire_date) 
                     FROM professor p2 
                     WHERE p2.department_id = p.department_id)
ORDER BY p.department_id;



-- 07. emp, dept 테이블에서 자신의 직급 평균 급여보다 급여가 적은 직원의 이름, 
-- 부서명, 직급, 급여를 출력하시오.
SELECT e.name, d.dept_name, e.position, e.salary
FROM emp e
JOIN dept d ON e.dept_no = d.dept_no
WHERE e.salary < (SELECT AVG(e2.salary) 
                  FROM emp e2 
                  WHERE e2.position = e.position);



-- 08. PROFESSOR, DEPARTMENT 테이블에서 평균 급여보다 급여가 많은 교수의 이름, 급여, 
-- 부서명을 출력 하시오 단, 부서명은 조인이 아닌 스칼라 서브 쿼리를 이용해 조회하고
-- 급여가 많은 교수부터 출력하시오.
SELECT p.name, p.salary, 
       (SELECT d.department_name FROM department d WHERE d.department_id = p.department_id) AS department_name
FROM professor p
WHERE p.salary > (SELECT AVG(salary) FROM professor)
ORDER BY p.salary DESC;



-- 09. STUDENT, DEPARTMENT 테이블에서 학과번호, 학과명, 학과 별 최저 몸무게, 
-- 평균 몸무게, 최고 몸무게를 출력 하시오
SELECT s.department_id, d.department_name, 
       MIN(s.weight) AS min_weight, 
       AVG(s.weight) AS avg_weight, 
       MAX(s.weight) AS max_weight
FROM student s
JOIN department d ON s.department_id = d.department_id
GROUP BY s.department_id, d.department_name;



-- 10. STUDENT, DEPARTMENT 테이블에서 학생의 학번, 이름, 나이, 학과명을 출력하시오.
-- 단, 나이순으로 오름차순 정렬하고 한 페이지에 5명씩 출력되게 하여 2 페이지에 해당하는
-- 데이터를 출력하시오.
SELECT s.student_id, s.name, s.age, d.department_name
FROM student s
JOIN department d ON s.department_id = d.department_id
ORDER BY s.age
OFFSET 5 ROWS FETCH NEXT 5 ROWS ONLY;



-- 11. orders, customers 테이블에서 년도별 고객의 주문금액 주문년도, 고객아이디, 
-- 고객이름을 출력하시오.
-- 단, 년도로 오른차순, 주문금액으로 내림차순 정렬하고 한 페이지에 10명씩 출력되게 하여 
-- 3페이지에 해당하는 페이지를 출력하시오.
SELECT EXTRACT(YEAR FROM o.order_date) AS order_year, 
       c.customer_id, c.customer_name, 
       o.order_amount
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY order_year ASC, o.order_amount DESC
OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY;





