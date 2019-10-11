      *--------------------------------------------------------------
      *
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- CRTINV
      **PROGRAMMER---------- REP
      **APPLICATION--------- ITEM Creation
      *
     FFMINVTPF  IP   E           K DISK
     F                                     RENAME(RMINVT:MASTKY)
     FFMINSER   IF   E           K DISK
     FFSERIES   IF   E           K DISK
     FFSERPRC   IF   E           K DISK
     FFMINVT    O  A E           K DISK
0015 D AD3             S              1    DIM(30)                                               CH0
      *
0076 D                 DS                                                       CH0021
0063 D  DES                    1     30                                         CH0021
     D                                     DIM(30)                                               CH0
0063 D  SVDES1                 1     30                                         CH0021
      *
0076 D                 DS                                                       CH0021
0063 D  ITEM                   1      4  0 INZ(0)                               CH0021
0063 D  IMITEM                 1     12                                         CH0021
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
      *
     IMASTKY
     I                                          IMITEM        L1
      ****************
      *   START HERE *
      ****************
     C*          ITEM      IFLT 2101
     C*                    GOTO END
     C*                    ENDIF
     C     *INL1         IFEQ      *ON
     C                   MOVE      IMITEM        L1ITEM           12
     C                   MOVEL     IMLOOK        L1LOOK           15
     C                   MOVEL     IMDES1        SVDES1           30
     C                   EXSR      CLRITM
     C     SERKEY        CHAIN     FMINSER                            99
     C     *IN99         IFEQ      *OFF                                                        ARC38
     C                   MOVEL     L1ITEM        IMITEM
     C     MINKEY        CHAIN     FSERIES                            98
     C     *IN98         IFEQ      *OFF                                                        ARC38
     C     PRCKEY        CHAIN     FSERPRC                            97
     C     *IN97         IFEQ      *OFF                                                        ARC38
     C     SPPRC1        IFNE      *ZERO                                                       ARC38
     C                   Z-ADD     SPPRC1        IMSEL1                                        ARC38
     C                   END                                                                   ARC38
     C     SPPRC1        IFEQ      *ZERO                                                       ARC38
     C     SPPRC2        IFNE      *ZERO                                                       ARC38
     C                   Z-ADD     SPPRC2        IMSEL1                                        ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C     SPPRC1        IFEQ      *ZERO                                                       ARC38
     C     SPPRC2        IFEQ      *ZERO                                                       ARC38
     C     SPPRC3        IFNE      *ZERO                                                       ARC38
     C                   Z-ADD     SPPRC3        IMSEL1                                        ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C                   EXSR      MOV@01                                                      ARC38
     C                   WRITE     RMINVT                                                      ARC38
     C                   END                                                                   ARC38
     C                   END                                                                   ARC38
     C*          END       TAG                                            ARC380
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
      * ?                                                  ?
      * ?KLIST for file - FMINSER Library - *LIBL     ?
      *
     C     SERKEY        KLIST
     C                   KFLD                    L1ITEM
      * ?                                                  ?
      * ?KLIST for file - FSERIES Library - *LIBL     ?
      *
     C     MINKEY        KLIST
     C                   KFLD                    ISCODE
      * ?                                                  ?
      * ?KLIST for file - FSERPRC Library - *LIBL     ?
      *
     C     PRCKEY        KLIST
     C                   KFLD                    SEVND
     C                   KFLD                    ISCODE
     C                   ENDSR
      *******************************************
      ** MOVE DATA INTO FIELDS BEFORE OUTPUT   **
      *******************************************
     C     MOV@01        BEGSR
     C                   MOVE      'A'           IMSTAT
     C                   MOVE      'SED'         IMSIZE
     C                   Z-ADD     1             IMCOMP
     C                   EXSR      GETDES
     C                   MOVEL     DESC          IMDES1
     C                   MOVEL     'M '          IMPUOM
     C                   MOVEL     'M '          IMBPUM
     C                   MOVE      'Y'           IMTXBL
     C                   MOVE      'Y'           IMTCD1
     C                   MOVE      'N'           IMTCD2
     C                   MOVE      'N'           IMTCD3
     C                   MOVE      'N'           IMLOTC
     C                   MOVE      'N'           IMPRPL
     C                   MOVE      'N'           IMDSHF
     C                   MOVE      'N'           IMBOOK
     C                   MOVEL     '72'          IMPCL1
     C                   MOVEL     '72'          IMCYCD
     C                   Z-ADD     30500000      IMMERC
     C                   Z-ADD     40500000      IMCOGS
     C                   Z-ADD     12000000      IMINVN
     C                   MOVEL     L1LOOK        IMLOOK
     C                   ENDSR
      *******************************************
      ** CLEARDRECORD DATA                     **
      *******************************************
     C     CLRITM        BEGSR
     C                   MOVE      ' '           IMSTAT
     C                   MOVE      '   '         IMSIZE
     C                   MOVE      '   '         IMWHSE
     C                   Z-ADD     *ZEROS        IMCOMP
     C                   MOVE      *BLANKS       IMBIN#
     C                   MOVE      *BLANKS       IMDES1
     C                   MOVE      *BLANKS       IMDES2
     C                   MOVE      *BLANKS       IMSUOM
     C                   MOVE      *BLANKS       IM3UOM
     C                   MOVE      *BLANKS       IMPUOM
     C                   Z-ADD     *ZEROS        IMMULT
     C                   Z-ADD     *ZEROS        IMMUL2
     C                   Z-ADD     *ZEROS        IMUWGT
     C                   Z-ADD     *ZEROS        IMUCST
     C                   Z-ADD     *ZEROS        IMLCST
     C                   Z-ADD     *ZEROS        IMSEL1
     C                   Z-ADD     *ZEROS        IMSEL2
     C                   Z-ADD     *ZEROS        IMSEL3
     C                   Z-ADD     *ZEROS        IMSEL4
     C                   Z-ADD     *ZEROS        IMSEL5
     C                   Z-ADD     *ZEROS        IMBCS1
     C                   Z-ADD     *ZEROS        IMBCS2
     C                   Z-ADD     *ZEROS        IMBCS3
     C                   Z-ADD     *ZEROS        IMBCS4
     C                   Z-ADD     *ZEROS        IMBCS5
     C                   Z-ADD     *ZEROS        IMQLB1
     C                   Z-ADD     *ZEROS        IMQLB2
     C                   Z-ADD     *ZEROS        IMQLB3
     C                   Z-ADD     *ZEROS        IMQLB4
     C                   Z-ADD     *ZEROS        IMQLB5
     C                   Z-ADD     *ZEROS        IMDIS1
     C                   Z-ADD     *ZEROS        IMDIS2
     C                   Z-ADD     *ZEROS        IMDIS3
     C                   Z-ADD     *ZEROS        IMDIS4
     C                   Z-ADD     *ZEROS        IMDIS5
     C                   MOVE      ' '           IMTXBL
     C                   MOVE      ' '           IMTCD1
     C                   MOVE      ' '           IMTCD2
     C                   MOVE      ' '           IMTCD3
     C                   Z-ADD     *ZEROS        IMFET$
     C                   Z-ADD     *ZEROS        IMVEND
     C                   Z-ADD     *ZEROS        IMSDST
     C                   MOVE      ' '           IMPTYP
     C                   MOVE      ' '           IMBMFL
     C                   Z-ADD     *ZEROS        IMQTSO
     C                   MOVE      ' '           IMPPFG
     C                   MOVE      ' '           IMLOTC
     C                   MOVEL     '  '          IMPCL1
     C                   MOVEL     '  '          IMPCL2
     C                   MOVEL     '  '          IMPCL3
     C                   Z-ADD     *ZEROS        IM#ORD
     C                   Z-ADD     *ZEROS        IMDTLO
     C                   Z-ADD     *ZEROS        IMQEOQ
     C                   Z-ADD     *ZEROS        IMQREO
     C                   Z-ADD     *ZEROS        IMLEAD
     C                   Z-ADD     *ZEROS        IMCOMM
     C                   Z-ADD     *ZEROS        IMQTOH
     C                   Z-ADD     *ZEROS        IMQ2OH
     C                   Z-ADD     *ZEROS        IMQ3OH
     C                   Z-ADD     *ZEROS        IMQTOO
     C                   Z-ADD     *ZEROS        IMQTAL
     C                   Z-ADD     *ZEROS        IMALC2
     C                   Z-ADD     *ZEROS        IMALC3
     C                   Z-ADD     *ZEROS        IMQTAV
     C                   Z-ADD     *ZEROS        IMQTA2
     C                   Z-ADD     *ZEROS        IMQTA3
     C                   Z-ADD     *ZEROS        IMQTBO
     C                   Z-ADD     *ZEROS        IMQMTD
     C                   Z-ADD     *ZEROS        IMQM01
     C                   Z-ADD     *ZEROS        IMQM02
     C                   Z-ADD     *ZEROS        IMQM03
     C                   Z-ADD     *ZEROS        IMQM04
     C                   Z-ADD     *ZEROS        IMQM05
     C                   Z-ADD     *ZEROS        IMQM06
     C                   Z-ADD     *ZEROS        IMQM07
     C                   Z-ADD     *ZEROS        IMQM08
     C                   Z-ADD     *ZEROS        IMQM09
     C                   Z-ADD     *ZEROS        IMQM10
     C                   Z-ADD     *ZEROS        IMQM11
     C                   Z-ADD     *ZEROS        IMQM12
     C                   Z-ADD     *ZEROS        IMQM13
     C                   Z-ADD     *ZEROS        IM$MTD
     C                   Z-ADD     *ZEROS        IM$M01
     C                   Z-ADD     *ZEROS        IM$M02
     C                   Z-ADD     *ZEROS        IM$M03
     C                   Z-ADD     *ZEROS        IM$M04
     C                   Z-ADD     *ZEROS        IM$M05
     C                   Z-ADD     *ZEROS        IM$M06
     C                   Z-ADD     *ZEROS        IM$M07
     C                   Z-ADD     *ZEROS        IM$M08
     C                   Z-ADD     *ZEROS        IM$M09
     C                   Z-ADD     *ZEROS        IM$M10
     C                   Z-ADD     *ZEROS        IM$M11
     C                   Z-ADD     *ZEROS        IM$M12
     C                   Z-ADD     *ZEROS        IM$M13
     C                   Z-ADD     *ZEROS        IMCMTD
     C                   Z-ADD     *ZEROS        IMCM01
     C                   Z-ADD     *ZEROS        IMCM02
     C                   Z-ADD     *ZEROS        IMCM03
     C                   Z-ADD     *ZEROS        IMCM04
     C                   Z-ADD     *ZEROS        IMCM05
     C                   Z-ADD     *ZEROS        IMCM06
     C                   Z-ADD     *ZEROS        IMCM07
     C                   Z-ADD     *ZEROS        IMCM08
     C                   Z-ADD     *ZEROS        IMCM09
     C                   Z-ADD     *ZEROS        IMCM10
     C                   Z-ADD     *ZEROS        IMCM11
     C                   Z-ADD     *ZEROS        IMCM12
     C                   Z-ADD     *ZEROS        IMCM13
     C                   Z-ADD     *ZEROS        IMDTLS
     C                   Z-ADD     *ZEROS        IMMREC
     C                   Z-ADD     *ZEROS        IMMADJ
     C                   Z-ADD     *ZEROS        IMISSU
     C                   Z-ADD     *ZEROS        IMQPHY
     C                   Z-ADD     *ZEROS        IMQPH2
     C                   Z-ADD     *ZEROS        IMQPH3
     C                   Z-ADD     *ZEROS        IMBPOH
     C                   Z-ADD     *ZEROS        IMCSOH
     C                   MOVEL     '  '          IMCYCD
     C                   MOVEL     '    '        IMLIST
     C                   Z-ADD     *ZEROS        IMDTLA
     C                   Z-ADD     *ZEROS        IMTIME
     C                   MOVE      *BLANKS       IMUSER
     C                   MOVE      *BLANKS       IMCDFL
     C                   MOVE      *BLANKS       IMBOOK
     C                   MOVE      *BLANKS       IMVITM
     C                   Z-ADD     *ZEROS        IMMERC
     C                   Z-ADD     *ZEROS        IMCOGS
     C                   Z-ADD     *ZEROS        IMINVN
     C                   MOVE      *BLANKS       IMLOOK
     C                   MOVE      *BLANKS       IMCWTF
     C                   MOVE      *BLANKS       IMPRPL
     C                   Z-ADD     *ZEROS        IMCUBE
     C                   Z-ADD     *ZEROS        IMFCST
     C                   Z-ADD     *ZEROS        IMLBS#
     C                   MOVE      *BLANKS       IMDSHF
     C                   MOVE      *BLANKS       IMLHST
     C                   Z-ADD     *ZEROS        IMQPH#
     C                   Z-ADD     *ZEROS        IM3CS1
     C                   Z-ADD     *ZEROS        IM3CS2
     C                   Z-ADD     *ZEROS        IM3CS3
     C                   Z-ADD     *ZEROS        IM3CS4
     C                   Z-ADD     *ZEROS        IM3CS5
     C                   MOVE      *BLANKS       IMCNSF
     C                   Z-ADD     *ZEROS        IMBD1
     C                   Z-ADD     *ZEROS        IMBD2
     C                   Z-ADD     *ZEROS        IMBD3
     C                   Z-ADD     *ZEROS        IMBD4
     C                   Z-ADD     *ZEROS        IMED1
     C                   Z-ADD     *ZEROS        IMED2
     C                   Z-ADD     *ZEROS        IMED3
     C                   Z-ADD     *ZEROS        IMED4
     C                   Z-ADD     *ZEROS        IMWG1
     C                   Z-ADD     *ZEROS        IMWG2
     C                   Z-ADD     *ZEROS        IMWG3
     C                   Z-ADD     *ZEROS        IMWG4
     C                   MOVE      *BLANKS       IMSOWC
     C                   MOVE      *BLANKS       IMTRYC
     C                   MOVE      *BLANKS       IMLOC
     C                   Z-ADD     *ZEROS        IM#SED
     C                   MOVE      *BLANKS       IMTPSW
     C                   MOVE      *BLANKS       IMMSCX
     C                   MOVE      *BLANKS       IMDES3
     C                   MOVE      *BLANKS       IMDES4
     C                   Z-ADD     *ZEROS        IMROYL
     C                   MOVE      *BLANKS       IMFTAB
     C                   Z-ADD     *ZEROS        IMWKAV
     C                   MOVE      *BLANKS       IMFRSZ
     C                   MOVE      *BLANKS       IMALTP
     C                   MOVE      *BLANKS       IMORDD
     C                   Z-ADD     *ZEROS        IMSOPR
     C                   ENDSR
      *******************************************
      ** FORMAT DESCRIPTION FIELD              **
      *******************************************
     C     GETDES        BEGSR
