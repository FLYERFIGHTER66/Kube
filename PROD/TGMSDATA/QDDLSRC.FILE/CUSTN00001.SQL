  CREATE OR REPLACE FUNCTION CustNameAddr (CustNo int)

    RETURNS VARCHAR(256)
    LANGUAGE SQL
    DETERMINISTIC

    BEGIN
      DECLARE NameAddr VARCHAR(256) ;

        Select  trim(CMNAME) ||' - '||
                trim(CMADD2) ||', ' ||
                trim(CMCITY) ||', ' ||
                trim(CMSTST) ||', ' ||
                trim(char(CMZIP))
        into NameAddr
        from FMCUST
        where CMCUST = CustNo

        Fetch First Row Only;

      RETURN NameAddr ;
    END ;


