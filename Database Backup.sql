USE DiskShop;

GO
DECLARE @fileName VARCHAR(100), @dataBaseName VARCHAR(100), @fileDate VARCHAR(20);

SET @fileName = 'D:\Programming Projects\Databases\MS SQL Server Exam\Backups\';
SET @dataBaseName = 'DiskShop';
SET @fileDate = CONVERT(VARCHAR(20), GETDATE(), 112);

SET @fileName = @fileName + @dataBaseName + '-' + @fileDate + '.bak';

BACKUP DATABASE @dataBaseName TO DISK = @fileName;

