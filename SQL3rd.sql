create database Rusin109,
use Rusin109,
go,

alter database RS928
collate Chinese_PRC_CI_AS

if exists(select name from sysobjects
	where name='DEPARTMENT' and type='U')
	drop table DEPARTMENT
go
create table DEPARTMENT
(
	DNO char(4) primary key,
	DNAME nchar(20),
	HEAD nchar(20),
)


create table DORM
(
	DORMNO char(5) primary key,
	TELE char(7),
)

create table COURSE
(
	CNO char(2) primary key,
	CNAME nchar(20),
	CPNO char(2),
	CREDIT int,
	TEACHER nchar(8),
	foreign key (CPNO) references COURSE(CNO),
)

create table STUDENT
(
	SNO char(6) primary key,
	SNAME nchar(8) not null,
	SSEX nchar(2),
	SAGE int,
	DNO char(4) foreign key references DEPARTMENT(DNO),
	DORMNO char(5)foreign key references DORM(DORMNO),
)

create table GRADE
(
	SNO char(6),
	CNO char(2),
	SCORE int,
	constraint pk_grade primary key(SNO,CNO),
	foreign key (CNO) references COURSE(CNO),
	foreign key (SNO) references STUDENT(SNO),
)

insert into DEPARTMENT
values('1',N'计算机系',N'王凯峰');
insert into DEPARTMENT
values('2',N'数学系',N'李永军');
insert into DEPARTMENT
values('3',N'物理系',N'康健');
insert into DEPARTMENT
values('4',N'中文系',N'秦峰');

insert into DORM
values('2101','8302101');
insert into DORM
values('2202','8302202');
insert into DORM
values('2303','8302303');
insert into DORM
values('2404','8302404');
insert into DORM
values('2505','8302505');

insert into COURSE
values('01',N'数据库原理','05',4,N'王凯');
insert into COURSE
values('02',N'高等数学',null,6,N'张凤');
insert into COURSE
values('03',N'信息系统','01',2,N'李明');
insert into COURSE
values('04',N'操作系统','06',4,N'许强');
insert into COURSE
values('05',N'数据结构','07',4,N'路飞');
insert into COURSE
values('06',N'算法设计',null,2,N'黄海');
insert into COURSE
values('07',N'C语言','06',3,N'高达');

insert into STUDENT
values('990101',N'原野',N'男',21,'1','2101');
insert into STUDENT
values('990102',N'张原',N'男',21,'1','2101');
insert into STUDENT
values('990103',N'李军',N'男',20,'1','2101');
insert into STUDENT
values('990104',N'汪远',N'男',20,'1','2101');
insert into STUDENT
values('990105',N'齐欣',N'男',20,'1','2101');
insert into STUDENT
values('990201',N'王大鸣',N'男',19,'2','2202');
insert into STUDENT
values('990202',N'徐东',N'男',19,'2','2202');
insert into STUDENT
values('990301',N'张扬',N'女',21,'1','2303');
insert into STUDENT
values('990302',N'于洋',N'女',20,'3','2303');
insert into STUDENT
values('990303',N'姚志旬',N'男',19,'4','2404');
insert into STUDENT
values('990401',N'高明镜',N'男',19,'4',null);
insert into STUDENT
values('990402',N' 明天',N'男',21,'4','2404');


insert into GRADE
values('990101','01',85);
insert into GRADE
values('990101','03',65);
insert into GRADE
values('990101','04',83);
insert into GRADE
values('990101','07',72);
insert into GRADE
values('990102','02',80);
insert into GRADE
values('990102','04',81);
insert into GRADE
values('990102','01',null);
insert into GRADE
values('990103','07',74);
insert into GRADE
values('990103','06',74);
insert into GRADE
values('990103','01',74);
insert into GRADE
values('990103','02',70);
insert into GRADE
values('990103','04',70);
insert into GRADE
values('990104','01',55);
insert into GRADE
values('990104','02',42);
insert into GRADE
values('990104','03',0);
insert into GRADE
values('990105','03',85);
insert into GRADE
values('990105','06',null);
insert into GRADE
values('990301','01',46);
insert into GRADE
values('990301','02',70);
insert into GRADE
values('990302','01',85);
insert into GRADE
values('990401','01',0);

