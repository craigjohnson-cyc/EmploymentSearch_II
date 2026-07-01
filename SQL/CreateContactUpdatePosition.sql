select * from company where CompanyName like '%microsoft%'
select * from position where Company_Key = 8
select * from Contact where Position_Key = 1160


begin transaction

Insert Into [EmpSearch].[dbo].[Contact] (Position_Key, Person_Key, ContactDate, ContactMethod, Description) 
       values (1160,0,CAST(GETDATE() AS DATE),'Email','Rejection received');

update Position set Status = 'Closed', StatusDate = CAST(GETDATE() AS DATE) where Position_Key = 1160

rollback
commit
