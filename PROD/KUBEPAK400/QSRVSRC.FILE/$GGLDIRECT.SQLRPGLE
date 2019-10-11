**Free
  //  :````````````````````````````````````````````````````````````:
  //  :      Get Distance to a Zip from Google Maps                :
  //  :............................................................:
  //  :````````````````````````````````````````````````````````````:
  //  : Created:  Mar. 2018              Kube-Pak Corporation      :
  //  :      by:  William J. Behr                                  :
  //  :............................................................:

  CTL-OPT
    DftActGrp(*no)
    DatFmt(*usa);

  DCL-PI GGL_DIRECT;
    DCL-PARM ToZip char(5)  Const;      // Specify destination Zip
  END-PI;

     //  W.I.P.
     //  See:  https://developers.google.com/maps/documentation/directions/



  dcl-s thisZip varchar(11);

  dcl-s GoogleServicePath   varchar(256)
                             Inz('http://maps.googleapis.com/maps/api/distancematrix/xml?');
  dcl-s options             varchar(256)
                             Inz('units=imperial');
  dcl-s origins             varchar(256)
                             Inz('&origins=Kube-Pak+194+County+Rd+526,+Allentown,+NJ+08501');
  dcl-s destinations        varchar(256) Inz('&destinations=');
  dcl-s GoogleServiceURL    varchar(1000) Inz('');

  dcl-s elementDistanceText varchar(15) Inz('Inquiry Failed');
  dcl-s miles               char(15);

  dcl-s  startString   char(128);
  dcl-s  blankString   like(startString) inz;
  dcl-s  endString     char(128);


  thisZip = ToZip;
  destinations = %trim(destinations) + %trim(thisZip);
  GoogleServiceURL = %trim(GoogleServicePath)
                   + %trim(options)
                   + %trim(origins)
                   + %trim(destinations);

  Exec SQL
    SELECT elementDistanceText
    INTO :elementDistanceText
    FROM XMLTABLE('$doc/DistanceMatrixResponse'
    PASSING XMLPARSE(DOCUMENT SYSTOOLS.HTTPGETCLOB(:GoogleServiceURL ,'')
    ) AS "doc"
      COLUMNS
        status               VARCHAR(3)   PATH 'status',
        origin_address       VARCHAR(253) PATH 'origin_address',
        destination_address  VARCHAR(256) PATH 'destination_address',
        elementStatus        VARCHAR(3)   PATH 'row/element/status',
        elementDurationValue VARCHAR(15)  PATH 'row/element/duration/value',
        elementDurationText  VARCHAR(15)  PATH 'row/element/duration/text',
        elementDistanceValue VARCHAR(15)  PATH 'row/element/distance/value',
        elementDistanceText  VARCHAR(15)  PATH 'row/element/distance/text'
    ) AS WebServiceResult;

  dsply ('Google distance to zip:'
        + %trim(thisZip)
        + '='
        + %trim(elementDistanceText));

  startString = elementDistanceText;

  endString = %scanrpl(' '
                      : ''
                      : %xlate( %xlate( '0123456789.'
                                      : '           '
                                      : startString
                                      )
                              : blankString
                              : startString
                              )
                      );

  dsply miles;

  *InLR = *On;
  Return;