0122 C                   MOVE      *BLANKS       DESC                                          CH002
0122 C                   MOVEA     *BLANKS       AD3(1)                                        CH002
0123 C                   MOVEA     DES(1)        AD3(1)                                        CH002
0124 C                   Z-ADD     1             Y                 2 0                         CH002
0125 C                   Z-ADD     1             Z                 2 0                         CH002
0125 C                   Z-ADD     1             NUMB              1 0                         CH002
0126 C     AGN           TAG                                                                   CH002
0126 C     AGN1          TAG                                                                   CH002
0125 C                   MOVE      NUMB          ANUMB             1                           CH002
0127 C     DES(Y)        COMP      ANUMB                              8383                     CH002
0129 C   83              ADD       1             NUMB                                          CH002
0130 C   83NUMB          IFEQ      9                                                           CH002
0130 C                   GOTO      NEXT                                                        CH002
0130 C                   END                                                                   CH002
0130 C   83              GOTO      AGN1                                                        CH002
0126 C     NEXT          TAG                                                                   CH002
0128 C   83              Z-ADD     Y             Z                                             CH002
0128 C   83Y             IFEQ      25                                                          CH002
0130 C   83              GOTO      NONUM                                                       CH002
0130 C                   END                                                                   CH002
0129 C   83Y             ADD       1             Y                                             CH002
0125 C   83              Z-ADD     1             NUMB              1 0                         CH002
0130 C   83              GOTO      AGN                                                         CH002
0126 C     NONUM         TAG                                                                   CH002
0133 C                   MOVEA     *BLANKS       AD3(Z)                                        CH002
0133 C                   MOVEA     ' -SEED'      AD3(Z)                                        CH002
0135 C                   MOVEA     AD3           DESC             30                           CH002
     C                   ENDSR
