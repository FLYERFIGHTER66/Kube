**Free
  //  :````````````````````````````````````````````````````````````:
  //  :      Get Freight Zone for a zip                            :
  //  :............................................................:
  //  :````````````````````````````````````````````````````````````:
  //  : Created:  Mar. 2018              Kube-Pak Corporation      :
  //  :      by:  William J. Behr                                  :
  //  :                                                            :
  //  : Description:                                               :
  //  : This program will return the freight zone for the given    :
  //  : zip code.  It uses the ZMMILE feild from the FMZIPS file   :
  //  : if a record exists for the customer.  If the Zip Code      :
  //  : record is missing or has a value of *zero for the miles,   :
  //  : the Zip Code record is added or updated appropriately.     :
  //  : The miles are then used in a SQL lookup in the FUZONE file :
  //  : to determine the appropriate freight zone.                 :
  //  :                                                            :
  //  :                                                            :
  //  :                                                            :
  //  :............................................................:

  CTL-OPT
    NoMain
    DatFmt(*usa);

  /include QFunctFree,$ZIPFRTZON

  dcl-pr ZipMiles packed(6:1);
    zipCode char(5);
  END-PR;

  dcl-pr FreightZone char(1);
    distanceInMiles packed(6:1);
  END-PR;


  DCL-PROC $ZIPFRTZON export;
    DCL-PI *n char(1);
      DCL-PARM toZip char(5) Const;   // Specify destination Zip
    END-PI;

    dcl-s thisZip char(5) Inz(*Blanks);
    dcl-s miles packed(6:1) Inz(*Zero);
    dcl-s thisZone char(1) Inz(*Blanks);

    thisZip = toZip;
    miles = ZipMiles(thisZip);
    thisZone = FreightZone(miles);

    *InLR = *On;
    Return thisZone;
  End-PROC;

      //_________________________________________________________________________
     //
    //  S U B   P R O C E D U R E S
   //_________________________________________________________________________

    dcl-proc ZipMiles;
      dcl-pi *n packed(6:1);
        zipCode char(5);
      END-PI;
      dcl-s milesToZip packed(6:1) Inz(*Zero);

      Exec SQL // Check out zip code file to get miles
        Select   ZMMILE
        Into    :milesToZip
        From     FMZIPS
        Where    ZMZIP = :zipCode
        Fetch First Row Only;

      If milesToZip = 0;
        // CALLP GGL_MILES(ToZip:milesToZip);
        //updatezip(ToZip);
      ENDIF;

      Return milesToZip;

    END-PROC;

    dcl-proc FreightZone;
      dcl-pi *n char(1);
        distanceInMiles packed(6:1);
      END-PI;
      dcl-s FreightZone char(1) Inz(' ');

      Exec SQL  // get cooresponding freight zone
        select  FZONE
        into   :FreightZone
        from    FUZONE
        where   FUTYPE = 'M'
          and   FUCONO = 1
          and   int(:distanceInMiles) between FUFMMI and FUTOMI
        order   by FZONE
        Fetch First Row Only;

      Return FreightZone;

    END-PROC;

