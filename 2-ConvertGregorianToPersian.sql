/****** Object:  StoredProcedure [dbo].[SP_ShamsiToMiladi2]    Script Date: 6/12/2026 2:27:18 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[SP_ShamsiToMiladi2] @Shamsidate varchar(10),@miladidate date output
as
/*
=================================================================
Author: saman
Date: 1404-12-26
Name: SP_ShamsiToMiladi2
Function:	Takes persian date and returns complete Miladi form (concatenated stored procedures 
			WITHOUT usingany nasted stored procedures for changing Shamsi to Miladi)
=================================================================
*/
begin
	--declare @shamsidate varchar(10) = '1384-01-01' --must be deleted just for test
	--declare @miladidate date --must be deleted just for test
	begin try
		declare @complete	varchar(10)
		IF	(cast(substring(@shamsidate,1,4) as int) < 1 )																			--check year
		or	((cast(substring(@shamsidate,6,2) as int) < 1) or (cast(substring(@shamsidate,6,2) as int) > 12))						--check month
		or	((cast(substring(@shamsidate,9,2) as int) < 1)																			--check day
			or	((cast(substring(@shamsidate,6,2) as int) between 1 and 6) and (cast(substring(@shamsidate,9,2) as int) > 31))		--check day
			or	((cast(substring(@shamsidate,6,2) as int) between 7 and 11) and (cast(substring(@shamsidate,9,2) as int) > 30)))	--check day
		begin
			set @complete = 5/0 --for breaking the loop and returning Catch section
		end
		IF (cast(substring(@shamsidate,6,2) as int) = 12) -- if month = 12 and *LEAP YEAR* and day > 30, because there is no such date(31,32...)
			and (((cast(substring(@shamsidate,1,4) as int) between 1343 and 1472) and (cast(substring(@shamsidate,1,4) as int)%33 in (1,5,9,13,17,22,26,30)))	
				or (((cast(substring(@shamsidate,1,4) as int) between 1244 and 1342) and (cast(substring(@shamsidate,1,4) as int)%33 in (1,5,9,13,17,21,26,30)))))	
			and (cast(substring(@shamsidate,9,2) as int) > 30)
		begin
			set @complete = 5/0 --for breaking the loop and returning Catch section
		end
		IF (cast(substring(@shamsidate,6,2) as int) = 12) -- if month = 12 and *NOT LEAP YEAR* and day > 29, because there is no such date(30,31,32...)
			and (((cast(substring(@shamsidate,1,4) as int) between 1343 and 1472) and (cast(substring(@shamsidate,1,4) as int)%33 not in (1,5,9,13,17,22,26,30)))
				or (((cast(substring(@shamsidate,1,4) as int) between 1244 and 1342) and (cast(substring(@shamsidate,1,4) as int)%33 not in (1,5,9,13,17,21,26,30)))))
			and (cast(substring(@shamsidate,9,2) as int) > 29)
		begin
			set @complete = 5/0 --for breaking the loop and returning Catch section
		end

		/**********************************************************************************************************************
			Lately,this program has checked the date which has been entered by user to bring up error if it was in written in wrong format;
			from now on the main section will begin (exchange of Calendars -- Shamsi to miladi )
			All in all, Miladiyear, Miladi month and Miladi day will be concatenated and returned in 'date' format.
		************************************************************************************************************************/

		declare @year		varchar(4)
		declare @month		varchar(2)
		declare @day		varchar(2)
		IF((((cast(substring(@shamsidate,1,4) as int) between 1343 and 1472) and (cast(substring(@shamsidate,1,4) as int)%33 in (1,5,9,13,17,22,26,30))) -- if it is leap year	
				or (((cast(substring(@shamsidate,1,4) as int) between 1244 and 1342) and (cast(substring(@shamsidate,1,4) as int)%33 in (1,5,9,13,17,21,26,30))))))
		begin
			/***********************************************
			start calculating for leap year*/
			declare @Lyearresult varchar(4)
			set @Lyearresult = cast(SUBSTRING(@ShamsiDate,1,4) as int) +
			IIF ((cast(SUBSTRING(@ShamsiDate,6,2) as int) = 10
				AND (cast(SUBSTRING(@ShamsiDate,9,2) as int) > 11)) 
			or (cast(SUBSTRING(@ShamsiDate,6,2) as int) in (11,12)),622,621) 
			set @year = cast(@Lyearresult as varchar(4))

			/*end of calculating leap year

			*************************************************
			start calculating for leap year months*/

			DECLARE @Lmonthresult int										
			if cast(substring(@shamsidate,6,2) as int) = 1
				begin
					set @Lmonthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 12,2,3)
				end
			if cast(substring(@shamsidate,6,2) as int) = 2
				or cast(substring(@shamsidate,6,2) as int) = 3
				begin
					set @Lmonthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 11,2,3)
				end
			if cast(substring(@shamsidate,6,2) as int) = 4
				or cast(substring(@shamsidate,6,2) as int) = 5
				or cast(substring(@shamsidate,6,2) as int) = 6
				or cast(substring(@shamsidate,6,2) as int) = 8
				or cast(substring(@shamsidate,6,2) as int) = 9
				begin
					set @Lmonthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 10,2,3)
				end
			if cast(substring(@shamsidate,6,2) as int) = 7
				begin
					set @Lmonthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 9,2,3)
				end
			if cast(substring(@shamsidate,6,2) as int) = 10
				begin
					set @Lmonthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 11,2,-9)
				end
			if cast(substring(@shamsidate,6,2) as int) = 11
				begin
					set @Lmonthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 12,-10,-9)
				end
			if cast(substring(@shamsidate,6,2) as int) = 12
				begin
					set @Lmonthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 10,-10,-9)
				end
			set @month = IIF(@Lmonthresult in (0,1,2,3,4,5,6,7,8,9),'0' + cast(@Lmonthresult as varchar(2)),cast(@Lmonthresult as varchar(2)))
			
			/*end of calculating leap months

			******************************************************
			start calculating  leap year days*/
			
			declare @Ldayresult int																									
			if cast(substring(@shamsidate,6,2) as int) = 1																			
				or cast(substring(@shamsidate,6,2) as int) = 11
				begin
					set @Ldayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 12,19,-12)
				end
			if cast(substring(@shamsidate,6,2) as int) = 2
				begin
					set @Ldayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 11,19,-11)
				end
			if cast(substring(@shamsidate,6,2) as int) = 3
				or cast(substring(@shamsidate,6,2) as int) = 10
				begin
					set @Ldayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 11,20,-11)
				end
			if cast(substring(@shamsidate,6,2) as int) = 4
				or cast(substring(@shamsidate,6,2) as int) = 9
				begin
					set @Ldayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 10,20,-10)
				end
			if cast(substring(@shamsidate,6,2) as int) = 5
				or cast(substring(@shamsidate,6,2) as int) = 6
				or cast(substring(@shamsidate,6,2) as int) = 8
				begin
					set @Ldayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 10,21,-10)
				end
			if cast(substring(@shamsidate,6,2) as int) = 7
				begin
					set @Ldayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 9,21,-9)
				end
			if cast(substring(@shamsidate,6,2) as int) = 12
				begin
					set @Ldayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 10,18,-10)
				end
			set @day = IIF(@Ldayresult in (0,1,2,3,4,5,6,7,8,9),'0' + cast(@Ldayresult as varchar(2)),cast(@Ldayresult as varchar(2)))			
			
			/*end of calculating lep year days
			*******************************************************/

			set @complete = cast(@year+'-'+@month+'-'+@day as date) --concatenate calculated year, month and day as date format
			set @miladidate = @complete    /******at the end @miladidate is the OUTPUT of the executed procedure if the inputed year was leap *****/
		end

		ELSE --not leap year
				
		begin

			/***********************************************************
			start calculting normal years*/

			declare @yearresult varchar(4)
			set @yearresult = cast(SUBSTRING(@ShamsiDate,1,4) as int) +
			IIF ((cast(SUBSTRING(@ShamsiDate,6,2) as int) = 10
				AND (cast(SUBSTRING(@ShamsiDate,9,2) as int) > 10))
			or (cast(SUBSTRING(@ShamsiDate,6,2) as int) in (11,12)),622,621)
			set @year = cast(@yearresult as varchar(4))	
			
			/*end of calculating normal years

			*************************************************************
			start calculating normal months*/

			DECLARE @monthresult int
			if cast(substring(@shamsidate,6,2) as int) = 1
				begin
					set @monthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 11,2,3)
				end
			if cast(substring(@shamsidate,6,2) as int) = 2
				or cast(substring(@shamsidate,6,2) as int) = 3
				begin
					set @monthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 10,2,3)
				end
			if cast(substring(@shamsidate,6,2) as int) = 4
				or cast(substring(@shamsidate,6,2) as int) = 5
				or cast(substring(@shamsidate,6,2) as int) = 6
				or cast(substring(@shamsidate,6,2) as int) = 8
				or cast(substring(@shamsidate,6,2) as int) = 9
				begin
					set @monthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 9,2,3)
				end
			if cast(substring(@shamsidate,6,2) as int) = 7
				begin
					set @monthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 8,2,3)
				end
			if cast(substring(@shamsidate,6,2) as int) = 10
				begin
					set @monthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 10,2,-9)
				end
			if cast(substring(@shamsidate,6,2) as int) = 11
				begin
					set @monthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 11,-10,-9)
				end
			if cast(substring(@shamsidate,6,2) as int) = 12
				begin
					set @monthresult = cast(substring(@shamsidate,6,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 9,-10,-9)
				end
			set @month = IIF(@monthresult in (0,1,2,3,4,5,6,7,8,9),'0' + cast(@monthresult as varchar(2)),cast(@monthresult as varchar(2)))			
		
			/*end of calculating normal months

			*************************************************************
			start calculating normal days*/
			
			declare @dayresult int
			if cast(substring(@shamsidate,6,2) as int) = 1
				or cast(substring(@shamsidate,6,2) as int) = 11
				begin
					set @dayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 11,20,-11)
				end
			if cast(substring(@shamsidate,6,2) as int) = 2
				begin
					set @dayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 10,20,-10)
				end
			if cast(substring(@shamsidate,6,2) as int) = 3
				or cast(substring(@shamsidate,6,2) as int) = 10
				begin
					set @dayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 10,21,-10)
				end
			if cast(substring(@shamsidate,6,2) as int) = 4
				or cast(substring(@shamsidate,6,2) as int) = 9
				begin
					set @dayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 9,21,-9)
				end
			if cast(substring(@shamsidate,6,2) as int) = 5 
				or cast(substring(@shamsidate,6,2) as int) = 6 
				or cast(substring(@shamsidate,6,2) as int) = 8
				begin
					set @dayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 9,22,-9)
				end
			if cast(substring(@shamsidate,6,2) as int) = 7
				begin
					set @dayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 8,22,-8)
				end
			if cast(substring(@shamsidate,6,2) as int) = 12
				begin
					set @dayresult = cast(substring(@shamsidate,9,2) as int) + IIf(cast(substring(@shamsidate,9,2) as int) between 1 and 9,19,-9)
				end
			set @day = IIF(@dayresult in (0,1,2,3,4,5,6,7,8,9),'0' + cast(@dayresult as varchar(2)),cast(@dayresult as varchar(2)))			

			/*end of calculating normal days
			*************************************************************/

			set @complete = cast(@year+'-'+@month+'-'+@day as date) --concatenate year,month and day as date format 
			set @miladidate = @complete	/******at the end @miladidate is the OUTPUT of the executed procedure if the inputed year was not leap *****/
		end
	end try
	begin catch
		print 'Wrong Input Date Format'
	end catch
end
GO


