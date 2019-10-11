     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)                                                           ?Default Activation
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)                                                             ?Date Format
      *??:````````````````````````````````````````````````````````````:?
      *??: MNR020.01                                                  :?
      *??:............................................................:?
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? : Created:  2016                 ? Kube-Pak Corporation ?    :
      *? :      by:  William J. Behr                                  :
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :   Program Description                                     ?:
      *? : ```````````````````````                                   ?:
      *? :                                                           ?:
      *? :                                                           ?:
      *? :                                                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Function Usage                                          ?:
      *? :                                                           ?:
      *? :  FUNCT  -?FUNCT DESRIPTION HERE                           ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Change Log                                              ?:
      *? :                                                           ?:
      *? :  MNR020.01?Original Version                               ?:
      *? :............................................................:
      *? :"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""":
      *? :?  Indicator Usage                                         ?:
      *? :                                                           ?:
      *? :  26      ?Sets Position to Indicator                      ?:
      *? :  03      ?Exit                                            ?:
      *? :  LR      ?Does this really need a description ?           ?:
      *? :............................................................:

     FFMANUALD  IF   E           K DISK
     FFHORDR    UF   E           K DISK
     FFIORDR    UF   E           K DISK
     FFIORDRWK  O  A E           K DISK
     FFHORDRHISTO  A E           K DISK

      //  Main procedure prototype & interface
     D MNR020          PR                  ExtPgm('MNR020')
     D  #DATE7#                            CONST Like(MNDATE)
     D  #MAST#                             CONST Like(MNSEQ#)
     D MNR020          PI
     D  #DATE7#                            CONST Like(MNDATE)
     D  #MAST#                             CONST Like(MNSEQ#)

     D TRR502          PR                  ExtPgm('TRR502')
     D  #Truck                        4A   Const
     D  #Date7@                       7A   Const

    ?D/COPY QFunctDefn,$TimeStamp
     D/COPY QFunctDefn,$User
     D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$_Dates

      *? Data Structures
     D SYSTEM_DS      SDS
     D  $PGM             *PROC

      *? Field Definitions
     D  ThisDate7      S                   Like(MNDATE)
     D  ThisMaster     S                   Like(MNSEQ#)
     D  ThisOrder      S                   Like(MNORD#)

      // :'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
      // : Main Logic                                                       :
      // :..................................................................:
      /Free

         ThisDate7  = #Date7#;
         ThisMaster = #Mast#;

         SetLL (ThisDate7:ThisMaster) FMANUALD;
         Reade (ThisDate7:ThisMaster) FMANUALD;
         DoW not %EOF(FMANUALD);
           RelOrder(MNORD#:ThisDate7);
         Reade (ThisDate7:ThisMaster) FMANUALD;
         EndDo;

         RecalcTruck(ThisDate7:ThisMaster);

         *InLR = *On;
         Return;

      /End-Free

      //_____________________________________________________________________
      //
     P RelOrder        B
     D RelOrder        PI
     D  #Order                             Like(OIORD#)
     D  #Date7                             Like(MNDATE)
     D  ThisOrder      S                   Like(OIORD#)
      /Free

         ThisOrder = #Order;

         Chain (ThisOrder) FHORDR;  //Order Header Record

         If %Found(FHORDR) and OHSTAT = 'A' and OHHOLD <> 'R';
           OHHOLD     = 'N';
           OHUSER     = $User();
           OHDTLA     = $Today();
           OHTIME     = $Now();
           HSTUSER    = $User();
           HSTPROGRAM = $PGM;
           HSTTIME    = $Timestamp();
           Update RHORDR;
           Write RHORDRHIST;

           Exec SQL  //Delete Work File Record
             Delete from FIORDRWK WHERE OIORD# = :ThisOrder;

           SetLL ThisOrder FIORDR;
           Reade ThisOrder FIORDR;
           DoW not %EOF(FIORDR);
             If OISTAT = 'A';
               // All Lines
               OISHCD = 'R';
               OIPLPT = 'P';
               OIDTRQ = $MDYDate($Date(ThisDate7));
               OIRVDT = ThisDate7;
               OIDTLA = $MDYDate($Date(0));
               OITIME = $Now();
               OIUSER = $User();
               // Line Items
               If OIITYP = ' ';
                 OIRQTY = OIQORD;
                 //OIQINV = OIQORD;
                 If OIOVER = 'N';
                   OIOVER = %Char(OHPRCD);
                 EndIf;
               EndIf;
               Update RIORDR;
               Write RIORDRWK;
             EndIf;
           Reade ThisOrder FIORDR;
           EndDo;
         EndIf;   // OHSTAT = 'A' and OHHOLD <> 'R'
      /End-Free
     P RelOrder        E

      //_____________________________________________________________________
      //
     P RecalcTruck     B
     D RecalcTruck     PI
     D  #ThisDate7                         Like(ThisDate7)
     D  #ThisMaster                        Like(ThisMaster)

     D Truck_DS        DS
     D  TRTRK#                        4A
     D  TRSHDT                        7S 0

      /Free

         ThisDate7  = #ThisDate7;
         ThisMaster = #ThisMaster;

         Exec SQL // Declare Curor for all trucks associated with given multiuple master
           Declare C1 Cursor for
             SELECT    DISTINCT
                       FTRSCHD.TRTRK#
                  ,    FTRSCHD.TRSHDT
             FROM      FMANUALD, FTRSCHD
             WHERE     FMANUALD.MNORD#=FTRSCHD.TRORD#
               and     MNDATE=:ThisDate7
               and     MNSEQ#=:ThisMaster
             GROUP BY  FTRSCHD.TRTRK#, FTRSCHD.TRSHDT
             ORDER BY  FTRSCHD.TRTRK#, FTRSCHD.TRSHDT;
         Exec SQL Close C1;
         Exec SQL Open C1;
         SQLSTATE = '00000';
         DoW SQLSTATE = '00000';
           Exec SQL Fetch C1 into :Truck_DS;
           If SQLSTATE = '00000';
             TRR502(TRTRK#:%Char(TRSHDT));
           EndIf;
         EndDo;
         Exec SQL Close C1;

      /End-Free
     P RecalcTruck     E

      //_____________________________________________________________________
      //
