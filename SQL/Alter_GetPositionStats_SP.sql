USE [EmpSearch]
GO

/****** Object:  StoredProcedure [dbo].[GetPositionStats]    Script Date: 7/17/2026 8:47:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[GetPositionStats]
AS
BEGIN


	--select distinct(status) from position
	declare @today DATETIME, @lastMonday DATETIME, @firstOfTheMonth DATETIME, @firstOfTheYear DATETIME;
	set @today = GETDATE();
	-- Remove time portion
	set @today = CAST(CAST(@today AS DATE) AS DATETIME);
	set @lastMonday = DATEADD(DAY, -((DATEPART(WEEKDAY, @today - 1) + @@DATEFIRST - 1) % 7), @today);
	set @firstOfTheMonth = DATEFROMPARTS(YEAR(@today), MONTH(@today), 1);
	set @firstOfTheYear = DATEFROMPARTS(YEAR(@today), 1, 1);

	-- Validate Date Math
	--Select @today as 'Today', @lastMonday as 'Last Monday', @firstOfTheMonth as 'First of the Month', @firstOfTheYear as 'First of the Year'
	--
	-- This stored procedure will compute 8 values from the Positions table and return as a single row
	--   The number of applications sent out today
	--   The number of applications sent out this week
	--   The number of applications sent out this month
	--   The number of applications sent out this year
	--   The number of rejections received today
	--   The number of rejections received this week
	--   The number of rejections received this month
	--   The number of rejections received this year
	Select
		-- Compute the count of applications sent out today
		SUM(
			case
				when ApplicationDate = @today then 1
				else 0
			End) AS appsToday,
		-- Compute the count of applications sent out this week
		SUM(
			case
				when ApplicationDate >= @lastMonday then 1
				else 0
			end) as appsThisWeek,
		-- Compute the count of applications sent out this month
		SUM(
			case
				when ApplicationDate >= @firstOfTheMonth then 1
				else 0
			end) as appsThisMonth,
		-- Compute the count of applications sent out this year
		SUM(
			case
				when ApplicationDate >= @firstOfTheYear then 1
				else 0
			end) as appsThisYear,

		-- Compute the count of rejections received today
		SUM(
			case
				when (StatusDate >= @today and Status in ('Closed','Rejected')) then 1 
				else 0
			end) as rejectsToday,
		-- Compute the count of rejections received this week
		SUM(
			case
				when (StatusDate >= @lastMonday and Status in ('Closed','Rejected')) then 1 
				else 0
			end) as rejectsThisWeek,
		-- Compute the count of rejections received this month
		SUM(
			case
				when (StatusDate >= @firstOfTheMonth and Status in ('Closed','Rejected')) then 1 
				else 0
			end) as rejectsThisMonth,
		-- Compute the count of rejections received this year
		SUM(
			case
				when (StatusDate >= @firstOfTheYear and Status in ('Closed','Rejected')) then 1 
				else 0
			end) as rejectsThisYear

	From Position;
end;

GO


