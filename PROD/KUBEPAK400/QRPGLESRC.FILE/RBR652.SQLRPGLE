    ?H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
    ?H BndDir('*LIBL/KPFUNCTION')                                               ?Binding Directory
    ?H DftActGrp(*No)                                                           ?Default Activation
    ?H DatFmt(*usa)                                                             ?Date Format

     FRBR652FM  CF   E             WORKSTN
     FFTRAY     IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FRBLOTRD   UF A E           K DISK    Rename(RDLOTRD:Partials)
     FRBLOTRD_AVUF A E           K DISK    Rename(RDLOTRD:Available)
     FRB_TRAY   UF A E           K DISK    Rename(RTRAY:RBTray)
     FFTRAYTRN  O    E           K DISK

      //  Main procedure prototype & interface
     D RBR652          PR                  ExtPgm('RBR652')
     D RBR652          PI

     D  ScanDS         DS                  Inz
     D  Scan01
     D  Scan02
     D  Scan03
     D  Scan04
     D  Scan05
     D  Scan06
     D  Scan07
     D  Scan08
     D  Scan09
     D  Scan10
     D  Scan                               Dim(10) Overlay(ScanDS) Like(Scan01)

     D Count           S              5S 0 Inz(0)

      *? Function Prototypes
    ?D/COPY QFunctDefn,$TimeStamp
    ?D/COPY QFunctDefn,$USER
    ?D/COPY QFunctDefn,$NOW
    ?D/COPY QFunctDefn,$_DATES

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         Exec SQL Select count(*) into :Count from RBLOTRD;
         If Count > 0;
           DoW not *InLr;
             ExFmt RBR65201;
             Edit01();
           EndDo;
         EndIf;
         *InLR = *On;

      /End-Free
     P Edit01          B
     D Edit01          PI
     D  x              S              2S 0
     D  myTest         S              1A
      /Free
        Select;
        When *In03;
          Eval *InLR = *On;
        Other;
          For x = 1 by 1 to 10;
            If Scan(x) > 0;
              Chain Scan(x) FTRAY;
              Chain Scan(x) RB_TRAY;
              If %Found(FTRAY) and not %Found(RB_TRAY);
                CountMe();
                TRDTLA = $MDYDate($Date(0));
                TRTIME = $NOW();
                TRUSER = $USER();
                Write RBTray;
                TRTRNU = TRUSER;
                TRTRNP = 'RBR652';
                TRTRNT = $TimeStamp();
                TRTRND = 'Tray Scanned for R.B. Inventory.   ';
                Write RTrayTrn;
              EndIf;
            EndIf;
          EndFor;
          Clear Scan;
        EndSL;
      /End-Free
     P Edit01          E

     P CountMe         B
     D CountMe         PI
     D  x              S              2S 0
     D  Cust           S              6S 0 Inz(0)
      /Free
        Scanned += 1;
        If TRSTAT = 'P';
          TRITEM = %Trim(TRITEM)+'P';
          Cust = 999997;
          Chain (TRITEM:TRSIZE:TRSCYM:TRCRDT:'R  ':999997) RBLOTRD;
         Else;
          Cust = 0;
          Chain (TRITEM:TRSIZE:TRSCYM:TRCRDT) RBLOTRD_AV;
        EndIf;
        If TRSTAT = 'P' and %Found(RBLOTRD) or
           TRSTAT <>'P' and %Found(RBLOTRD_AV);
          LRQTOH += 1;
          LRQTAV -= 1;
          LRUSER  = 'RBR652';
          If TRSTAT = 'P';
            Update Partials;
           Else;
            Update Available;
          EndIf;
        Else;
          If TRSTAT = 'P';
            Chain (TRITEM:TRSIZE:TRSCYM:TRCRDT:'R  ':999997) RBLOTRD;
           Else;
            Chain (TRITEM:TRSIZE:TRSCYM:TRCRDT:'R  ':000000) RBLOTRD;
          EndIf;

          If %Found(RBLOTRD);
            LRUSER  =  'RBR652_N1';                                          //USER')
            LRQTAV -= 1;
            Update Partials;
           Else;
            Chain (TRITEM:TRSIZE) FMINVT;
            LRSTAT  =  'N'    ;                                              //STATUS N=New
            LRITEM  =  TRITEM ;                                              //ITEM #
            LRSIZE  =  TRSIZE ;                                              //SIZE CODE
            LRWHSE  =  ' '    ;                                              //LOCATION')
            LRSOWD  =  TRSCYM ;                                              //SOW DATE CYMD
            LRGLOC  =  'R'    ;                                              //GROW LOC. ORIG
            LRCRDY  =  TRCRDT ;                                              //CURR. READY DATE CYMD
            LRCLOC  =  'R'    ;                                              //LOC. CURR
            LRCUST  =  Cust   ;                                              //RESERV. CUST #
            LRQTOH  =  1      ;                                              //QTY O/H
            LRALPH  =  IMLOOK ;                                              //ALPHA SEARCH')
            LRPRCL  =  TRPRDC ;                                              //PRODUCT CLASS')
            LRDESC  =  IMDES1 ;                                              //DESCRIPTION')
            LRUSER  =  'RBR652_N2';                                          //USER')
            LRQTAV  =  -1     ;                                              //QTY AVAIL')
            Write Partials;
          EndIf;
        EndIf;

      /End-Free
     P CountMe         E
