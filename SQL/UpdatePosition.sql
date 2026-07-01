
select 'Company' as TableName,* from company where CompanyName like '%drf%'
select 'Position' as TableName,* from position where Company_Key in (1608) order by ApplicationDate desc
select 'Contact' as TableName,* from Contact where Position_Key in (1956,1284,1558,35)

Begin transaction

declare  @positionKey int

set @positionKey = 2087

Insert Into [EmpSearch].[dbo].[Contact] (Position_Key, Person_Key, ContactDate, ContactMethod, Description) 
       values (@positionKey,0,CAST(GETDATE() AS DATE),'Email','Rejection Received');

update Position set Status = 'Rejected', StatusDate = CAST(GETDATE() as DATE) where Position_Key = @positionKey;

Rollback
commit



-- Existing Company; New Position

declare @note nvarchar(max)
set @note = 'Senior C# / .NET Developer
Remote
Clearance Level and/or eligibility Required: Public Trust

Blu Omega is seeking a Senior C# / .NET Developer to support a federal program focused on supporting the Administration. This role operates remotely and is responsible for the design, development, and maintenance of enterprise-grade software solutions that support financial operations. The position requires extensive experience supporting financial systems and enterprise applications within a mission-driven environment.

Program Overview
Mission overview: Support critical financial operations and modernization efforts across the Administration using secure, scalable, and reliable software solutions.

Key Details
Location: Remote
Clearance: Public Trust
Work Authorization: U.S. Citizenship or Permanent Residency is required as a precondition of employment

Responsibilities
Develop and maintain enterprise C#/.NET applications, services, APIs, and system components supporting financial operations.
Design scalable application architectures, integration patterns, and data flows supporting VHA financial systems and modernization efforts.
Create and refine application designs, including class structures, service interfaces, database interaction layers, and enterprise integration components.
Engineer secure, testable, and maintainable code using modern .NET practices.
Develop and optimize RESTful APIs, message-based integrations, and event-driven processes supporting financial data exchange.
Implement automated build, test, and deployment pipelines leveraging Azure DevOps or equivalent CI/CD tools.
Collaborate with analysts, testers, product owners, and engineering teams to translate requirements into technical solutions.
Support modernization efforts by incorporating cloud services, containerization, and modular application patterns.
Troubleshoot and resolve technical issues ensuring system performance, reliability, and security compliance.
Participate in code reviews, enforce coding standards, and mentor junior developers.
Ensure adherence to security practices and federal compliance standards related to financial systems.
Engage with stakeholders to align software development with operational and regulatory objectives.
Required Qualifications
8+ years of hands-on software development experience in C# and the .NET ecosystem (Framework and .NET Core/6+/7+)
Experience designing and implementing enterprise applications and integration solutions using C#, .NET, Web APIs, and related technologies
Proficiency with SQL Server, Entity Framework, stored procedures, and data interaction layers
Strong knowledge of secure coding practices, authentication, authorization, and enterprise security standards
Experience with CI/CD pipelines, automated testing frameworks, version control (Git), and DevOps practices
Ability to communicate technical concepts clearly to technical and non-technical stakeholders
Preferred Qualifications
Experience supporting federal financial systems or enterprise-scale accounting workflows
Experience with Azure services (App Services, Functions, Service Bus, Key Vault, Azure SQL, containers)
Familiarity with distributed system architecture, message queues, event-driven workflows, and microservice patterns
Experience supporting healthcare, Federal, DoD, or enterprise modernization initiatives
Knowledge of automated testing frameworks (xUnit, NUnit, MSTest) and UI test automation tools
Understanding of financial data structures, ledger management, reconciliation workflows, or transaction processing
Compensation
Salary Range: $120,000 - $135,000
Final compensation is based on technical skills, experience, education, certifications, and clearances.
Blu Omega Benefits & Perks
Medical, Dental, and Vision coverage through national providers
401(k) with company match (eligible after 6 months; vesting applies)
Company-paid Life and AD&D insurance with additional voluntary options
Short-term disability (company-paid) and long-term disability options
Employee Assistance Program (EAP) with 24/7 confidential support and mental health resources
Telehealth and virtual care options available through medical plans
Pet insurance, legal services, and identity theft protection options
Paid Time Off (PTO) for eligible employees
Paid federal holidays for salaried employees
Access to wellness programs, discounts, and lifestyle benefits
Benefits eligibility and offerings may vary based on role, employment status, and program requirements.
Company Overview
Blu Omega is a Woman-Owned Small Business (WOSB) delivering technology and cybersecurity solutions to federal agencies and enterprise clients nationwide. Headquartered in Ashburn, VA, we support mission-critical programs across civilian and defense sectors, including health, national security, and regulatory environments.
We partner with government agencies and large integrators to provide expertise in cybersecurity operations, cloud and infrastructure modernization, data and analytics, and enterprise IT support. Our teams are experienced operating within federal contracting environments, supporting task orders, recompetes, and programs requiring cleared personnel and compliant delivery.

'
--Update Company set Comment = @note where Company_Key = 1347

Insert Into Position (Company_Key, Position, Note, Rate,Link, ApplicationDate, LastContactDate, Status, StatusDate)
       values (1608, 'C#/.Net Developer', @note, '120-135K', 'https://www.glassdoor.com/job-listing/c-net-developer-blu-omega-JV_KO0,15_KE16,25.htm?jl=1010180893287&utm_source=jobalert&utm_medium=email&utm_content=ja-jobpos1-agejp-1010180893287&utm_campaign=jobAlertAlert&tgt=GD_JOB_VIEW&src=GD_JOB_AD&uido=7A57A36BECDA9E413E76BB41CD0D8A0B&ao=1136043&jrtk=5-yul1-0-1js2t0be2l6ht801-2481062728ecd86b&cs=1_7c615a7e&s=224&t=JA&pos=101&ja=380629936&guid=0000019f056134f090932cc9957777db&jobListingId=1010180893287&vt=e&cb=1782508957444&ctt=1782513702175&srs=EMAIL_JOB_ALERT&gdir=1'
	          ,CAST(GETDATE() AS DATE),CAST(GETDATE() AS DATE) ,'Open',CAST(GETDATE() AS DATE));


Insert Into [EmpSearch].[dbo].[Contact] (Position_Key, Person_Key, ContactDate, ContactMethod, Description) 
       values (2258,0,CAST(GETDATE() AS DATE),'Open','Application Submitted');

update position set status = 'Closed' where Position_Key = 2240


delete Position where Position_Key = 1284
delete Contact where Contact_Key = 1533

update position set Company_Key = 32 where Position_Key = 1956
delete company where company_key = 1609