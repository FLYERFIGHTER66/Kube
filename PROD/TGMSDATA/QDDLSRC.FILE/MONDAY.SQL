
  -- Monday(ThisDate,WeekStartDay)
  CREATE OR REPLACE FUNCTION SowDate (ThisItem Char(12),ThisSize Char(3), ThisReady_Date date )

    RETURNS date
    LANGUAGE SQL
    DETERMINISTIC

    BEGIN
      DECLARE SowDate Date ;

        Select
         case
            when (FMINVT.IMBD1 < FMINVT.IMBD2 and week_iso(ThisReady_Date) between FMINVT.IMBD1 and FMINVT.IMED1)
              or (FMINVT.IMBD1 > FMINVT.IMBD2 and week_iso(ThisReady_Date) between FMINVT.IMBD1 and    53)
              or (FMINVT.IMBD1 > FMINVT.IMBD2 and week_iso(ThisReady_Date) between            1 and FMINVT.IMED1)
                                                                                then ThisReady_Date - (FMINVT.IMWG1*7) days
            when week_iso(ThisReady_Date) between FMINVT.IMBD2 and FMINVT.IMED2 then ThisReady_Date - (FMINVT.IMWG2*7) days
            when week_iso(ThisReady_Date) between FMINVT.IMBD3 and FMINVT.IMED3 then ThisReady_Date - (FMINVT.IMWG3*7) days
            when week_iso(ThisReady_Date) between FMINVT.IMBD4 and FMINVT.IMED4 then ThisReady_Date - (FMINVT.IMWG4*7) days
          end  as source_sowdate
          into SowDate
          from FMINVT where IMITEM = ThisItem and IMSIZE = ThisSize
        Fetch First Row Only;

      RETURN SowDate ;
    END ;
