drop function InnovaStrt;
-- Create SQL Function
CREATE OR REPLACE FUNCTION InnovaStrt ()

    RETURNS date
    LANGUAGE SQL

    BEGIN
        RETURN
            case
                when DAYOFWEEK (current date) = 3 then READY_BAY_WEEK + 7 days
                when DAYOFWEEK (current date) <> 3 then READY_BAY_WEEK
            end;
    END;
