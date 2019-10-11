     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
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
      **PROGRAM NAME-------- SOW200
      **COMPANY------------- EFD ENTERPRISES, INC.
      **SYSTEM-------------- TGMS
      **PROGRAMMER---------- EFD
      **APPLICATION--------- LABEL INQUIRY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
     FSOW200FM  CF   E             WORKSTN
     FFTRAY     IF   E           K DISK
     F                                     RENAME(RTRAY:TRAYI)
     FFTRAYJ    IF   E           K DISK
     FFMINVT    IF   E           K DISK
     FFCALEX    IF   E           K DISK
     FFCALENCY  IF   E           K DISK
     F                                     RENAME(RCALEN:CALEN)
     FFSOWSCHJ  IF   E           K DISK
     FFPRODCD   IF   E           K DISK
      *
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      * PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      * RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      * SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ****************
      *   LDA        *
      ****************
     D                UDS
     D  LFILE                 11     20
     D  LPRTR                100    109
     D  LFORM                110    119
     D  LCOPY                120    121  0
     D  LJOBQ                122    122
     D  LHOLD                123    126
     D  LSAVE                127    130
     D  LCANCL               133    133
      *? Function Prototypes
    ?D/COPY QFunctDefn,QCMDEXC
      *? Fields
     D  Command        S            256A   inz(*Blanks)
      ***********************
      ** START HERE        **
      ***********************
     C     RSTART        TAG
     C                   Z-ADD     0             TAG#
     C                   MOVE      *BLANKS       LCANCL
     C                   SETOFF                                       1020
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   READ      SCRNA                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
      ** CHECK TAG#
     C     TAG#          CHAIN     FTRAY                              10
     C   10              GOTO      NXTA
      ** IF HERE INPUT OK SHOW TAG INFO
     C     MINKEY        KLIST
     C                   KFLD                    TRITEM
     C                   KFLD                    TRSIZE
     C     MINKEY        CHAIN     FMINVT                             90
     C     JOBKEY        KLIST
     C                   KFLD                    TRSCYM
     C                   KFLD                    TRJOB#
     C     JOBKEY        CHAIN     FSOWSCHJ                           90
     C                   Z-ADD     TRORDT        ##CYMD
     C                   CALL      '@DTCNV'
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##MDY             6 0          DATE MMDDYY
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##MDY         RDYDAT
     C     CALKEY        KLIST
     C                   KFLD                    CLCENT
     C                   KFLD                    CLYEAR
     C                   KFLD                    CLWEEK
     C                   KFLD                    CL#Y
     C                   MOVEL     TRSCYW        CLCENT
     C                   MOVEL     TRSCYW        WRK40             4 0
     C                   MOVE      WRK40         CLYEAR
     C                   MOVE      TRSCYW        CLWEEK
     C                   Z-ADD     1             CL#Y
     C     CALKEY        CHAIN     FCALEX                             90
     C                   Z-ADD     CLDATE        SOWDAT
     C                   MOVEL     TRSCYW        SYEAR
     C                   MOVE      TRSCYW        SWEEK
     C                   MOVEL     TRACYW        RYEAR
     C                   MOVE      TRACYW        RWEEK
     C     SOASOW        CHAIN     FCALENCY                           90
     C                   Z-ADD     CLDATE        ASOWD
     C                   MOVE      *BLANKS       PCDESC
     C     TRREAS        IFGT      *BLANKS
     C     TRREAS        CHAIN     FPRODCD                            91
     C                   END
      ** GET BEG AND END TAG NUMBER.
     C     TRYKEY        KLIST
     C                   KFLD                    TRSCYW
     C                   KFLD                    TRJOB#
     C     TRYKEY        SETLL     FTRAYJ
     C                   Z-ADD     0             BEGTAG
     C     NXTTRY        TAG
     C     TRYKEY        READE     FTRAYJ                                 91
     C   91              GOTO      ENDTRY
     C     BEGTAG        IFLE      0
     C                   Z-ADD     TRTAG#        BEGTAG
     C                   END
     C                   Z-ADD     TRTAG#        ENDTAG
     C                   GOTO      NXTTRY
     C     ENDTRY        TAG
     C                   WRITE     SCRNB
     C                   READ      SCRNB                                  90
      ** CHECK F KEYS
     C   KF              GOTO      RSTART
     C   KC
     COR KG              DO
     C                   MOVEL     'X'           LCANCL
     C                   GOTO      END
     C                   ENDDO
     C   KE              DO
      /Free
         Exec SQL // Drop Temp File
           DROP TABLE QTEMP/FCART;
         Exec SQL // Drop Temp File
           CREATE TABLE QTEMP/FCART LIKE FCART;
         Exec SQL // Copy all Tag entries
           INSERT INTO QTEMP/FCART
           ( SELECT * FROM fcart WHERE CTTAG# = :TAG# );
         Command = 'RUNQRY QRYFILE((QTEMP/FCART)) OUTTYPE(*DISPLAY)';
         QCmdExc(Command:%Len(%Trim(Command)));
      /End-Free
     C                   ENDDO
     C                   GOTO      RSTART
      ** END PROGRAM
     C     END           TAG
     C                   SETON                                        LR
