--1 details of nurse who is yet to be registered

select *from nurse
where registered ='f';

--2 Write a query in SQL to find the name of the nurse who are the head of their department.

select *from nurse
where position='Head Nurse';

--3 Write a query in SQL to obtain the name of the physicians who are the head of each department

select p.name,d.name from physician p
inner join department d
on p.employeeid = d.head;

--4 Write a query in SQL to count the number of patients who taken appointment with at least one physician
 
select count(distinct(patient)) from appointment;

--5 Write a query in SQL to find the floor and block where the room number 212 belongs to

select blockfloor,blockcode,roomnumber
from room
where roomnumber=212;

--6 Write a query in SQL to count the number available rooms

select count(unavailable)
from room
where unavailable='f';

--7 Write a query in SQL to count the number of unavailable rooms

with avlbl as
(select count(unavailable)
from room
where unavailable='t')
select *from avlbl;

--8 Write a query in SQL to obtain the name of the physician and the departments they are affiliated with

select employeeid,department,p.name as physician_name,d.name as department_name
from physician p
inner join affiliated_with aw
on p.employeeid = aw.physician
inner join department d
on aw.department = d.department_id
where primaryaffiliation='t';

--9 Write a query in SQL to obtain the name of the physicians who are trained for a special treatement

select employeeid,name
from physician
where employeeid in (select distinct physician
                     from trained_in);
                     
--method 2 using join

select p.employeeid,p.name,pr.code,pr.name as name_of_procedure
from physician p
inner join trained_in ti
on p.employeeid=ti.physician
inner join procedure pr
on ti.treatment=pr.code;

--10 Write a query in SQL to obtain the name of the physicians with department who are yet to be affiliated

select p.name,d.name from physician p
inner join affiliated_with aw
on p.employeeid = aw.physician
inner join department d
on aw.department = d.department_id
where primaryaffiliation='f';

--11 Write a SQL query to obtain the names of all the physicians performed a medical procedure but they are not ceritifed to perform.

select ph.name as physician_name,u.procedure
from physician ph
inner join undergoes u
on ph.employeeid = u.physician
left outer join trained_in ti
on u.physician = ti.physician
and u.procedure = ti.treatment
where treatment is null;


--12 Write a query in SQL to obtain the names of all the physicians,  their procedure, date when the procedure was carried out and name of the patient on which procedure have been carried out but those physicians are not cetified for that procedure


select p.name as patient_name,ph.name as physician_name,date_ as date_of_procedure,
       pr.name as procedure_name,code as procedure_code
from physician ph
inner join undergoes u
on ph.employeeid = u.physician
left outer join trained_in ti
on u.physician = ti.physician
and u.procedure = ti.treatment
left outer join patient p
on u.patient = p.ssn
left outer join procedure pr
on u.procedure = pr.code
where treatment is null;


--13 Write a query in SQL to obtain the name and position of all physicians who completed a medical procedure with certification after the date of expiration of their certificate.

select employeeid,name as physician_name,position
from physician
where employeeid in(select u.physician
                    from undergoes u
                    inner join trained_in ti
                    on u.physician = ti.physician
                    where date_ > certificationexpires);
     

--14 Write a query in SQL to obtain the name of all those physicians who completed a medical procedure with certification after the date of expiration of their certificate, their position, procedure they have done,
--date of procedure, name of the patient on which the procedure had been applied and the date when the certification expired        

select employeeid,
       ph.name as physician_name,
       ph.position,
       pr.name as procedure_name,
       u.date_ as date_of_procedure,
       p.name as patient_name,
       ti.certificationexpires
from physician ph
left outer join undergoes u
on ph.employeeid = u.physician
left outer join patient p
on u.patient = p.ssn
left outer join trained_in ti
on u.procedure = ti.treatment
left outer join procedure pr
on ti.treatment = pr.code
where date_ > certificationexpires;


--15 Write a query in SQL to obtain the names of all the nurses who have ever been on call for room 122

select employeeid,name as nurse_name
from nurse
where employeeid in(select oc.nurse from on_call oc
                                    left outer join room r
                                    on oc.blockkfloor = r.blockfloor
                                    and oc.blockcode = r.blockcode
                                    where roomnumber = 122);

--16 Write a query in SQL to Obtain the names of all patients who has been prescribed some medication by his/her physician who has carried
--out primary care and the name of that physician

select p.name as patient_name,
       ph.name as physician_name
from patient p
left outer join prescribes pr
on p.ssn = pr.patient
left outer join physician ph
on pr.physician = ph.employeeid
where pcp = pr.physician;




--17 Write a query in SQL to obtain the names of all patients who has been undergone a procedure costing more than $5,000 and the name of that 
--physician who has carried out primary care

select p.ssn,ph.employeeid as physician_id,
       p.name as patient_name,
       ph.name as primary_care_physician      
from patient p
inner join undergoes u
on p.ssn = u.patient
inner join procedure pr
on u.procedure = pr.code
inner join physician ph
on p.pcp = ph.employeeid
where cost > 5000;




--18 Write a query in SQL to Obtain the names of all patients who had at least two appointment where the nurse who prepped the appointment was a registered nurse and the physician who has carried
--out primary care

select a.patient as patient_id,p.name as patient_name,ph.name as physician_name
from patient p
inner join appointment a
on p.ssn = a.patient
inner join nurse n
on a.prepnurse = n.employeeid
inner join physician ph
on p.pcp = ph.employeeid
where registered='t'
group by a.patient,p.name,ph.name
having count(start_dt) >=2;

--19 Write a query in SQL to Obtain the names of all patients whose primary care is taken by a physician who is not the head of any
--department and name of that physician along with their primary care physician

select p.name as patient_name,
       ph.name as primary_care_physician_name
from patient p
inner join physician ph
on p.pcp = ph.employeeid
where p.pcp not in(select head from department);








