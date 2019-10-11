DROP VIEW FMORLS_Join_FMORLSFLAG;

CREATE VIEW FMORLS_Join_FMORLSFLAG
    FOR SYSTEM NAME FMORLSJ1 as (
 SELECT * from  FMORLS      left outer join
                FMORLSFLAG on   OLLIST = FLLIST
                            and OLITEM = FLITEM
                            and OLSIZE = FLSIZE
 WHERE FLAG_HIDE_ITEM is null
    or FLAG_HIDE_ITEM = 'N'
    or FLAG_HIDE_ITEM = '0');

-- Add text to the Object so we know the view name
LABEL ON VIEW FMORLS_Join_FMORLSFLAG IS 'FMORLS_Join_FMORLSFLAG';
