**free

ctl-opt DftActGrp(*no)
        DatFmt(*usa)
        BndDir('HTTPAPI': 'QC2LE')  ;

dcl-s GLYEAR zoned(4:0);

exec sql // Set SQL Options
   SET OPTION COMMIT      = *NONE,
              CLOSQLCSR   = *ENDMOD,
              DATFMT      = *ISO ;

exec sql // Get GL Year from GL Control File
  SELECT int('20'||right(GZPREY,2))
  INTO :GLYEAR
  FROM tgmsdata.fglctl
  WHERE GZCOMP = 1;

exec sql // Clear out current records for this GL year
  delete from GL_Cash_Position_History_File where GL_YEAR = :GLYear;

exec sql // Insert Starting GL Balances UNION GL Details Summary
  insert into GL_Cash_Position_History_File (
    select
    :GLYear                         as GL_Year,
    01                              as GL_Week,
    01                              as GL_WeekDay,
    (Select min(mn.DATEFLD) from fcalen_all as mn where year4 = :GLYear)
                                    as Transaction_Date,
    GLGLNO                          as GL_Number,
    'StartingBalance'               as Description,
    GLBALT                          as Transaction_Amount,
    current timestamp               as created_ts

    from FGLBAL

    where glglno in (10500000,10700000,24000000,15000000,20000000)

    UNION

    select distinct
    :GLYear                         as GL_Year,
    WEEK_NUMBER                     as GL_Week,
    DOTW                            as GL_WeekDay,
    DATEFLD                         as Transaction_Date,
    gtacct                          as GL_Number,
    'Transaction'                   as Description,
    sum(gtdol$)                     as Transaction_Amount,
    current timestamp               as created_ts

    from fgldet
    join fcalen_all on gttdat = mdy6

    where gtacct in (10500000,10700000,24000000,15000000,20000000)

    group by
    :GLYear,
    WEEK_NUMBER,
    DOTW,
    DATEFLD,
    gtacct,
    DATEFLDTEXT || 'Transaction'

    Order By
    GL_Year,
    GL_Number,
    Transaction_Date
  );

*InLR = *On;
Return;
