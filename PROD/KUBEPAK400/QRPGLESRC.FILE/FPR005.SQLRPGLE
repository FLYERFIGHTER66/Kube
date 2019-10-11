     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      //? :````````````````````````````````````````````````````````````:?
      //? :   Title:  Upload Finished Production Schedule Info         :?
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
      //? :  WJB    -? 1/22/16 - Initial Programming                  ?:
      //? :         -?  /  /   - _____________________________________?:
      //? :............................................................:

      //? Main procedure prototype & interface
     D FPR005          PR                  ExtPgm('FPR005')
     D FPR005          PI

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCMDEXC
    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User

      *? Fields
     D  Command        S            256A   inz(*Blanks)
     D  User           S             10A   inz(*Blanks)
     D  Today          S              6S 0 inz(*Zero)
     D  Now            S              6S 0 inz(*Zero)
     D* Year           S              4S 0 inz(2016)

      /Free

         Today = $MDYDate($Date(0));
         Now = $Now();
         User = $User();

         Exec SQL
           DROP TABLE   QTEMP/FFINPROJUP;

         Command = 'XLPARSE2/XLSTABLE ' +
                   'XLS(''/KUBE PAK/XLSIMPORT/FINPROJMRG.XLSX'') ' +
                   'FILE(QTEMP/FFINPROJUP) ' +
                   'CRTFILE(*YES) '+
                   'HLINES(1) ' ;
         QCmdExc(Command:%Len(%Trim(Command)));

         Exec SQL
           DELETE FROM FFINSUM
             Where FSYEAR = year(current date) and FSPROJ <> 'Y';

         Exec SQL
           INSERT INTO FFINSUM
           (SELECT
             'U'
           , IMITEM
           , IMSIZE
           , year( current date )
           , IMLOOK
           , FLD3
           , FLD3
           , 0
           , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
           , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
           , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
           , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
           , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
           , 0, 0, 0
           , 'N'
           , :Today
           , :Now
           , :User
           , 'FPR005'
           FROM QTEMP/FFINPROJUP, FMINVT
           WHERE IMITEM = trim(char(int(FLD1)))
             and IMSIZE = trim(char(int(FLD2))));

         *InLR = *On;

       /End-Free
