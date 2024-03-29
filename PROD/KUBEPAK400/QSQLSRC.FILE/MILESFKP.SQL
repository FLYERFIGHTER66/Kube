drop function MILESFKP;  -- Miles from Kube-Pak
-- Create SQL Function
CREATE OR REPLACE FUNCTION MILESFKP (inDest char(256))

    RETURNS numeric(7, 2)
    LANGUAGE SQL

    BEGIN
--    DECLARE outMeters int; -- Earth is 40.075 million m (40,075,000m)
      DECLARE outMiles numeric(7, 2);  -- Earth is 24,901 mi

      DECLARE GOOGLE_URL varchar(600);

      Set outMiles = -1;
      Set GOOGLE_URL =  'https://maps.googleapis.com/maps/api/distancematrix/xml?' ||
                        'units=imperial'||
                        '&origins=Kube-Pak+194+County+Rd+526,+Allentown,+NJ+08501'||
                        '&destinations='|| trim(replace(inDest,' ','+') ||
                        '&key=insert-your-api-key-here';

SELECT cast(int(trim(elementDistanceValue)) *  0.000621371 as numeric(7,2)) into outMiles
FROM XMLTABLE('$doc/DistanceMatrixResponse'
PASSING XMLPARSE(DOCUMENT SYSTOOLS.HTTPGETCLOB( GOOGLE_URL ,'')
) AS "doc"
  COLUMNS
    status               VARCHAR(30)  PATH 'status',
    origin_address       VARCHAR(253) PATH 'origin_address',
    destination_address  VARCHAR(256) PATH 'destination_address',
    elementStatus        VARCHAR(3)   PATH 'row/element/status',
    elementDurationValue VARCHAR(15)  PATH 'row/element/duration/value',
    elementDurationText  VARCHAR(15)  PATH 'row/element/duration/text',
    elementDistanceValue VARCHAR(15)  PATH 'row/element/distance/value',
    elementDistanceText  VARCHAR(15)  PATH 'row/element/distance/text'
) AS WebServiceResult;


--        Set outMiles = cast(outMeters *  0.000621371 as numeric(7,2));
        RETURN outMiles;
    END;


--TEST
--values milesfkp('Tustin,CA')    ;


