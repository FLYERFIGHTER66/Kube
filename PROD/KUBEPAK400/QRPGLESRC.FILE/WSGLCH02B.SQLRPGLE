**free

// GL Cash Deposit History Build (Current Year)

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
  FROM  FGLCTL
  WHERE GZCOMP = 1;

exec sql // Clear out current records for this GL year
  delete from GL_Cash_Deposit_History_File where GL_YEAR = :GLYear;

exec sql // Insert Starting GL Balances UNION GL Details Summary
  insert into GL_Cash_Deposit_History_File (
    select distinct
    :GLYear                         as GL_Year,
    WEEK_NUMBER                     as GL_Week,
    DOTW                            as GL_WeekDay,
    DATEFLD                         as Transaction_Date,
    gtacct                          as GL_Number,
    'Deposit'                       as Description,
    sum(gtdol$)                     as Transaction_Amount,
    current timestamp               as created_ts

    from fgldet
    join fcalen_all on gttdat = mdy6

    where GTACCT = 10500000
      And ((GTSRCE = 'A/R') or (GTSRCE = 'J/E' and GTJESF = 'ZZ'))

    GROUP BY
    :GLYear,
    WEEK_NUMBER,
    DOTW,
    DATEFLD,
    gtacct,
    DATEFLDTEXT || 'Deposit'

    Order By
    GL_Year,
    GL_Number,
    Transaction_Date
  );

*InLR = *On;
Return;
