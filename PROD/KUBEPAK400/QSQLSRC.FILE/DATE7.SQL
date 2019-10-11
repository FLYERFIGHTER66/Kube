drop function DATE7;
-- Create SQL Function
CREATE OR REPLACE FUNCTION DATE7 (inDate date)

    RETURNS numeric(7, 0)
    LANGUAGE SQL

    BEGIN
        DECLARE outDate7 int;
        Select  CYMD7
        into    outDate7
        from    fcalen_all
        WHERE   datefld = inDate
        Fetch First Row Only;

        RETURN outDate7;
    END;
