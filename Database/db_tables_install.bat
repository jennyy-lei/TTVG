@echo off
echo Install tables from ....... db_tables.sql

"E:\Java\mysql-5.6.14-win32\bin\mysql" -uroot -pDenis!234 TTVG<Script\db_tables.sql

echo Tables Installed ..............

"E:\Java\mysql-5.6.14-win32\bin\mysql" -uroot -pDenis!234 TTVG<Script\db_data.sql

echo Initialization Data Imported ........
echo .......

set choice=
set /P choice=Want to import the testing data [Y/N] : 

IF '%choice%'=='Y' goto TESTING
IF '%choice%'=='y' goto TESTING

goto END

:TESTING

"E:\Java\mysql-5.6.14-win32\bin\mysql" -uroot -pDenis!234 TTVG<Script\db_data_test.sql

echo Testing Data Imported ........

:END

Pause
