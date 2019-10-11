     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

     FRBR653FM  CF   E             WORKSTN
     FRBR653P   O    E             PRINTER OFLIND(OverFlow) USROPN

      //  Main procedure prototype & interface
     D RBR653          PI

      *  System Data Structure
     D                SDS
     D $PGM              *PROC

      *  Field Definitions
     D Count           S             15S 5
     D ReturnCode      S              7A
     D FirstPage       S               N   Inz(*On)
     D OverFlow        S               N   Inz(*On)
     D EndOfFile       S               N   Inz(*On)
     D OvrPrtf         S            256A
     D Screen          S              3S 0

     D LRDESC          S             30A
     D LRITEM          S             12A
     D LRSIZE          S              3A
     D ItemSize        S             10A

      *  C1 Data Structure
     D  C1_DS          DS
     D  C1_LRSTAT                          Like(LRSTAT   )
     D  C1_LRITEM                          Like(LRITEM   )
     D  C1_LRSIZE                          Like(LRSIZE   )
     D  C1_LRSOWD                          Like(LRSOWD   )
     D  C1_LRCRDY                          Like(LRCRDY   )
     D  C1_LRGLOC                          Like(LRGLOC   )
     D  C1_LRCUST                          Like(LRCUST   )
     D  C1_LRDESC                          Like(LRDESC   )
     D  C1_LRQTAV                          Like(LRQTAV   )

      *  Function Prototypes
     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD
     D/COPY QFunctDefn,QCmdExc

    ?
      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         Load01();
         Scrn01();
         DoW not *InLr;
           Edit01();
         EndDo;

         *InLR = *On;

      /End-Free

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : SubProcedures                                                    :
      // :..................................................................:
     P Scrn01          B
     D Scrn01          PI
      /Free
         Screen = 1;
         ExFmt RBR65301;
      /End-Free
     P Scrn01          E
      //_____________________________________________________________________
      //
     P Load01          B
     D Load01          PI
      /Free
         If PRINTER = *Blanks;
           PRINTER = $dftprt($User():$PGM:'*PGM');
         ENDIF;
      /End-Free
     P Load01          E
      //_____________________________________________________________________
      //
     P Edit01          B
     D Edit01          PI
     D  x              S              2S 0
      /Free
         Select;
         When *In03;
           Eval *InLR = *On;
         When *In11;
           PRINTER = $ChgPrt($User():'RBR653':PRINTER);
           Scrn01();
         Other;
           PrintReport();
           Eval *InLR = *On;
         EndSL;
      /End-Free
     P Edit01          E
      //_____________________________________________________________________
      //
     P OpenDataSet     B
     D OpenDataSet     PI
      /Free
         exec sql

           DECLARE  C1 cursor for

           SELECT LRSTAT
                , LRITEM
                , LRSIZE
                , LRSOWD
                , LRCRDY
                , LRGLOC
                , LRCUST
                , LRDESC
                ,-LRQTAV
           FROM   RBLOTRD
           WHERE  LRQTAV <> 0
           ORDER BY LRALPH, LRSIZE, LRITEM, LRCUST, LRCRDY

           For Read only ;

         Exec SQL Open C1;

      /End-Free
     P OpenDataSet     E
      //_____________________________________________________________________
      //
     P CloseDataSet    B
     D CloseDataSet    PI
      /Free
         exec sql
          Close C1 ;
      /End-Free
     P CloseDataSet    E
      //_____________________________________________________________________
      //
     P ReadDataSet     B
     D ReadDataSet     PI
      /Free
         exec sql
          Fetch C1 into :C1_DS;

         If SQLSTT = '02000';
           EndOfFile = *On;
         Else;
           EndOfFile = *Off;
           LRSTAT      = C1_LRSTAT    ;
           LRITEM      = C1_LRITEM    ;
           LRSIZE      = C1_LRSIZE    ;
           LRSOWD      = C1_LRSOWD    ;
           LRCRDY      = C1_LRCRDY    ;
           LRGLOC      = C1_LRGLOC    ;
           LRCUST      = C1_LRCUST    ;
           LRDESC      = C1_LRDESC    ;
           LRQTAV      = C1_LRQTAV    ;

           ItemSize = %Trim(LRITEM) + '-' + %Trim(LRSIZE);
           LRDESC2  = %Subst(LRDESC:1:%Len(LRDESC2));

         EndIf;
      /End-Free
     P ReadDataSet     E
      //_____________________________________________________________________
      //
     P PrintReport     B
     D PrintReport     PI
      /Free
         OpenDataSet();
         ReadDataSet();
         DoW not EndOfFile;
           If FirstPage or OverFlow;
             If not %Open(RBR653P);
               OVRPRTF = 'OVRPRTF FILE(RBR653P)' +
                                ' FORMTYPE(*NAR)' +
                                ' OUTQ(' + %Trim(Printer) + ')' +
                                ' CPI(10) ' +
                                ' PAGRTT(0)' +
                                ' PAGESIZE(66 80)' +
                                ' OPNSCOPE(*JOB)';
               QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));
               Open RBR653P;
             EndIf;
             FirstPage = *Off;
             OverFlow  = *Off;
             Write Header;
           EndIf;
           Write Detail;
           ReadDataSet();
         EndDo;

         CloseDataSet();

         If %Open(RBR653P);
           Close RBR653P;
         EndIf;
      /End-Free
     P PrintReport     E
      //_____________________________________________________________________
      //
