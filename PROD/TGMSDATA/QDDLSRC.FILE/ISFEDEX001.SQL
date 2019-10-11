
  -- isFedExSVIA(SVIA)
  CREATE OR REPLACE FUNCTION isFedExSVIA (ThisSVIA Char(2) )

    RETURNS CHAR(1)
    LANGUAGE SQL

    BEGIN
      DECLARE isFedEx char(1)  DEFAULT '0';

      Select    '1'
      into      isFedEx
      from      XATABE1
      where     TBTB = 'FX'
        and     TBC6 = ThisSVIA
      Fetch First Row Only;

      Return isFedEx;

    END ;
