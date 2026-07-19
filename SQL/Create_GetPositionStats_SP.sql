CREATE PROCEDURE GetPositionStats
AS
BEGIN


	--select distinct(status) from position
	declare @today DATETIME, @yesterday DATETIME, @lastMonday DATETIME, @firstOfTheMonth DATETIME, @firstOfTheYear DATETIME;
	set @today = CAST(GETDATE() AS DATE);
	set @yesterday = CAST(DateAdd(DAY,-1,GETDATE()) AS DATE);
	set @lastMonday = DATEADD(DAY, -((DATEPART(WEEKDAY, GETDATE() - 1) + @@DATEFIRST - 1) % 7), GETDATE());
	set @firstOfTheMonth = DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1);
	set @firstOfTheYear = DATEFROMPARTS(YEAR(GETDATE()), 1, 1);

	-- Validate Date Math
	--Select @today as 'Today', @yesterday as 'Yesterday', @lastMonday as 'Last Monday', @firstOfTheMonth as 'First of the Month', @firstOfTheYear as 'First of the Year'

	-- This Query/SP will return 1 row with counts of:
	--     the number of applications sent out today
	--     the number of applications sent out this Week
	--     the number of applications sent out this Month
	--     the number of applications sent out this Year
	--     
	--     the number of rejections received today
	--     the number of rejections received this Week
	--     the number of rejections received this Month
	--     the number of rejections received this Year

	Select
		SUM(
			case
				when ApplicationDate = @today then 1
				else 0
			End) AS appsToday,
		SUM(
			case
				when ApplicationDate >= @lastMonday then 1
				else 0
			end) as appsThisWeek,
		SUM(
			case
				when ApplicationDate >= @firstOfTheMonth then 1
				else 0
			end) as appsThisMonth,
		SUM(
			case
				when ApplicationDate >= @firstOfTheYear then 1
				else 0
			end) as appsThisYear,

		SUM(
			case
				when (StatusDate >= @today and Status in ('Closed','Rejected')) then 1 
				else 0
			end) as rejectsToday,
		SUM(
			case
				when (StatusDate >= @lastMonday and Status in ('Closed','Rejected')) then 1 
				else 0
			end) as rejectsThisWeek,
		SUM(
			case
				when (StatusDate >= @firstOfTheMonth and Status in ('Closed','Rejected')) then 1 
				else 0
			end) as rejectsThisMonth,
		SUM(
			case
				when (StatusDate >= @firstOfTheYear and Status in ('Closed','Rejected')) then 1 
				else 0
			end) as rejectsThisYear

	From Position;

end;

