      *   This registers the IFSDIR UDTF with the database.
      *   You only need to call this once, to install IFSDIR for
      *   the first time.
      *                                    Scott Klement, May 23, 2007
      *
      *   To compile:
      *      CRTSQLRPGI CRTIFSDIR SRCFILE(xxx/QRPGLESRC)
      *
      *   To call:
      *      CALL CRTIFSDIR PARM(my-lib)
      *      -  replace 'my-lib' with the name of the library where
      *         you placed the IFSDIR service program.
      *
      *
     D CrtIfsDir       PR                  ExtPgm('CRTIFSDIR')
     D   Lib                         10a   const
     D CrtIfsDir       PI
     D   Lib                         10a   const

     D ExtFunc         s             34A   varying
     D Stmt            s           5000A   varying
     D Msg             s             52a

     C/EXEC SQL
     C+   set option NAMING=*SYS,COMMIT=*NONE
     C/END-EXEC

     C                   if        %parms < 1
     C                   eval      msg='Usage: CALL CRTIFSDIR PARM(my-lib)'
     C                   dsply                   msg
     c                   return
     c                   endif

     C                   eval      ExtFunc = %trim(Lib)+'/IFSDIR(IFSDIR)'

     C*========================================================
     C* Delete the existing IFSDIR function (ignore any
     C* "not found" message.
     C*========================================================

     C/EXEC SQL
     C+                  drop function ifsdir
     C/END-EXEC

     C                   if        %subst(sqlstate:1:2) > '02'
     c                             and sqlstate <> '42704'
     C                   eval      msg = 'drop failed w/SQLState '
     C                                 + sqlstate
     C     msg           dsply
     C                   endif

     C*========================================================
     C*   Create the new UDTF function
     C*========================================================
      /free

                 stmt = 'CREATE FUNCTION IFSDIR(dirname VARCHAR(500)) +
                               RETURNS TABLE +
                               ( +
                                 filename    varchar(640), +
                                 size        decimal(20,0), +
                                 type        varchar(10), +
                                 access_time timestamp, +
                                 modify_time timestamp, +
                                 change_time timestamp, +
                                 ccsid       decimal(5,0), +
                                 owner       char(10), +
                                 group       char(10) +
                               ) +
                         EXTERNAL NAME ''' + ExtFunc + ''' +
                         LANGUAGE RPGLE +
                         PARAMETER STYLE DB2SQL +
                         NO SQL +
                         NOT DETERMINISTIC +
                         NO EXTERNAL ACTION +
                         NOT FENCED +
                         NO SCRATCHPAD +
                         NO FINAL CALL +
                         DISALLOW PARALLEL +
                         CARDINALITY 1';
      /end-free

     C/EXEC SQL
     C+                  execute immediate :stmt
     C/END-EXEC

     C                   if        %subst(sqlstate:1:2) > '02'
     c                   eval      msg = 'create function SQLState '
     C                             + sqlstate
     C                   dsply                   msg
     C                   endif

     C                   eval      *inlr = *on