use Rusin109
/*1-5*/
select sno,sname,dormno from STUDENT where DNO=1 order by DORMNO asc
select *from STUDENT where DNO=1 order by SSEX asc,SAGE desc
select SNAME,2003-sage'BIRTHDAY' from STUDENT where DNO=2 
select distinct CNO from GRADE 
select SNAME,DORMNO from STUDENT where sage>=21 and sage<=23
/*6-10*/
select SNAME from STUDENT where DNO in(2,3,4)
select *from STUDENT where ltrim(sname like N'张%'
select *from STUDENT where ltrim(sname) like N'_明%'
select CNAME,TEACHER from COURSE where cpno is null
select *from STUDENT where DNO=1 and ssex=N'男'

/*11-15*/
--select DNO,count(SNO)as 人数 from STUDENT group by DNO
select DNO,count(SNO)as 人数 from STUDENT where DNO=1 group by DNO

select DNO,max(SCORE)as 最高分,min(SCORE)as 最低分,avg(SCORE)as 平均分 from STUDENT,GRADE
where DNO=1 and GRADE.SNO=STUDENT.SNO and CNO='01' group by DNO

select STUDENT.SNO,SNAME,count(GRADE.SNO)as 选修门数 from STUDENT,GRADE where GRADE.SNO=STUDENT.SNO
group by STUDENT.SNO ,SNAME  having  count(GRADE.SNO)>=4

select distinct HEAD,DORMNO from DEPARTMENT,STUDENT where DEPARTMENT.DNO=STUDENT.DNO

select SNAME,STUDENT.DORMNO,TELE from STUDENT,DORM where STUDENT.DORMNO=DORM.DORMNO

--16-20
select C1.CNO,C1.CNAME,C2.CPNO as 一级间接先修课,C3.CPNO as 二级间接先修课 from COURSE C1,COURSE C2,COURSE C3
where C1.CPNO=C2.CNO and C2.CPNO=C3.CNO
/*select C1.CNO,C1.CNAME,C2.CPNO as 一级间接先修课,C3.CPNO as 二级间接先修课,C4.CPNO as 三级间接先修课 from COURSE C1,COURSE C2,COURSE C3,COURSE C4
where C1.CPNO=C2.CNO and C2.CPNO=C3.CNO and C3.CPNO=C4.CNO or C3.CPNO=null */
select STUDENT.SNO,SNAME,count(CNO)as 选课数目,avg(SCORE) as 平均分
from STUDENT left join GRADE on STUDENT.SNO=GRADE.SNO
group by STUDENT.SNO,SNAME

select STUDENT.SNO,SNAME,CNAME 选修课程,TEACHER 教师 from COURSE,STUDENT,GRADE
where COURSE.CNO=GRADE.CNO and STUDENT.SNO=GRADE.SNO

select SNAME,TELE 宿舍联系电话 from DEPARTMENT,DORM,STUDENT
where DEPARTMENT.DNO=STUDENT.DNO and DORM.DORMNO=STUDENT.DORMNO and HEAD=N'秦峰'

select SNAME,SAGE from DEPARTMENT,STUDENT
where STUDENT.DNO=DEPARTMENT.DNO and DNAME<>N'计算机系'and SAGE>=(select max(SAGE) from STUDENT,DEPARTMENT where DNAME = N'计算机系')

--21-25
select SNAME,min(SCORE) as 选修课最低分 from STUDENT,GRADE
where STUDENT.SNO=GRADE.SNO  group by STUDENT.SNO,SNAME
having min(SCORE)>=60

/*select distinct SNO from GRADE G
where CNO in('01','02')
and exists(select 1 from GRADE where SNO=G.SNO and CNO in('01','02') and CNO<>G.CNO)
*/
--select distinct SNO from GRADE G where CNO='01' or CNO='02'group by SNO having count(CNO)>=2
select SNAME,STUDENT.SNO from STUDENT,GRADE where STUDENT.SNO=GRADE.SNO 
and CNO in('01','02') group by STUDENT.SNO,SNAME having count(CNO)>=2

select SNAME,STUDENT.SNO from STUDENT,GRADE
where STUDENT.SNO=GRADE.SNO and CNO in(select CNO from GRADE where SNO='990102') and STUDENT.SNO<>'990102'group by STUDENT.SNO,SNAME 
having count(CNO)>=(select count(CNO) from GRADE where SNO='990102')

select SNAME,SAGE from STUDENT where DNO=1 and SAGE<=20

select SNAME from COURSE,STUDENT,GRADE
where STUDENT.SNO=GRADE.SNO and COURSE.CNO=GRADE.CNO 
and CNAME in(N'数据库原理',N'高等数学')
group by GRADE.SNO,SNAME
having count(CNAME)>=2