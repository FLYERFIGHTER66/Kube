    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

     FCANORDFM  CF   E             WORKSTN

     FFHORDR    UF   E           K DISK
     FFHORDRHISTO  A E           K DISK
     FFIORDR    UF   E           K DISK
     FFIORDRWK  UF   E           K DISK
     FFMINVT    UF   E           K DISK
     FFLKITM    UF   E           K DISK
     FFALITEM   UF   E           K DISK
     FFDLOTRD   UF   E           K DISK
     FFDLOT     UF   E           K DISK
     FPLUG_ORD  IF   E           K DISK

      //? Prototypes
     D CanOrd          PR                  ExtPgm('CANORD')                     Cancel Order
     D Parm_Ord#                           Like(OHORD#)

      //? Main procedure interface
     D CanOrd          PI
     D Parm_Ord#                           Like(OHORD#)

      //ShpCfmOrd(Cnfm_Ord#)
     D ShpCfmOrd       PR                  ExtPgm('BIR235ICL')                  Ship Confirm Order
     D Cnfm_Ord#                      6A   Const

      //ALOCD(OIQORD-OIQSHP:OIORD#:OISEQ#:'Y'); // Updates FMINVT, FALITEM & FDLOTRD
     D ALOCD           PR                  ExtPgm('ALOCD')
     D ALOCD_1                             Const Like(OIQORD)
     D ALOCD_2                             Const Like(OIORD#)
     D ALOCD_3                             Const Like(OISEQ#)
     D ALOCD_4                        1A   Const

      // GETORD$(OHORD#:Dollars92); // Updates FMCUST & FOPNORD
     D GETORD$         PR                  ExtPgm('GETORD$')
     D GETORD$_1                           Const Like(OHORD#)
     D GETORD$_2                           Const Like(Dollars92)


      //? Work Fields
     D Screen          S              2S 0
     D DelQty          S              5S 1
     D Dollars92       S              9S 2

      //? Function Prototypes
    ?D/COPY QFunctDefn,$isBatch
    ?D/COPY QFunctDefn,$DateMDY
    ?D/COPY QFunctDefn,$MDYDate
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$Day
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User
    ?D/COPY QFunctDefn,$TimeStamp

      /FREE


       DoU *InLR;
         Select;
           When Screen = 01;
             ExSR Edit01;
         ENDSL;
       ENDDO;
      /EJECT

       //  :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
       //  :     LOAD01 - Load Screen 01                               :
       //  :...........................................................:
       BegSR LOAD01;

         *In50 = *Off;
         *In51 = *Off;
         *In52 = *Off;
         *In53 = *Off;
         *In54 = *Off;
         *In55 = *Off;
         *In56 = *Off;
         *In57 = *Off;
         *In58 = *Off;

         SetLL OHORD# PLUG_ORD;

         If %Equal(PLUG_ORD);
           OrderType = '  Plug Order  ';
           Else;
           OrderType = 'Finished Order';
         ENDIF;

         Chain OHORD# FHORDR;

         If  not %Found(FHORDR);
           *In51 = *On;                 // Order Not Found => No Cancel
         ENDIF;

         IF OHSTAT = 'D';
           *In52 = *On;                 // Order Deleted => No Cancel
         ENDIF;

         If OHCOFL = 'Y';
           *In53 = *On;                 // Closed Order => No Cancel
         ENDIF;

         If OHHOLD = 'R';
           *In54 = *On;                 // Released Order => No Cancel
         ENDIF;

         SetLL OHORD# FIORDR;
         ReadE OHORD# FIORDR;
         DoU %EOF(FIORDR);
           If OISHCD = 'R';             // Released Line => No Cancel
             *In54 = *On;
           ENDIF;
           If OIQSHP <> *Zero;          // Something Shipped => No Delete
             *In55 = *On;
           ENDIF;
           If OIPOST = 'Y';             // Posted to Production => No Delete
             *In56 = *On;
           ENDIF;
           If OILOT# <> *Blanks;        // Something Custom Sown => No Delete
             *In57 = *On;
           ENDIF;
           ReadE OHORD# FIORDR;
         ENDDO;

       EndSr;
      /EJECT

       //  :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
       //  :     SCRN01 - Display Screen 01                            :
       //  :...........................................................:
       BegSR SCRN01;
         Screen = 01;
         Exfmt CANORD01;
       EndSr;
      /EJECT

       //  :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
       //  :     EDIT01 - Edit Check Screen 01                         :
       //  :...........................................................:
       BegSR EDIT01;

         Select;
           When *In03 = *On;
             *InLR = *On;
           When *In09 = *On;
             UnLock FHORDR;
             ShpCfmOrd(%EditW(OHORD#:'0     '));
             ExSr Load01;
             ExSr Scrn01;
           When *In10 = *On;
             ExSr CANORDSUB;
             *InLR = *On;
           When *In22 = *On;
             ExSr DELORDSUB;
             *InLR = *On;
           Other;
             ExSr Scrn01;
         ENDSL;

       ENDSR;
      /EJECT

       //  :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
       //  :     CANORDSUB - Cancel the Order Subroutine               :
       //  :...........................................................:
       BEGSR CANORDSUB;
         SETLL OHORD# FIORDR;
         READE OHORD# FIORDR;
         DoW not %Eof(FIORDR);
           If OISTAT = 'A';
             OISTAT = 'D';
             OICOFL = 'Y';
             OITIME = $Now();
             OIDTLA = $MDYDate($Date(0));
             UPDATE RIORDR;
             DELQTY = OIQORD - OIQSHP;
             EXSR UNALLO;
           ENDIF;
         READE OHORD# FIORDR;
         ENDDO;
         OHSTAT = 'D';
         OHCOFL = 'Y';
         UPDATE RHORDR;
         HSTUSER    = $User();
         HSTPROGRAM = 'CANORD_CAN';
         HSTTIME    = $Timestamp();
         WRITE RHORDRHIST;
         GETORD$(OHORD#:Dollars92);
       EndSr;
      /EJECT

       //  :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
       //  :     DELORDSUB - Cancel the Order Subroutine               :
       //  :...........................................................:
       BEGSR DELORDSUB;

         SetLL OHORD# FIORDR;
         ReadE(n) OHORD# FIORDR;
         DoW not %Eof(FIORDR);
           If OIITYP = *Blanks;
             DELQTY = OIQORD - OIQSHP;
             ExSr UNALLO;
           ENDIF;
           Chain (OIORD#:OISEQ#) FIORDR;
           Delete RIORDR;
           ReadE(n) OHORD# FIORDR;
         ENDDO;

         Setll OHORD# FIORDRWK;
         ReadE OHORD# FIORDRWK;
         DoW not %Eof(FIORDRWK);
           Delete RIORDRWK;
           ReadE OHORD# FIORDRWK;
         ENDDO;

         Delete RHORDR;
         HSTUSER    = $User();
         HSTPROGRAM = 'CANORD_DEL';
         HSTTIME    = $Timestamp();
         WRITE RHORDRHIST;

         GETORD$(OHORD#:Dollars92);

       ENDSR;
      /EJECT

       //  :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
       //  :     UNALLO - Un-Allocate the Order                        :
       //  :...........................................................:
       BEGSR UNALLO;

         CHAIN (OIITEM:OISIZE) FMINVT;
         If %FOUND(FMINVT);
           If IMLOTC = 'Y';
             UnLock FMINVT;
           // This is the Plug Inventory Logic
             ALOCD(OIQORD-OIQSHP:OIORD#:OISEQ#:'Y'); // Updates FALITEM & FDLOTRD
             Chain (OIITEM:OISIZE:OIWHSE:
                    OISOW:' ':OIRVDT) FDLOT;
             If %Found(FDLOT);
               LDQTAL = LDQTAL - DELQTY;
               LDQTAV = LDQTAV + DELQTY;
               LDDTLA = LRDTLA;
               LDTIME = LRTIME;
               LDUSER = LRUSER;
               Update RDLOT;
             ENDIF;
           Else;
           // This is the Finished Inventory Logic
             IMQTAL = IMQTAL - DELQTY;
             IF IMQTAL <= 0;
               IMQTAL = 0;
             ENDIF;
             IMQTAV = IMQTOH - IMQTAL;
             UPDATE RMINVT;

             CHAIN (OIITEM:OISIZE) FLKITM;
             If %FOUND(FLKITM);
               LKPAL = LKPAL -DELQTY;
               IF LKPAL <= 0;
                 LKPAL = 0;
               ENDIF;
               UPDATE RLKITM;
             ENDIF;
           ENDIF;
         ENDIF;
       ENDSR;
      /EJECT


       //  :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
       //  :       *INZSR  Initialization Subroutine                             :
       //  :.....................................................................:
       BEGSR *INZSR;
         OHORD# = Parm_Ord#;
         ExSr Load01;
         ExSr Scrn01;
       ENDSR;
      /END-FREE
