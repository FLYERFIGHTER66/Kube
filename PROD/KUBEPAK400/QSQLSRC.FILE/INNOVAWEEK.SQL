drop function InnovaWeek;
-- Create SQL Function
CREATE OR REPLACE FUNCTION InnovaWeek (ISO_Week int)

    RETURNS int
    LANGUAGE SQL

    BEGIN
        DECLARE Inova_Week int;
        Select
            CASE
            WHEN CLWEEK <40 THEN
                INT('20'||RIGHT(TRIM(CHAR(CLYEAR)),2)||
                RIGHT(TRIM('0'||CHAR(CLWEEK)),2))
            WHEN CLWEEK >= 40 THEN
                INT('20'||RIGHT(TRIM(CHAR(CLYEAR)),2)||
                RIGHT(TRIM('0'||CHAR(CLWEEK)),2)) + 100
            END AS INOVA_WEEK_6
        into Inova_Week
        from fcalen
        WHERE  CL#Y = 1 and ISO_Week = 200000 + (CLYEAR * 100) + CLWEEK

       Fetch First Row Only;

        RETURN Inova_Week;
    END;

