     **Free
      /copy QFunctDefn,#CopyRight //Kube-Pak Corporation. All rights reserved.
       CTL-OPT
           DftActGrp(*no)
           BndDir('KPFUNCTION')
           DatFmt(*usa);

       DCL-PI RBR620;
       END-PI;

          //? Function Prototypes
         dcl-pr RmvLotInv extpgm ;
             FmTag# zoned(8:0) const ;
             ToTag# zoned(8:0) const ;
         end-pr ;
      /copy QFunctFree,$_Dates
      /copy QFunctFree,$Now
      /copy QFunctFree,$User
      /copy QFunctFree,$TimeStamp

         // Define Files
         dcl-f RBR620FM WORKSTN;
         dcl-f FTRAY keyed usage(*update);
         dcl-f FTRAY_RB keyed usage(*input);
         dcl-f FDLOTRD_S keyed usage(*update:*output) ;
         dcl-f FDLOTRD_PT keyed usage(*update) Rename(RDLOTRD:RDLOTRD_PT);
         dcl-f FDLOTRD_AV keyed usage(*update) Rename(RDLOTRD:RDLOTRD_AV);
         dcl-f FTRAYTRN keyed usage(*output);
         dcl-f FMINVT keyed;
         dcl-f FLOSSD keyed usage(*update:*output);
         dcl-f FLOSSLOT keyed usage(*update:*output);

          // Definitions
         dcl-s PassedTag like(ScannedTag);

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
         If PassedTag = *Zero;
           DoW not *InLr;
             ExFmt RBR62001;
             Edit01();
           EndDo;
          Else;
          //  Following logic provided in case we want to change the program to pass in a tag
           ScannedTag = PassedTag;
           Chain ScannedTag FTRAY;
           Chain ScannedTag FTRAY_RB;
           If %Found(FTRAY) and %Found(FTRAY_RB);
             DumpTag(ScannedTag);
             RmvLotInv(ScannedTag:ScannedTag);
           EndIf;
           *InLR = *On;
         EndIf;
       Return;

       //-----------------------------------------------------------------------
       dcl-proc edit01;
       //-----------------------------------------------------------------------

         *In90 = *Off;

         Select;
         When *In03;
           *InLR = *On;
         When *In13;    //  Switch Modes between "dump mode" and "remove from RB mode".
           *In60 = not *in60;
         Other;
           Chain ScannedTag FTRAY;
           Chain ScannedTag FTRAY_RB;
           If %Found(FTRAY) and %Found(FTRAY_RB);
             *In90 = *On;
             RemoveTag(ScannedTag);
             LastTag = ScannedTag;
           EndIf;
           If *In60;
             DumpTag(ScannedTag);
             RmvLotInv(ScannedTag:ScannedTag);
           ENDIF;
           Clear ScannedTag;
         EndSL;
       End-Proc;

       //-----------------------------------------------------------------------
       Dcl-Proc RemoveTag;
       //-----------------------------------------------------------------------
         dcl-pi *n;
           Tag# like(TRTAG#);
         END-PI;

         Chain (Tag#) FTRAY;
         *In51 = *Off;
         If TRSTAT = 'P';
           Chain(n) (TRITEM:TRSIZE:TRCRDT:TRSCYM:'R  ') FDLOTRD_PT;
           If %Found(FDLOTRD_PT);
             Chain  (LRITEM:LRSIZE:LRCRDY:LRSOWD:'R  ':LRCUST) FDLOTRD_S;
             LRQTOH  -= 1;
             LRQTAV  -= 1;
             LRDTLA   = $MDYDate($Date(0));
             LRTIME   = $Now();
             LRUSER   = 'RBR620pt';
             Update RDLOTRD;
            Else;
             *In51 = *On;
             Return;
           EndIf;
          Else;
           Chain(n) (TRITEM:TRSIZE:TRCRDT:TRSCYM:'R  ') FDLOTRD_AV;
           If %Found(FDLOTRD_AV);
             Chain  (LRITEM:LRSIZE:LRCRDY:LRSOWD:'R  ':LRCUST) FDLOTRD_S;
             LRQTOH  -= 1;
             LRQTAV  -= 1;
             LRDTLA   = $MDYDate($Date(0));
             LRTIME   = $Now();
             LRUSER   = 'RBR620av';
             Update RDLOTRD;
            Else;
             *In51 = *On;
             Return;
           EndIf;
         EndIf;

         Chain (LRITEM:LRSIZE:LRCRDY:LRSOWD:'N  ':LRCUST) FDLOTRD_S;
         LRDTLA   = $MDYDate($Date(0));
         LRTIME   = $Now();
         LRUSER   = 'RBR620n';
         LRGLOC   = 'N';
         LRCLOC   = ' ';
         If %Found(FDLOTRD_S);
           LRQTOH  += 1;
           LRQTAV  += 1;
           Update RDLOTRD;
          Else;
           LRGLOC   = 'N  ';
           LRQTOH   = 1;
           LRQTAV   = 1;
           Write RDLOTRD;
         EndIf;

         Exec sql   Delete FROM FTRAY_RB WHERE TRTAG# = :TRTAG#;

         TRTRNU = $User()      ;
         TRTRNP = 'RBR620'     ;
         TRTRNT = $TimeStamp() ;
         TRTRND = 'Tag removed from R.B.';
         Write RTRAYTRN;
       End-Proc;

       //-----------------------------------------------------------------------
       Dcl-Proc DumpTag;
       //-----------------------------------------------------------------------
         dcl-pi *n;
           Tag# like(TRTAG#);
         END-PI;

         LDCONT = 0;
         Chain Tag# FTRAY;
         //? Only update Loss files if it's an active tag. ?
         If %Found(FTRAY);
           Chain TRTAG# FLOSSD;
           Chain (TRITEM:TRSIZE:TRCRDT) FLOSSLOT;
           Chain (TRITEM:TRSIZE) FMINVT;

           // Write/Update record to FLOSSD
             LDTAG# = TRTAG#;
             LDCODE = 'D';
             LDITEM = TRITEM;
             LDSIZE = TRSIZE;
             LDLOSD = $Date7($Date(0));
             LDSOWD = TRSCYM;
             LDREDY = TRCRDT;
             LDPRDC = TRPRDC;
             LDDTLA = $MDYDate($Date(0));
             LDTIME = $Now();
             LDUSER = $User();
           If not %Found(FLOSSD);
             Write RLOSSD;
            Else;
             Update RLOSSD;
           EndIf;

           // Write/Update record to FTRAY
           TRSTAT = 'M';   // M=Dump
           TRREAS = 'Trays Dumped';
           TRDTLA = $MDYDate($Date(0));
           TRTIME = $Now();
           TRUSER = $User();
           Update RTRAY;

           // Write/Update record to FLOSSLOT
           LDLOSD = $Date7($Date(0));
           LDDES1 = IMDES1;
           LDLOOK = IMLOOK;
           exec sql  // Get QtyLoss for this reason
             SELECT  COUNT(*)  + 1    //  The plus one represents this loss
             INTO    :LDCONT
             FROM    FLOSSD
             WHERE   LDCODE = :TRSTAT
               and   LDITEM = :LDITEM
               and   LDSIZE = :LDSIZE
               and   LDREDY = :LDREDY;
           If not %Found(FLOSSLOT);
             Write RLOSSLOT;
           Else;
             Update RLOSSLOT;
           EndIf;

         EndIf;          //If %Found(FTRAY)

       End-proc;
