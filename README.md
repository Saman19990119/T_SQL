# T_SQL
Converting Jalali to Gregorian date and make a calendar as a table using Stored procedures/
NOTICE:These stored procedures must be created in order/
To use them:
  1.Exec proc SP_CreateTable (just for the first time)/
  2.Exec proc sp_calendarmaker3 'Year-Month-Day'/
(Notice that the date which you'll enter must be the first day of the first month of any year in addition to make a whole year calendar./
EG. '1404-01-01' or '1405-01-01' or '1406-01-01'/
Input format must be varchar(10)/
created table has two columns: Shamsi varchar(10) and Miladi date)/
Finally your calendar has been created and stored in tables as 'calendars'/
for more usages, it is not nececarry to exec proc SP_createtable, you've just got to (EXEC PROC SP_Calendarmaker 'year-month-day') and your calendar will be added to 'Calendars' table.
