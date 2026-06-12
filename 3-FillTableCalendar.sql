/****** Object:  StoredProcedure [dbo].[sp_calendarmaker3]    Script Date: 6/12/2026 2:28:32 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_calendarmaker3] @ShamsiFirstDate varchar(10)
/*
	this stored procedure uses SP_ShamsiToMiladi2 as exchanging stored procedure
*/
as
begin

	declare	@year varchar (4)											--for using the year i have extracted the year
	declare @month int = cast(substring(@ShamsiFirstDate,6,2) as int)	--for using the month i have extracted the month seperately as an integer
	declare @day int = cast(substring(@ShamsiFirstDate,9,2) as int)		--for using the day i have extracted the day seperately as an intiger
	declare @result date
begin try
declare @complete	varchar(10) --this variable is just for breaking the try and catch and bring up catch commands (error)
		IF	(cast(substring(@ShamsiFirstDate,1,4) as int) < 1 ) --check year if is < 1
		or	((cast(substring(@ShamsiFirstDate,6,2) as int) < 1) or (cast(substring(@ShamsiFirstDate,6,2) as int) > 12)) --check month
		or	((cast(substring(@ShamsiFirstDate,9,2) as int) < 1) --check day if is < 1
			or	((cast(substring(@ShamsiFirstDate,6,2) as int) between 1 and 6) and (cast(substring(@ShamsiFirstDate,9,2) as int) > 31)) --or month is between 1 and 6 and date more than 31 
			or	((cast(substring(@ShamsiFirstDate,6,2) as int) between 7 and 11) and (cast(substring(@ShamsiFirstDate,9,2) as int) > 30))) --or month is between 1 and 6 and date more than 30
		begin
			set @complete = 5/0 --for breaking the loop and returning Catch section
		end
		IF (cast(substring(@ShamsiFirstDate,6,2) as int) = 12) -- if month = 12 and *LEAP YEAR* and day > 30, because there is no such date in a leap year (31,32...)
			and (((cast(substring(@ShamsiFirstDate,1,4) as int) between 1343 and 1472) and (cast(substring(@ShamsiFirstDate,1,4) as int)%33 in (1,5,9,13,17,22,26,30)))	
				or (((cast(substring(@ShamsiFirstDate,1,4) as int) between 1244 and 1342) and (cast(substring(@ShamsiFirstDate,1,4) as int)%33 in (1,5,9,13,17,21,26,30)))))	
			and (cast(substring(@ShamsiFirstDate,9,2) as int) > 30)
		begin
			set @complete = 5/0 --for breaking the loop and returning Catch section
		end
		IF (cast(substring(@ShamsiFirstDate,6,2) as int) = 12) -- if month = 12 and *NOT LEAP YEAR* and day > 29, because there is no such date in not leap year (30,31,32...)
			and (((cast(substring(@ShamsiFirstDate,1,4) as int) between 1343 and 1472) and (cast(substring(@ShamsiFirstDate,1,4) as int)%33 not in (1,5,9,13,17,22,26,30)))
				or (((cast(substring(@ShamsiFirstDate,1,4) as int) between 1244 and 1342) and (cast(substring(@ShamsiFirstDate,1,4) as int)%33 not in (1,5,9,13,17,21,26,30)))))
			and (cast(substring(@ShamsiFirstDate,9,2) as int) > 29)
		begin
			set @complete = 5/0 --for breaking the loop and returning Catch section
		end

		/*********************************************************************************
		from no on the program will start to fill the table Calendars
		*************************************************************************************/
	declare @shamsi varchar(10)
	while @month between 1 and 6 --create dates between month 1 and 6, in these months there are 31 days
		begin
			while @day <= 31 --as long as day is >= 3
			begin
				set @Shamsi = SUBSTRING(@ShamsiFirstDate,1,4) --make the format of year+month+day as an actual date,, this line is for adding year
					+'-'+IIF(@month between 0 and 9,'0' + cast(@month as varchar(2)),cast(@month as varchar(2))) --this line is for adding month
					+'-'+IIF(@day between 0 and 9,'0' + cast(@day as varchar(2)),cast(@day as varchar(2))) --this line is for adding day
				declare @miladi date --for filling with the miladi date 
				exec SP_ShamsiToMiladi2 @Shamsi, @miladi output
				if not exists (select Miladi from Calendars where Miladi = @miladi) --checks if the date is not in the table
				begin
					insert into Calendars(Shamsi,Miladi) --insert dates into calendar
					values(@Shamsi,@miladi)
				end
				else 
				begin
					print cast(@miladi as varchar(10)) + ' exists in the table' --if the date is in the calendar this line will be brought up
				end
				set @day = @day + 1 --after inserting increase the @day up to 31
			end
			set @day = 1 --after reaching 31 again it resets the @day to 1
			set @month = @month + 1 --it will increase @month value up to 6 and the last time it will be 7 and will be ready for the next part
		end
	while @month between 7 and 11 --while months have 30 days and between 7 to 11
		begin
			while @day <=30 --as long as days are less than 30
			begin
				set @Shamsi = SUBSTRING(@ShamsiFirstDate,1,4) --concatenate the @year + @month + @day
					+'-'+IIF(@month between 0 and 9,'0' + cast(@month as varchar(2)),cast(@month as varchar(2)))
					+'-'+IIF(@day between 0 and 9,'0' + cast(@day as varchar(2)),cast(@day as varchar(2)))
				exec SP_ShamsiToMiladi2 @Shamsi, @miladi output --takes @shamsi and returns @miladi form of the date
				if not exists (select Miladi from Calendars where Miladi = @miladi) --check if not exist in the table
				begin
					insert into Calendars(Shamsi,Miladi)--insert dates into calendar
					values(@Shamsi,@miladi)
				end
				else 
				begin
					print cast(@miladi as varchar(10)) + ' exists in the table' --error text of already existed date in the Calendar table
				end
				set @day = @day + 1 --increase the @day up to 30
			end
			set @day = 1 --reset the @day to 1
			set @month = @month + 1 --increase the @month up to 11 and the last time it will be 12 being ready for the next part
		end
	IF(((((cast(substring(@ShamsiFirstDate,1,4) as int) between 1343 and 1472) and (cast(substring(@ShamsiFirstDate,1,4) as int)%33 in (1,5,9,13,17,22,26,30))) --leap year	check
				or (((cast(substring(@ShamsiFirstDate,1,4) as int) between 1244 and 1342) and (cast(substring(@ShamsiFirstDate,1,4) as int)%33 in (1,5,9,13,17,21,26,30)))))))
	begin
		--while @month = 12
		--begin
			while @day <= 30 --in the leap year we have 30 days at last month and here will ad 30 days
			begin
				set @Shamsi = SUBSTRING(@ShamsiFirstDate,1,4)
					+'-'+IIF(@month between 0 and 9,'0' + cast(@month as varchar(2)),cast(@month as varchar(2)))
					+'-'+IIF(@day between 0 and 9,'0' + cast(@day as varchar(2)),cast(@day as varchar(2)))
				exec SP_ShamsiToMiladi2 @Shamsi, @miladi output
				if not exists (select Miladi from Calendars where Miladi = @miladi)
				begin
					insert into Calendars(Shamsi,Miladi) --insert into calendar
					values(@Shamsi,@miladi)
				end
				else 
				begin
					print cast(@miladi as varchar(10)) + ' exists in the table' --error format of existed day
				end
				set @day = @day + 1
			end
			--set @month = @month + 1
		--end
	end
	IF(((((cast(substring(@ShamsiFirstDate,1,4) as int) between 1343 and 1472) and (cast(substring(@ShamsiFirstDate,1,4) as int)%33 not in (1,5,9,13,17,22,26,30))) --not leap year
				or (((cast(substring(@ShamsiFirstDate,1,4) as int) between 1244 and 1342) and (cast(substring(@ShamsiFirstDate,1,4) as int)%33 not in (1,5,9,13,17,21,26,30)))))) )
	begin
		--while @month = 12
		--begin
			while @day <= 29 
				begin
					set @Shamsi = SUBSTRING(@ShamsiFirstDate,1,4)
						+'-'+IIF(@month between 0 and 9,'0' + cast(@month as varchar(2)),cast(@month as varchar(2)))
						+'-'+IIF(@day between 0 and 9,'0' + cast(@day as varchar(2)),cast(@day as varchar(2)))
					exec SP_ShamsiToMiladi2 @Shamsi, @miladi output
					if not exists (select Miladi from Calendars where Miladi = @miladi)
					begin
						insert into Calendars(Shamsi,Miladi)
						values(@Shamsi,@miladi)
					end
					else 
					begin
						print cast(@miladi as varchar(10)) + ' exists in the table'
					end
					set @day = @day + 1
				end
		--	set @month = @month + 1
		--end
	end
	
	end try
	begin catch
		print 'wrong date format input'--error format for wrong input @shamsifirstdate
	end catch
end
GO


