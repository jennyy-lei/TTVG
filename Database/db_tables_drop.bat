@echo off
echo Remove all tables from ....... db_tables_drop.sql
echo .......

set choice=
set /P choice=Sure to Remove all Tables from Database [Y/N] : 

IF '%choice%'=='Y' goto REMOVE
IF '%choice%'=='y' goto REMOVE

goto END

:REMOVE

"E:\Java\mysql-5.6.14-win32\bin\mysql" -uroot -pDenis!234< Script\db_tables_drop.sql

echo All Tables Dropped ..............

:END

Pause
