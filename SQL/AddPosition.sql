--Company columns
declare  @company nchar(50), @companyKey int, @phone nchar(13), @link nvarchar(max), @address1 nchar(50), @address2 nchar(50), @city nchar(30), @state nchar(2), @zip nchar(10), @companyNote nvarchar(max), @positionkey int, @jobtitle nchar(200), @positionnote nvarchar(max), @positionlink nvarchar(max), @payrate nchar(25), @positionstatus nchar(10);

set @company = 'Tarpon Total Health Care';
set @phone = '';
set @link = '';
set @address1 = '';
set @address2 = '';
set @city = 'Remote';
set @state = '';
set @zip = '';
set @jobtitle = 'Software Engineer';
set @positionnote = 'Title: Software Engineer

Department: AI Solutions

Reports to: Director of AI Strategy & Solutions

Location: Remote


Summary:

As a Software Engineer at Tarpon Health, you will help build applied AI products that change how healthcare providers run their operations and revenue cycle. You will write code every day, contributing to automation and LLM systems while learning how we take solutions from prototype to production. This role suits early career engineers who are eager to grow, take ownership of well scoped work, and want to apply strong software engineering habits to real healthcare problems.


Key Responsibilities:

Write, test, and maintain code for AI automation solutions.
Help build and integrate LLM features, including prompts, tool use, and retrieval pipelines, into client workflows.
Build and connect data pipelines and APIs that move client data into usable formats for AI systems and EMRs.
Contribute to testing and evaluation so the solutions we ship stay reliable over time.
Debug issues, investigate root causes, and propose practical fixes.
Document your work clearly and share progress, blockers, and questions with the team.
Learn Tarpon tools, frameworks, and delivery practices, and apply them to your projects.
Collaborate with teammates and, with support, work with client teams to understand requirements.

Required Qualifications:

Engineering degree, preferably in Computer Science, Software Engineering, Mathematics, Physics, or Data Science, or equivalent practical experience.
0 to 2 years of professional software development experience, including internships or significant project work.
Working proficiency in at least one programming language such as Python, Java, or C#.
Familiarity with APIs, data structures, and version control with Git.
Exposure to or curiosity about LLMs and AI tools such as LangChain or LlamaIndex.
Preferred Qualification: Lean Six Sigma certification or equivalent experience in process improvement and workflow optimization.

Note: This job description is not intended to be exhaustive. Additional duties and responsibilities may be assigned as necessary to meet the needs of the organization.


We are proud to be an equal opportunity employer. We do not discriminate based on race, color, religion, sex, sexual orientation, gender identity, national origin, age, disability, or any other protected status. All employment decisions are made based on qualifications, merit, and business needs.

Salary
$85,000 - $145,000 per year
';
--******************************************************************
set @positionlink = 'https://www.glassdoor.com/job-listing/software-engineer-tarpon-health-JV_KO0,17_KE18,31.htm?jl=1010180863324&utm_source=jobalert&utm_medium=email&utm_content=ja-jobpos1-agejp-1010180863324&utm_campaign=jobAlertAlert&tgt=GD_JOB_VIEW&src=GD_JOB_AD&uido=7A57A36BECDA9E413E76BB41CD0D8A0B&ao=1136043&jrtk=5-yul1-0-1js2qp40el50k800-79a0e226d9c1975c&cs=1_153c3928&s=224&t=JA&pos=101&ja=396299206&guid=0000019f0560f625b9a6b9752a9aa05f&jobListingId=1010180863324&vt=e&cb=1782506623280&ctt=1782513884086&srs=EMAIL_JOB_ALERT&gdir=1';
set @payrate = '85-145K';
set @companyNote = 'Tarpon Health is a healthcare automation company that helps providers optimize their operations through technology. We bring together healthcare providers with like-minded organizations to accelerate automation in the revenue cycle. Our community of experts and peers helps teams overcome expertise and capacity constraints to build automations that enhance efficiency, reduce costs, and improve patient experience.
';

Begin Transaction;
insert into [dbo].[company] (CompanyName, Phone, Link, Address1, Address2, City, State, Zip, Comment)
       values (@company, @phone,@link,@address1,@address2,@city,@state,@zip,@companyNote);

set @companykey = (select Company_Key from [dbo].[company] where companyName = @company);


--Insert Position
insert into [dbo].[Position] (Company_Key,Position,Note,Rate,Link,ApplicationDate,LastContactDate,Status,StatusDate) 
       values (@companykey,@jobtitle,@positionnote,@payrate,@positionlink,CAST(GETDATE() AS DATE),CAST(GETDATE() AS DATE) ,'Open',CAST(GETDATE() AS DATE));

set @positionkey = (select Position_Key from [dbo].[Position] where Company_Key = @companykey);

--Insert Contact
Insert Into [EmpSearch].[dbo].[Contact] (Position_Key, Person_Key, ContactDate, ContactMethod, Description) 
       values (@positionkey,0,CAST(GETDATE() AS DATE),'Email','Application Submitted');


--select max(position_key) from position
select 'Position' as TableName,* from position where position_key = @positionkey
select 'Company' as TableName,* from company where company_key = @companyKey
select 'Contact' as TableName,* from contact where Position_Key = @positionkey

--delete from position where position_key = 169
--delete from company where Company_Key = 168


--commit;