    ?H/COPY QFunctDefn,@CopyRight
    ?H DftActGrp(*no)
    ?H DatFmt(*usa)
    ?H BndDir('*LIBL/KPFUNCTION')
      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    2002
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
      **PROGRAM NAME-------- PSR700
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- DELETE WEEKS RECORDS FROM LOCATION FILE.
      *
      *            CHANGE--DATE-------DESCRIPTION
      *  3/28/02 EFD ADD ORDER WORK FILE
      *  4/04/02 EFD ADD PUT DOWN CONTROL FILE
      *  3/21/13 WJB Re-Wrote in SQLRPGLE
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
     D  PROGID                 1     10                                         PROGRAM NAME
     D  RLIBR                 81     90                                         RUN LIBRARY
     D  USERID               254    263                                         USER I.D.
     D  SLIBR                314    323                                         SOURCE LIBRARY
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  STRDAT                 4     10  0
     D  PLDATE                11     16  0
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
     D  RPRTR                134    143
     D  UDSMASTER           1023   1024  0
      ***********************
      /Free

         Exec SQL  // Delete everything but the RB order
           Delete
           From    FPUTORD
           Where   PDSHPD = :STRDAT
             and   PDMAST = :UDSMaster
             and   PDCUST <> 999996;

         Exec SQL  // Zero out the RB order
           Update  FPUTORD
           Set     PDQSCH = 0
             ,     PDQSCN = 0
           Where   PDSHPD = :STRDAT
             and   PDMAST = :UDSMaster
             and   PDCUST =  999996;

         Exec SQL
           Delete
           From    FCART
           Where   CTPSDT = :STRDAT
             and   CTMAST = :UDSMaster;

         Exec SQL
           Delete
           From    FWKORD
           Where   OWSHDT = :STRDAT
             and   OWMAST = :UDSMaster;

         Exec SQL
           Delete
           From    FPTORDC
           Where   PTSHPD = :STRDAT
             and   PTMAST = :UDSMaster;

         *InLR = *On;

      /End-Free
