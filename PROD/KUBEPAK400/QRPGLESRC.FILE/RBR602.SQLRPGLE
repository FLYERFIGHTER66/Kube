     H/COPY QFunctDefn,@CopyRight
     H DftActGrp(*no)
     H DatFmt(*usa)
     H BndDir('*LIBL/KPFUNCTION')

     FRBR602P   O    E             PRINTER OFLIND(OverFlow) USROPN
     FFRBBATCH  IF   E           K DISK

      //  Main procedure prototype & interface
     D RBR602          PI
     D  SelectedDate                   D   Const
     D  SelectedBatch                 3S 0 Const
     D  SelectedCart                  5S 0 Const
     D  SelPrinter                   10A   Const

      *  System Data Structure
     D                SDS
     D $PGM              *PROC

      *  C1 Data Structure
     D  C1_DS          DS
     D  C1_BATCHDATE                       Like(BATCHDATE)
     D  C1_BATCH#                          Like(BATCH#   )
     D  C1_CART#                           Like(CART#    )
     D  C1_TAG#                            Like(TAG#     )
     D  C1_ITEMSIZE                        Like(ITEMSIZE )
     D  C1_IMDES1                          Like(IMDES1   )
     D  C1_ADDEDBY                         Like(ADDEDBY  )
     D  C1_ADDEDTS                         Like(ADDEDTS  )
     D  C1_MSGCODE                         Like(MSGCODE  )

      *  Function Prototypes
     D/COPY QFunctDefn,$_Dates
     D/COPY QFunctDefn,$DftPrt
     D/COPY QFunctDefn,$ChgPrt
     D/COPY QFunctDefn,$isPrinter
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$RtvMsgD
     D/COPY QFunctDefn,QCmdExc

      *  Field Definitions
     D Count           S             15S 5
     D ReturnCode      S              7A
     D FirstPage       S               N   Inz(*On)
     D OverFlow        S               N   Inz(*On)
     D EndOfFile       S               N   Inz(*On)
     D SelType         S              1A   Inz('E')
     D SelDate         S                   Like(BatchDate)
     D SelBat#         S                   Like(BATCH#   ) Inz(1)
     D SelCart         S                   Like(CART#    ) Inz(1)
     D OvrPrtf         S            256A
     D ItemSize        S             10A
    ? ***********************
    ? ** START HERE        **
    ? ***********************
      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         SelDate = SelectedDate  ;
         SelBat# = SelectedBatch ;
         SelCart = SelectedCart  ;

         OpenDataSet();
         ReadDataSet();
         DoW not EndOfFile;
           If FirstPage or OverFlow;
             If not %Open(RBR602P);
               OVRPRTF = 'OVRPRTF FILE(RBR602P)' +
                                ' FORMTYPE(*NAR)' +
                                ' OUTQ(' + %Trim(SelPrinter) + ')' +
                                ' CPI(10) ' +
                                ' PAGRTT(0)' +
                                ' PAGESIZE(66 80)' +
                                ' OPNSCOPE(*JOB)';
               QCmdExc(OVRPRTF : %len(%trim(OVRPRTF)));
               Open RBR602P;
             EndIf;
             FirstPage = *Off;
             OverFlow  = *Off;
             Write Header;
           EndIf;
           Write Detail;
           MSGDESC = %subst($RtvMsgD('*LIBL':'KPMSGF':MSGCODE):1:50);
           Write MsgRcd;
           ReadDataSet();
         EndDo;

         CloseDataSet();

         If %Open(RBR602P);
           Close RBR602P;
         EndIf;

         *InLR = *On;

      /End-Free

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : SubProcedures                                                    :
      // :..................................................................:
     P OpenDataSet     B
     D OpenDataSet     PI
     D Skip6152        S               N   Inz(*On)
      /Free
         exec sql

             DECLARE  C1 cursor for

             select   BATCHDATE                  as batchDate
                  ,   BATCHNUMBER                as batchNumber
                  ,   CART#                      as cartNumber
                  ,   TAG#                       as trayTagNumber
                  ,   trim(TRITEM)||'('||
                      trim(TRSIZE)||')'||
                      case when TRSTAT = 'P' then 'P' else ' '
                      end                        as item_Size
                  ,   IMDES1                     as item_description
                  ,   ADDEDBY                    as addedByUser
                  ,   ADDEDTS                    as addedTimeStamp
                  ,   MSGCODE                    as messageCode
             from     FRBBATCH, FTRAY, FMINVT
             where    TAG# = TRTAG#
               and    TRITEM = IMITEM
               and    TRSIZE = IMSIZE
               and    BATCHDATE   = :SelDate
               and  ( BATCHNUMBER = :SelBat# or :SelBat# = 0 )
               and  ( CART#       = :SelCart or :SelCart = 0 )
               and  ( MSGCODE>'RBR6149' and :SelType='E' or :SelType <>'E')
               and  ( MSGCODE<>'RBR6152' or :Skip6152='0' )
             Order By BATCHDATE, BATCHNUMBER, CART#, TRSIZE, TRALPH

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
           BATCHDATE   = C1_BATCHDATE ;
           BATCH#      = C1_BATCH#    ;
           CART#       = C1_CART#     ;
           TAG#        = C1_TAG#      ;
           ITEMSIZE    = C1_ITEMSIZE  ;
           IMDES1      = C1_IMDES1    ;
           ADDEDBY     = C1_ADDEDBY   ;
           ADDEDTS     = C1_ADDEDTS   ;
           MSGCODE     = C1_MSGCODE   ;
         EndIf;
      /End-Free
     P ReadDataSet     E
      //_____________________________________________________________________
      //
