echo off
echo Export tables and data from TTVG into a script file
echo 0 - All Tables
echo 1 - Static Tables Only
echo 2 - Dynamic Tables Only

set choice=
set /P choice=Select to export the tables [0/1/2] : 

IF '%choice%'=='0' goto ALL
IF '%choice%'=='1' goto STATIC
IF '%choice%'=='2' goto DYNAMIC

goto END

:ALL
"E:\Java\mysql-5.6.14-win32\bin\mysqldump" -uroot -pDenis!234 TTVG>Export\discount_tables.sql
goto END

:STATIC
"E:\Java\mysql-5.6.14-win32\bin\mysqldump" -uroot -pDenis!234 --ignore-table=TTVG.item --ignore-table=TTVG.item_property --ignore-table=TTVG.item_property_value --ignore-table=TTVG.item_property_feature_link TTVG>Export\ddb_tables.sql
goto END

:DYNAMIC
"E:\Java\mysql-5.6.14-win32\bin\mysqldump" -uroot -pDenis!234 TTVG item item_property item_property_value item_property_feature_link>Export\db_tables.sql
goto END

:END
echo Data Exported

Pause
