    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')

      *?                                                              ?
      *??|                                                            |?
      *??|       Cuttings Inquiry Program                             |?
      *?|                                                            |?

      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2001
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRISES, INC.     ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES, INC.     215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- CUR100
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- CALCULATE CUTTING NEEDS FILE
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 11/17/02 EFD CHANGE FROM 84 TO 105 TRAYS.
      *
     FFCALEN    IF   E           K DISK
     F                                     RENAME(RCALEN:CALENI)
     FFCALEX    IF   E           K DISK
WJB  FFMINVTCT  IF   E           K DISK
     FFIORITEM  IF   E           K DISK
     FFCUTLOT   UF A E           K DISK
      *
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY

     D  Vendor         S                   Like(IMVEND)
     D   Command       S            200A   Inz(*Blanks)                         ?System Command
     D   MissingCut    S              6S 0 Inz(*Zeros)                          ?RCDs Missing CUT
     D   MissingVItem  S              6S 0 Inz(*Zeros)                          ?RCDs Missing V Item

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCmdExc
    ?D/COPY QFunctDefn,$isBatch

      *? Arrays
     D   Cmd           S            100A   Dim(0003) CtData                     ?System Commands

      ****************
      * START HERE   *
      ****************
      ** CLEAR OUT OLD COUNT
     C                   EXSR      CLROLD
      ** GET OPEN ORDERS
WJB  C     *LOVAL        SETLL     FMINVTCT                                                    ARC38
     C     NXT           TAG
WJB  C                   READ      FMINVTCT                               90                   ARC38
     C   90              GOTO      END
     C     IMFRSZ        IFNE      'CUT'
     C     IMSTAT        OREQ      'D'
     C     IMVEND        ORNE      Vendor
     C                   GOTO      NXT
     C                   END
     C                   EXSR      GETORD
     C                   GOTO      NXT
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** CLEAR OLD COUNT   **
      ***********************
     C     CLROLD        BEGSR
     C                   MOVEL     'CUT'         SIZE              3
     C     Vendor        SETLL     FCUTLOT
     C     NXTCLR        TAG
     C     Vendor        READE     FCUTLOT                                91
     C   91              GOTO      ENDCLR
     C                   Z-ADD     0             CLQTTS
     C                   Z-ADD     0             CLQTTF
     C                   Z-ADD     0             CLQTSL
     C                   Z-ADD     0             CLQTSP
     C                   UPDATE    RCUTLOT
     C                   GOTO      NXTCLR
     C     ENDCLR        ENDSR
      ***********************
      ** GET OPEN ORDERS   **
      ***********************
     C     GETORD        BEGSR
     C     ORDKEY        KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C     ORDKEY        SETLL     FIORITEM
     C     NXTORD        TAG
     C     ORDKEY        READE     FIORITEM                               91
     C   91              GOTO      ENDORD
     C*    OISOW         IFLT      BEGSCY
     C     OISTAT        IfEQ      'D'
     C*    OILOTC        OREQ      'Y'
     C                   GOTO      NXTORD
     C                   END
     C     LOTKEY        KLIST
     C                   KFLD                    Vendor
     C                   KFLD                    OIITEM
WJB  C*                  KFLD                    SIZE
WJB  C                   KFLD                    OISIZE
     C                   KFLD                    OISOW
     C                   MOVEL     'CUT'         SIZE
     C     LOTKEY        CHAIN     FCUTLOT                            71
     C   71              DO
     C                   CLEAR                   RCUTLOT
     C                   MOVEL     Vendor        CLVEND
     C                   MOVEL     OIITEM        CLITEM
WJB  C*                  MOVEL     'CUT'         CLSIZE
WJB  C                   MOVEL     OISIZE        CLSIZE
     C                   Z-ADD     OISOW         CLSOWD
     C                   END
     C                   Z-ADD     OIRVDT        CLRDYD
     C                   MOVEL     IMLOOK        CLLOOK
     C                   MOVEL     'A'           CLSTAT
     C                   ADD       OIQORD        CLQTTS
     C                   If        OICUST = 2730
     C                   ADD       OIQORD        CLQTSP
     C                   EndIf
     C   71              WRITE     RCUTLOT
     C  N71              UPDATE    RCUTLOT
     C                   GOTO      NXTORD
     C     ENDORD        ENDSR
      ***********************
      ** Missing - Items Missing CUT Item or Vendor Item Number
      ***********************
     C     Missing       BEGSR

      *?  Count Cutting Item Records Missing Cooresponding CUT record.
    ?c/exec sql
    ?c+
    ?c+    select  count(*)
    ?c+    into    :MissingCUT
    ?c+    from    fminvt as A
    ?c+    where   imstat = 'A'
    ?c+      and   imfrsz = 'CUT'
    ?c*      and   imvend = :Vendor
    ?c+      and   imitem <> '1222'
    ?c+      and   imitem not in
    ?c+            (select b.imitem from fminvt as b where b.imsize = 'CUT')
    ?c+
    ?c/end-exec

      *?  STRPCCMD PCCMD('call "P:\CUT\URC Items without CUT Record.xls"')
     C                   If        MissingCut > 0
     C* WJB              Eval      Command = CMD(1)
WJB  C                   Eval      Command = %Trim(CMD(1)) + %Trim(CMD(2))
     C                   CALLP     QCmdExc(Command:%len(%Trim(Command)))
     C                   EndIf

      *?  Count Cutting Item Records Missing Vendor Item Number.
    ?c/exec sql
    ?c+
    ?c+    select  count(*)
    ?c+    into    :MissingVItem
    ?c+    from    fminvt as A
    ?c+    where   imstat = 'A'
    ?c+      and   imfrsz = 'CUT'
    ?c*      and   imvend = :Vendor
    ?c+      and   imvitm = ' '
    ?c+
    ?c/end-exec

      *?  STRPCCMD PCCMD('call "P:\CUT\URC Items without a Vendor Item Number.xls"')
     C                   If        MissingVItem > 0
     C* WJB              Eval      Command = CMD(2)
WJB  C                   Eval      Command = %Trim(CMD(1)) + %Trim(CMD(3))
     C                   CALLP     QCmdExc(Command:%len(%Trim(Command)))
     C                   EndIf

     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C     *Entry        PList
     C                   Parm                    Vendor
     C                   If        not $isBatch()
     C                   ExSr      Missing
     C                   EndIf
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
      ** GET LOWEST SOW DATE (THIS WEEK)
     C     TDATE         CHAIN     FCALEN                             90
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             90
     C                   Z-ADD     CLCYMD        BEGSCY            7 0
     C                   ENDSR
**
STRPCCMD PCCMD('call "\\10.151.151.1\Kube Pak\Production Applications\
CUT\REPORTS\URC Items without CUT Record.xls"')
CUT\REPORTS\URC Items without a Vendor Item Number.xls"')
