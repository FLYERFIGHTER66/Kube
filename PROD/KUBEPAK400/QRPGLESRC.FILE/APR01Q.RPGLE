      *--------------------------------------------------------------
      *
      *  COPYRIGHT EFD ENTERPRISES, INC.    1999
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
      *PROGRAM NAME-------- APR01Q
      *SYSTEM-------------- ACCOUNTS PAYABLE
      *APPLICATION--------- VENDOR INQUIRY
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      *
     FAPR01QFM  CF   E             WORKSTN
     F                                     DEVID(WSID)
     FFMVEND    IF   E           K DISK
     FFMTERM    IF   E           K DISK
     FFVENDCM   IF   E           K DISK
      *
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      *  PROGRAM NAME
     D  PROGID                 1     10
      *  RUN LIBRARY
     D  RLIBR                 81     90
      *  USER I.D.
     D  USERID               254    261
      *  SOURCE LIBRARY
     D  SLIBR                314    323
      *
     D                UDS
     D  LCO                    1      2  0
      *
     C     *ENTRY        PLIST
     C                   PARM                    CO                2 0
     C                   PARM                    VEND              6 0
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C                   MOVEL     CO            VCO               2 0
     C                   MOVEL     VEND          VVEND
      *
     C     VVEND         IFGT      0
     C                   GOTO      GTVND
     C                   END
      *
     C     RSTRTA        TAG
      *
     C                   SETOFF                                       44
     C                   EXSR      CLRIT
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       09
     C                   SETOFF                                       101112
     C                   SETOFF                                       20
     C                   READ      SCRNA                                  90
      *
     C   KM              CALL      'APC110CL'
     C   KC
     COR KM
     COR KG              SETON                                        LR
     C   KC
     COR KM
     COR KG              GOTO      END
      *
     C     VVEND         IFEQ      0
     C     VALPHA        ANDGT     *BLANKS
     C                   Z-ADD     VCO           VMCOMP            2 0
     C                   MOVEL     VALPHA        VMLOOK
     C                   CALL      'LKVENDOR'
     C                   PARM                    VMLOOK
     C                   PARM                    VMCOMP
     C                   PARM                    VMVEND
     C                   PARM                    VMNAME
     C                   MOVEL     *BLANKS       VALPHA
     C                   MOVEL     *BLANKS       VMLOOK
     C                   Z-ADD     VMVEND        VVEND
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C     VVEND         IFGT      0
     C     VALPHA        ANDGT     *BLANKS
     C                   SETON                                        1011
     C   10
     CAN 11              GOTO      NXTA
     C                   ENDIF
      * TRY VENDOR NUMBER
     C     GTVND         TAG
     C     VVEND         CHAIN     FMVEND                             90
     C   90              SETON                                        1012
     C   10
     CAN 12              GOTO      NXTA
      *
      *
     C     RSTRTB        TAG
     C     VVEND         CHAIN     FVENDCM                            88
     C     VMTMCD        CHAIN     FMTERM                             90
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       0945
     C                   READ      SCRNB                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
      *
      * F1 = GOTO PRIMARY CONTACT SCREEN
      *
     C   KA              GOTO      RSTRTE
      *
      * F4 = GOTO PURCHASE DATE SCREEN
      *
     C   KD              GOTO      RSTRTC
      *
     C     NOCHK         TAG
      *
     C                   GOTO      RSTRTA
      *
     C     RSTRTC        TAG
     C                   WRITE     SCRNC
     C                   READ      SCRNC                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C*  KB                GOTO RSTRTB
     C                   GOTO      RSTRTB
      *
     C     RSTRTE        TAG
     C                   SETON                                        89
     C                   WRITE     SCRNE
     C                   SETOFF                                       98
     C                   Z-ADD     0             CNT               2 0
     C                   READ      SCRNE                                  90
      *
     C   KC
     COR KG              SETON                                        LR
     C   KC
     COR KG              GOTO      END
     C   KF              EXSR      CLRIT
     C   KF              GOTO      RSTRTA
      *
     C                   GOTO      RSTRTB
      *
     C     END           TAG
      *
      **********
      * CLRIT  *
      **********
      *
     C     CLRIT         BEGSR
     C                   SETOFF                                       515253
     C                   MOVE      *ZEROS        VVEND
     C                   MOVE      *BLANKS       VALPHA
     C                   MOVE      *BLANKS       VMNAME
     C                   MOVE      *BLANKS       VMLOOK
     C                   MOVE      *BLANKS       VMADD2
     C                   MOVE      *BLANKS       VMADD3
     C                   MOVEL     *BLANKS       VMADD4
     C                   MOVEL     *BLANKS       VMCITY
     C                   MOVEL     *BLANKS       VMSTST
     C                   MOVEL     *BLANKS       VMZIPD
     C                   MOVEL     *BLANKS       VMCOUN
     C                   MOVE      *BLANKS       VMTYPE
     C                   MOVE      *BLANKS       VMTXID
     C                   MOVEL     *BLANKS       VMTMCD
     C                   Z-ADD     *ZEROS        VMCRLM
     C                   Z-ADD     *ZEROS        VMCONM
     C                   Z-ADD     *ZEROS        VMGLAC
     C                   MOVE      *BLANKS       VMPTTL
     C                   MOVE      *BLANKS       VMFNAM
     C                   MOVE      *BLANKS       VMLNAM
     C                   MOVE      *BLANKS       VMBTTL
     C                   MOVE      *BLANKS       VMEML
     C                   MOVE      *BLANKS       VMMVPC
     C                   MOVE      *BLANKS       VMCDUP
     C                   MOVE      *BLANKS       VMFLAG
     C                   MOVE      *BLANKS       VMSUMM
     C                   MOVE      *BLANKS       VMTXCD
     C                   MOVE      *BLANKS       VMWIRE
     C                   MOVE      *BLANKS       VMVCON
     C                   MOVE      *BLANKS       VMMSG
     C                   Z-ADD     *ZEROS        VMPHON
     C                   Z-ADD     *ZEROS        VMFAX
      *
     C     ECLR          ENDSR
      *
