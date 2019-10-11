     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      //? :````````````````````````````````````````````````````````````:?
      //? :   Title:  Print Finished Location Tag                      :?
      //? :............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  January 2016         ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :   Program Description                                     ?:
      //? : ```````````````````````                                   ?:
      //? :                                                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Edit Log                                                ?:
      //? :                                                           ?:
      //? :  WJB    -? 8/13/14 - Initial Programming                  ?:
      //? :         -?  /  /   - _____________________________________?:
      //? :............................................................:

      //? Main procedure prototype & interface
     D FCR501          PR                  ExtPgm('FCR501')
     D FCR501          PI

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCMDEXC

      *? Fields
     D  Command        S            128A   inz(' ')

      /Free

         Exec SQL Delete from FFINLOCTAG;
         Exec SQL
           INSERT INTO FFINLOCTAG
          (SELECT FLTAG#, FLITEM, FLSIZE, IMDES1, FLGHSE, FLSECT, FLBAY,
                  FLNORS, FLEORW, FLSRTP, FLENDP, FLTOTP, FLQTY, FLPLTG,
                  FLDATE, FLSHIP, 0, 0, ' ', ' ', FLCUST, ' '
           FROM     FFINLOC, FMINVT
           ORDER BY FLGHSE, FLSECT, FLBAY, FLNORS, FLEORW, FLSRTP, FLENDP );

         Exec SQL UPDATE FFINLOCTAG
                  SET FLDATE4 = month(FLDATE)*100+day(FLDATE),
                      FLDATE5 =
                       right('00'||month(FLDATE),2) ||'/'||
                       right('00'||day(FLDATE),2)
                  WHERE year(FLDATE) > 1900;

         Exec SQL UPDATE FFINLOCTAG
                  SET FLSHIP4 = month(FLSHIP)*100+day(FLSHIP),
                      FLSHIP5 =
                       right('00'||month(FLSHIP),2) ||'/'||
                       right('00'||day(FLSHIP),2)
                  WHERE year(FLSHIP) > 1900;

         Exec SQL UPDATE FFINLOCTAG
                  SET FLCABB =
                  (SELECT TBSHRT FROM XATABL
                  WHERE TBTBCD = 'AB'|| substr(digits( FLCUST ),2,5));

         *InLR = *On;

      /End-Free
