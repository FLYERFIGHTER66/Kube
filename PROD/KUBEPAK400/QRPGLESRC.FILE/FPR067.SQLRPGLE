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
     D FPR067          PR                  ExtPgm('FPR067')
     D  #PPD#                         8P 0 const
     D  #Printer                     10A   const
     D FPR067          PI
     D  #PPD#                         8P 0 const
     D  #Printer                     10A   const

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCMDEXC
    ?D/COPY QFunctDefn,$DftPrt
    ?D/COPY QFunctDefn,$ChgPrt
    ?D/COPY QFunctDefn,$User

      *? Fields
     D  Command        S            256A   inz(*Blanks)
     D  PPD#           S              8S 0 inz(0)
     D  Printer        S             10A   inz(*Blanks)

      /Free
         PPD#    = #PPD#   ;
         Printer = #Printer;
         Exec SQL
           DROP TABLE QTEMP/FFINPPDPRT;
         Command = 'CRTDUPOBJ OBJ(FFINPPDPRT) '+
                   'FROMLIB(*LIBL) '+
                   'OBJTYPE(*FILE) '+
                   'TOLIB(QTEMP) '+
                   'NEWOBJ(FFINPPDPRT) '+
                   'DATA(*NO) '+
                   'CST(*NO) '+
                   'TRG(*NO) '+
                   'FILEID(*YES)';
         QCmdExc(Command:%Len(%Trim(Command)));
         Exec SQL
           DELETE FROM QTEMP/FFINPPDPRT;
         Exec SQL
           Insert into QTEMP/FFINPPDPRT
             ( Select * from FFINPPDTAG Where FPPPD# = :PPD#   );

         Command = 'RUNQRY QRYFILE((QTEMP/FFINPPDPRT)) ' +
                   'OUTTYPE(*DISPLAY) ' +
                   'RCDSLT(*NO)' ;
         QCmdExc(Command:%Len(%Trim(Command)));

         If Printer =  *Blanks;
           Printer = $DftPrt($User():'FPR067':'*PGM');
           Printer = $ChgPrt($User():'FPR067':Printer);
         EndIf;

         Command =
           'LBLBATCH LBLNAM(''PPD_PRT'') QTYOVR(0002) ' +
           'OUTQ(''' + %Trim(Printer) + ''') FORM(''PLTLBL2x4'') ' +
           'MRGFILE(''FFINPPDPRT'') MRGLIB(''QTEMP'')';
         QCmdExc(Command:%Len(Command));

         *InLR = *On;

       /End-Free
