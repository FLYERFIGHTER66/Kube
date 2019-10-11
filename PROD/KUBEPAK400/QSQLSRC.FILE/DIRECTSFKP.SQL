drop function DIRECTSFKP;  -- Directions from Kube-Pak
-- Create SQL Function
CREATE OR REPLACE FUNCTION DIRECTSFKP (inDest char(256))

    RETURNS TABLE
    (
    directions char(256)
    )
    LANGUAGE SQL
    Not Deterministic

    BEGIN

      DECLARE GOOGLE_URL varchar(600);
      Set GOOGLE_URL =  'https://maps.googleapis.com/maps/api/directions/xml?' ||
                        '&origin=Kube-Pak+194+County+Rd+526,+Allentown,+NJ+08501'||
                        '&destination='|| trim(inDest) ||
                        '&key=AIzaSyDZiahnNevsqaXr_2X4P5oWO1DYsnj-xMA';
RETURN
        SELECT route_leg_html_instructions
        FROM XMLTABLE('$doc/DirectionsResponse/route/leg/step'
        PASSING XMLPARSE(DOCUMENT SYSTOOLS.HTTPGETCLOB( GOOGLE_URL ,'')
        ) AS "doc"
          COLUMNS
            route_leg_html_instructions     VARCHAR(256) PATH 'html_instructions'
        ) AS DirectionsResponse;

    END;

