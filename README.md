# T_SQL
Converting Persian to Gregorian date and make a calendar as a table using Stored procedures/
NOTICE:These stored procedures must be created in order/
To use them: Exec proc sp_calendarmaker3 'Year-Month-Day'/
Notice that the date which you'll enter must be the first day of the first month of any year in addition to make a whole year calendar./
EG. '1404-01-01' or '1405-01-01' or '1406-01-01'/
Input format must be varchar(10)/
created table has two columns: Shamsi varchar(10) and Miladi date
