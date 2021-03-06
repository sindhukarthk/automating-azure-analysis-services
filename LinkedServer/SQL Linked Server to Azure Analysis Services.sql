USE [master]
GO

--edit this...
EXEC master.dbo.sp_addlinkedserver @server = N'AZUREAS', @srvproduct=N'', @provider=N'MSOLAP', @datasrc=N'asazure://<region>.asazure.windows.net/<server>', @catalog=N'<database>'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'collation compatible', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'data access', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'dist', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'pub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'rpc', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'rpc out', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'sub', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'connect timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'collation name', @optvalue=null
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'lazy schema validation', @optvalue=N'false'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'query timeout', @optvalue=N'0'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'use remote collation', @optvalue=N'true'
GO
EXEC master.dbo.sp_serveroption @server=N'AZUREAS', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO
USE [master]
GO

--edit this... this needs to be a username/password which does not have multi-factor auth enabled
--currently SQL2017 doesn't appear to support @rmtuser='app:<clientid>', @rmtpassword='<secret>'
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname = N'AZUREAS', @locallogin = NULL , @useself = N'False', @rmtuser = N'user@domain.com', @rmtpassword = N'<password>'
GO


--execute a DAX or MDX or DMV query with the EXEC AT syntax
Exec ('select * from $system.mdschema_measures') At AZUREAS;



--or execute a DAX or MDX or DMV query using openquery
--a repeated single quote ('') is the way to escape a single quote
select * from openquery(AZUREAS, 
'evaluate SUMMARIZECOLUMNS(
 ''Geography''[City],
 "My Measure", [My Measure]
)')

--refresh the model
Exec ('
{
  "refresh": {
    "type": "full",
    "objects": [
      {
        "database": "MyDatabase"
      }
    ]
  }
}
') At AZUREAS;

