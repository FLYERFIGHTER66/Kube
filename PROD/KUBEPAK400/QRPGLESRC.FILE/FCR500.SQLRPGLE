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
     D FCR500          PR                  ExtPgm('FCR500')
     D  PrdLib                       10A   const
     D  SelTag#                       8P 0 const
     D  SelSect                       2P 0 const
     D  SelBay                        2P 0 const
     D  SelNorS                       1A   const
     D  SelEorW                       1A   const
     D  Printer                      10A   const

     D FCR500          PI
     D  PrdLib                       10A   const
     D  SelTag#                       8P 0 const
     D  SelSect                       2P 0 const
     D  SelBay                        2P 0 const
     D  SelNorS                       1A   const
     D  SelEorW                       1A   const
     D  Printer                      10A   const

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCMDEXC

      *? Fields
     D  Command        S            128A   inz(' ')

      /Free


         Command =
           'CRTDUPOBJ OBJ(FFINLOCTAG) OBJTYPE(*FILE) '+
           'FROMLIB(' + %Trim(PrdLib) +') TOLIB(QTEMP)';
         QCmdExc(Command:%Len(Command));

         Exec SQL Delete from QTEMP/FFINLOCTAG;

         Exec SQL
           INSERT INTO QTEMP/FFINLOCTAG
          (SELECT FLTAG#, FLITEM, FLSIZE, IMDES1, FLGHSE, FLSECT, FLBAY,
                  FLNORS, FLEORW, FLSRTP, FLENDP, FLTOTP, FLQTY, FLPLTG,
                  FLDATE, FLSHIP, 0, 0, ' ', ' ', FLCUST, ' '
           FROM      FFINLOC, FMINVT
           WHERE     FFINLOC.FLITEM=FMINVT.IMITEM
             and     FFINLOC.FLSIZE=FMINVT.IMSIZE
             and (   FFINLOC.FLTAG# = :SelTag#
                or (    FFINLOC.FLSECT = :SelSect
                    and FFINLOC.FLBAY  = :SelBay
                    and FFINLOC.FLNORS = :SelNorS
                    and FFINLOC.FLEORW = :SelEorW )));

         Exec SQL UPDATE QTEMP/FFINLOCTAG
                  SET FLDATE4 = month(FLDATE)*100+day(FLDATE),
                      FLDATE5 =
                       right('00'||month(FLDATE),2) ||'/'||
                       right('00'||day(FLDATE),2)
                  WHERE year(FLDATE) > 2000;

         Exec SQL UPDATE QTEMP/FFINLOCTAG
                  SET FLSHIP4 = month(FLSHIP)*100+day(FLSHIP),
                      FLSHIP5 =
                       right('00'||month(FLSHIP),2) ||'/'||
                       right('00'||day(FLSHIP),2)
                  WHERE year(FLSHIP) > 2000;

         Exec SQL UPDATE QTEMP/FFINLOCTAG
                  SET FLCABB =
                       (SELECT TBSHRT FROM XATABL
                        WHERE TBTBCD = 'AB'|| substr(digits( FLCUST ),2,5))
                  WHERE right('000000'||FLCUST,5) in
                       (SELECT substr(TBTBCD,3,5)
                        FROM XATABL WHERE TBTBCD like 'AB%');

         Command =
           'LBLBATCH LBLNAM(''PLANTING'') QTYOVR(0001) ' +
           'OUTQ(''' + %Trim(Printer) + ''') FORM(''PLTLBL2x4'') ' +
           'MRGFILE(''FFINLOCTAG'') MRGLIB(''QTEMP'')';
         QCmdExc(Command:%Len(Command));

         *InLR = *On;

      /End-Free
