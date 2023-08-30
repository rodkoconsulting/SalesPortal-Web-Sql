/****** Object:  Procedure [dbo].[alter_table_for_first_result_set_from_object]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROC [dbo].[alter_table_for_first_result_set_from_object]
(
    @object_name SYSNAME,
    @table_name SYSNAME
)
AS
BEGIN
    /********************************************************************************
    Created:    2016-02-25
    Purpose:   Per a stored procedure's metadata this procedure will add columns 
                to a table that resembles the resultset delivered by that stored 
                procedure. This procedure is meant to be used as a precursor to using 
                INSERT...EXEC to capture the results of said stored procedure into 
                said table.
    Author:     Orlando Colamatteo
    Example:

        -- This example adds columns to an existing temporary table named #result that 
        -- enables it to capture the results of a stored procedure using a statement 
        -- like this: INSERT INTO #result EXEC dbo.some_stored_procedure;
        EXEC dbo.alter_table_for_first_result_set_from_object
            @object_name = N'dbo.some_stored_procedure',
            @table_name = N'#result';
    
    Modification History:
    Date        Author          Purpose
    ----------- --------------- ----------------------------------------------------

    ********************************************************************************/
    SET NOCOUNT ON;

    -- variable used to store list of columns output by stored procedure
    DECLARE @column_list NVARCHAR(MAX);

    -- get list of columns included in stored procedure resultset from DMV as a single string
    SELECT @column_list = STUFF((SELECT N', ' + QUOTENAME(name) + N' ' + system_type_name + N' NULL'
                                 FROM sys.dm_exec_describe_first_result_set_for_object(OBJECT_ID(@object_name), 0) AS p2
                                 ORDER BY p2.column_ordinal
                                 FOR XML PATH(N''), TYPE).value(N'.[1]', N'NVARCHAR(MAX)'), 1, 2, N'');

    -- return a descriptive error message when the resultset metadata cannot be retrieved
    IF @column_list IS NULL
        THROW 50000, 'Stored procedure resultset metadata could not be retrieved', 1;

    -- add the columns to the requested table
    EXEC (N'ALTER TABLE ' + @table_name + ' ADD ' + @column_list);
END
