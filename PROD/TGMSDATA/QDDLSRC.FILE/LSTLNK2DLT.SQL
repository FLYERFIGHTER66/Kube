
  -- FilesToDelete(DIR_2_USE)

  CREATE OR REPLACE FUNCTION FilesToDelete (DIR_2_USE Char(256) )

    RETURNS TABLE
        (
        FilesToBeDeleted char(256)
        )

    LANGUAGE SQL
    Not Deterministic

    BEGIN
      Return
        SELECT distinct trim(DIRECTORY)||'/'||trim(FILENAME) as DELETE_FILES FROM TABLE(QGPL.IFSDIR(DIR_2_USE)) t
        join webservices_retention_policy on directory = DIR_2_USE and file_type = TYPE
        where   (file_beg_with = ' ' or FILENAME like trim(file_beg_with)||'%' or file_beg_with = '*ANY' )
            and (file_end_with = ' ' or FILENAME like '%'||trim(file_end_with) )
            and (file_contains = ' ' or FILENAME like '%'||trim(file_contains)||'%' )
            and MODIFY_TIME < current timestamp - retention_days days;

    END ;
