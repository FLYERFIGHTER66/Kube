     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??:  Return an Address String for Specified Customer           :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2014                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      //  Main procedure prototype & interface
     D CUSTADRSTR      PR                  ExtPgm('CUSTADRSTR')
     D  #Cust                         6A
     D  #AdrStr                     180A
     D CUSTADRSTR      PI
     D  #Cust                         6A
     D  #AdrStr                     180A

     D/Copy QFunctDefn,$IsBatch
     D LKCUST          PR                  ExtPgm('LKCUST')
     D  #CMLOOK                      15A   Const
     D  #CMCUST                       6P 0 Const
     D  #CMNAME                      30A   Const

     D  LOOK           S             15A
     D  CUST           S              6P 0
     D  NAME           S             30A

      /Free
         Cust = %Int('0' + %Trim(#Cust));
         If Cust = *Zero and not $isBatch;
           CallP LKCUST(Look:CUST:Name);
         EndIf;

         Exec SQL  // Get Address String for Selected Customer
           SELECT
             trim(CMADD2) || ',' ||
             trim(CMADD3) || ',' ||
             trim(CMCITY) || ',' ||
             trim(CMSTST) || ',' ||
             trim(CMZIP )
           INTO :#AdrStr
           FROM fmcust
           Where  CMCUST = :Cust;

         *InLR = *On;

      /End-Free
