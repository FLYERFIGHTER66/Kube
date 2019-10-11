     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: TRGMINVT - Item Master File                                :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2014                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:

      // Main procedure prototype & interface

      //?Definitions
     D/COPY QRPGLESRC,TRGBUFSRC
     D/COPY QFunctDefn,$TimeStamp

     D JOB             PR                  EXTPGM('JOB')
     D   #JOBNAM                     10A   CONST
     D   #JOBUSR                     10A   CONST
     D   #JOBNBR                      6A   CONST

      //  Record format for New and Old Records.
     D OldRecord     E DS                  ExtName(FMINVT)
     D                                     Prefix(O_)
     D                                     Based(OldRecPtr)
     D NewRecord     E DS                  ExtName(FMINVT)
     D                                     Prefix(N_)
     D                                     Based(NewRecPtr)

      //  Record layout for New and Old Null Maps.
     D OldNullMap      DS                  Based(OldNullPtr)
     D  ONullFld                      1    DIM(5)
     D NewNullMap      DS                  Based(NewNullPtr)
     D  NNullFld                      1    DIM(5)

     D TRGMINVT        PR                  ExtPgm('TRGMINVT')
     D  #TrgBuffer                         Like(TrgBuffer)
     D  #TrgBufferLen                      Like(TrgBufferLen)
     D TRGMINVT        PI
     D  #TrgBuffer                         Like(TrgBuffer)
     D  #TrgBufferLen                      Like(TrgBufferLen)

     D JOBDS           DS
     D   LOGJOBNAM                   10A
     D   LOGJOBUSR                   10A
     D   LOGJOBNBR                    6A

     D TimeStamp       S               Z

      /Free

         TrgBuffer    = #TrgBuffer    ;
         TrgBufferLen = #TrgBufferLen ;
         OldRecPtr  = %ADDR(TrgBuffer) + TOldRecOff;
         NewRecPtr  = %ADDR(TrgBuffer) + TNewRecOff;
         OldNullPtr = %ADDR(TrgBuffer) + TOldNullOff;
         NewNullPtr = %ADDR(TrgBuffer) + TNewNullOff;

         // Onlt Log it if there is an Inventory Change
         If O_IMQTAV <> N_IMQTAV or
            O_IMQTOH <> N_IMQTOH or
            O_IMQTAL <> N_IMQTAL;

           CallP JOB(LOGJOBNAM:LOGJOBUSR:LOGJOBNBR);
           TimeStamp = $TimeStamp();

           Exec SQL  // Write change Log
           INSERT INTO FMINVTLOG1
            (  LOGTYPE
            ,  LOGTIME
            ,  LOGJOBNAM
            ,  LOGJOBUSR
            ,  LOGJOBNBR
            ,  LOGIMAG
            ,  LOGPROG
            ,  IMITEM
            ,  IMSIZE
            ,  IMWHSE
            ,  IMDES1
            ,  IMDES2
            ,  IMPUOM
            ,  IMLOTC
            ,  IM#ORD
            ,  IMQTOH
            ,  IMQTAL
            ,  IMQTAV
            ,  IMQTBO
            ,  IMQMTD
            ,  IMDTLA
            ,  IMTIME
            ,  IMUSER  )
           Values
            ( 'TRGMINVT'
            , :TimeStamp
            , :LOGJOBNAM
            , :LOGJOBUSR
            , :LOGJOBNBR
            , 'A'
            , 'TRGMINVT'
            , :N_IMITEM
            , :N_IMSIZE
            , :N_IMWHSE
            , :N_IMDES1
            , :N_IMDES2
            , :N_IMPUOM
            , :N_IMLOTC
            , :N_IM#ORD
            , :N_IMQTOH
            , :N_IMQTAL
            , :N_IMQTAV
            , :N_IMQTBO
            , :N_IMQMTD
            , :N_IMDTLA
            , :N_IMTIME
            , :N_IMUSER  );
         EndIf;

         *InLR = *On;

      /End-Free
