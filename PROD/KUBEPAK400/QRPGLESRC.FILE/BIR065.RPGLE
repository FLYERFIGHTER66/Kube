      *--------------------------------------------------------------
      *
      *  EFD ENTERPRISES, INC.    1996
      *
      *       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
      *       EFD ENTERPRIS   ALL RIGHTS RESERVED.  THE
      *       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
      *       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
      *       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
      *       BY EXPRESS WRITTEN PERMISSION OF
      *            EFD ENTERPRISES INC.  215-643-5352
      *
      *--------------------------------------------------------------
      **PROGRAM NAME-------- BIR065
      **COMPANY------------- EFD ENTERPRISE'S INC.
      **SYSTEM-------------- GREENHOUSE MANAGEMENT
      **APPLICATION--------- MASTER FILE MAINTENANCE
      **DESCRIPTION--------- MAINTAIN QTY DISCOUNT BY PC. 3 RECORDS    DS
      **
      *
      *            CHANGE--DATE-------DESCRIPTION
      * 4/23/98 EFD ADD STANDING ORDER PRICE.
      *
     FBIR065FM  CF   E             WORKSTN
     FFQDISC    UF A E           K DISK
     FFQDISCO   UF A E           K DISK
     FFMUSER    IF   E           K DISK
     FFMDEPT    IF   E           K DISK
     FFMINVTP3  IF   E           K DISK
     FFLKITM    UF A E           K DISK
      *
      ***********************
      * PROG DATA STRUCTURE *
      ***********************
     D                SDS
      ** PROGRAM NAME
     D  PROGID                 1     10                                         ARC380
      ** RUN LIBRARY
     D  RLIBR                 81     90                                         ARC380
      * USER I.D.
     D  USERID               254    263                                         ARC380
      ** SOURCE LIBRARY
     D  SLIBR                314    323                                         ARC380
      ********************
      * PROGRAM MAINLINE *
      ********************
     C     1000000000    MULT      10            LIMIT            12 1
     C                   SUB       .1            LIMIT
     C     RSTRTA        TAG
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     *BLANKS       QCDESC
     C                   SETOFF                                       212223
     C                   SETOFF                                       242526
     C     NXTA          TAG
     C                   WRITE     SCRNA
     C                   SETOFF                                       101112
     C                   SETOFF                                       133020
     C                   SETOFF                                       6162
     C                   Z-ADD     0             COUNT             2 0
     C                   READ      SCRNA                                  90
     C   KM              CALL      'BIR165CL'
     C   KC
     COR KM
     COR KG              GOTO      END
      *
     C                   MOVEL     VPRCL         TST1              1
     C     TST1          IFEQ      '?'
     C     TST1          OREQ      '/'
     C                   CALL      'LKDISC'
     C                   PARM                    QCLOC
     C                   PARM                    QCPCL3
     C                   PARM                    QCDESC
     C                   MOVEL     *BLANKS       VPRCL
     C                   MOVEL     QCPCL3        VPRCL
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C                   SETOFF                                       202122
     C                   SETOFF                                       2324
     C                   SETOFF                                       6162
     C     VACT          COMP      'A'                                262621     ADD CODE
     C   26VACT          COMP      'C'                                262622     CHANGE/UPDATE
     C   26VACT          COMP      'D'                                262623     DELETE
     C   26VACT          COMP      'I'                                262624     INQUIRY
     C   26              SETON                                          20
     C   26              GOTO      NXTA
      *
     C     VPRCL         IFEQ      *BLANKS
     C                   SETON                                        11
     C                   GOTO      NXTA
     C                   ENDIF
     C     KEYC          KLIST
     C                   KFLD                    QCLOC
     C                   KFLD                    VPRCL
     C     KEYC          CHAIN     FQDISCO                            97
     C  N97              UNLOCK    FQDISCO
     C     KEYC          CHAIN     FQDISC                             91
      *
     C  N91VACT          IFEQ      'A'
     C                   SETON                                        1061
     C                   GOTO      NXTA
     C                   ENDIF
      *
     C   91VACT          IFNE      'A'
     C                   SETON                                        1062
     C                   GOTO      NXTA
     C                   ENDIF
      * INQUIRY ONLY RELEASE RECORD
     C  N91VACT          IFEQ      'I'
     C                   UNLOCK    FQDISC
     C                   WRITE     SCRNI
     C                   READ      SCRNI                                  90
     C                   GOTO      RSTRTA
     C                   ENDIF
      *
     C     NXTB          TAG
     C                   WRITE     SCRNB
     C                   SETOFF                                       303132
     C                   SETOFF                                       333435
     C                   SETOFF                                       363738
     C                   SETOFF                                       395051
     C                   SETOFF                                       525354
     C                   SETOFF                                       555657
     C                   SETOFF                                       5859
     C                   SETOFF                                       909177
     C                   READ      SCRNB                                  90
      *
     C   KB              DO
     C                   EXSR      BLDOVR
     C     KEYC          CHAIN     FQDISC                             91
     C                   GOTO      NXTB
     C                   ENDDO
     C   KC
     COR KG              GOTO      END
     C   KF              GOTO      RSTRTA
      ** CHECK DESCRIPTION
     C                   SETOFF                                       10
     C     QCDESC        IFLE      *BLANKS
     C                   SETON                                        10
     C                   GOTO      NXTB
     C                   END
      ** CHECK TYPE 1=LINE ONLY 2=ENTIRE ORDER
     C                   SETOFF                                       12
     C     QCDTYP        IFNE      1
     C     QCDTYP        ANDNE     2
     C                   SETON                                        12
     C                   GOTO      NXTB
     C                   END
      *
      * QTY 1
      *
     C     QCPQN1        IFEQ      *ZEROS
     C                   SETON                                        30
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPCT1        IFEQ      *ZEROS
     C     QCPC$1        ANDEQ     *ZEROS
     C                   SETON                                        31
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPCT1        IFGT      *ZEROS
     C     QCPC$1        ANDGT     *ZEROS
     C                   SETON                                        31
     C                   GOTO      NXTB
     C                   ENDIF
     C     QCPQN1        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 2
      *
     C  N77QCPQN1        IFNE      LIMIT
     C     QCPQN2        ANDLE     QCPQN1
     C                   SETON                                        32
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN2        IFGT      *ZEROS
     C     QCPCT2        ANDEQ     *ZEROS
     C     QCPC$2        ANDEQ     *ZEROS
     C                   SETON                                        33
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN2        IFGT      *ZEROS
     C     QCPCT2        ANDGT     *ZEROS
     C     QCPC$2        ANDGT     *ZEROS
     C                   SETON                                        33
     C                   GOTO      NXTB
     C                   ENDIF
     C     QCPQN2        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 3
      *
     C  N77QCPQN2        IFNE      LIMIT
     C     QCPQN3        ANDLE     QCPQN2
     C                   SETON                                        34
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN3        IFGT      *ZEROS
     C     QCPCT3        ANDEQ     *ZEROS
     C     QCPC$3        ANDEQ     *ZEROS
     C                   SETON                                        35
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN3        IFGT      *ZEROS
     C     QCPCT3        ANDGT     *ZEROS
     C     QCPC$3        ANDGT     *ZEROS
     C                   SETON                                        35
     C                   GOTO      NXTB
     C                   ENDIF
      *
      * QTY 4
      *
     C  N77QCPQN3        IFNE      LIMIT
     C     QCPQN4        ANDLE     QCPQN3
     C                   SETON                                        36
     C                   GOTO      NXTB
     C                   ENDIF
     C     QCPQN3        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
     C     QCPQN4        IFGT      *ZEROS
     C     QCPCT4        ANDEQ     *ZEROS
     C     QCPC$4        ANDEQ     *ZEROS
     C                   SETON                                        37
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN4        IFGT      *ZEROS
     C     QCPCT4        ANDGT     *ZEROS
     C     QCPC$4        ANDGT     *ZEROS
     C                   SETON                                        37
     C                   GOTO      NXTB
     C                   ENDIF
     C     QCPQN4        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 5
      *
     C  N77QCPQN4        IFNE      LIMIT
     C     QCPQN5        ANDLE     QCPQN4
     C                   SETON                                        38
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN5        IFGT      *ZEROS
     C     QCPCT5        ANDEQ     *ZEROS
     C     QCPC$5        ANDEQ     *ZEROS
     C                   SETON                                        39
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN5        IFGT      *ZEROS
     C     QCPCT5        ANDGT     *ZEROS
     C     QCPC$5        ANDGT     *ZEROS
     C                   SETON                                        39
     C                   GOTO      NXTB
     C                   ENDIF
     C     QCPQN5        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 6
      *
     C  N77QCPQN5        IFNE      LIMIT
     C     QCPQN6        ANDLE     QCPQN5
     C                   SETON                                        50
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN6        IFGT      *ZEROS
     C     QCPCT6        ANDEQ     *ZEROS
     C     QCPC$6        ANDEQ     *ZEROS
     C                   SETON                                        51
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN6        IFGT      *ZEROS
     C     QCPCT6        ANDGT     *ZEROS
     C     QCPC$6        ANDGT     *ZEROS
     C                   SETON                                        51
     C                   GOTO      NXTB
     C                   ENDIF
     C     QCPQN6        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 7
      *
     C  N77QCPQN6        IFGT      0
     C     QCPQN6        ANDNE     LIMIT
     C     QCPQN7        ANDLE     QCPQN6
     C                   SETON                                        52
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN7        IFGT      *ZEROS
     C     QCPCT7        ANDEQ     *ZEROS
     C     QCPC$7        ANDEQ     *ZEROS
     C                   SETON                                        53
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN7        IFGT      *ZEROS
     C     QCPCT7        ANDGT     *ZEROS
     C     QCPC$7        ANDGT     *ZEROS
     C                   SETON                                        53
     C                   GOTO      NXTB
     C                   ENDIF
     C     QCPQN7        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 8
      *
     C  N77QCPQN7        IFGT      0
     C     QCPQN7        ANDNE     LIMIT
     C     QCPQN8        ANDLE     QCPQN7
     C                   SETON                                        54
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN8        IFGT      *ZEROS
     C     QCPCT8        ANDEQ     *ZEROS
     C     QCPC$8        ANDEQ     *ZEROS
     C                   SETON                                        55
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN8        IFGT      *ZEROS
     C     QCPCT8        ANDGT     *ZEROS
     C     QCPC$8        ANDGT     *ZEROS
     C                   SETON                                        55
     C                   GOTO      NXTB
     C                   ENDIF
     C     QCPQN8        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 9
      *
     C  N77QCPQN8        IFGT      0
     C     QCPQN8        ANDNE     LIMIT
     C     QCPQN9        ANDLE     QCPQN8
     C                   SETON                                        56
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN9        IFGT      *ZEROS
     C     QCPCT9        ANDEQ     *ZEROS
     C     QCPC$9        ANDEQ     *ZEROS
     C                   SETON                                        57
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN9        IFGT      *ZEROS
     C     QCPCT9        ANDGT     *ZEROS
     C     QCPC$9        ANDGT     *ZEROS
     C                   SETON                                        57
     C                   GOTO      NXTB
     C                   ENDIF
     C     QCPQN9        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 10
      *
     C  N77QCPQN9        IFGT      0
     C     QCPQN9        ANDNE     LIMIT
     C     QCPQN0        ANDNE     LIMIT
     C                   SETON                                        58
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN0        IFGT      *ZEROS
     C     QCPCT0        ANDEQ     *ZEROS
     C     QCPC$0        ANDEQ     *ZEROS
     C                   SETON                                        59
     C                   GOTO      NXTB
     C                   ENDIF
      *
     C     QCPQN0        IFGT      *ZEROS
     C     QCPCT0        ANDGT     *ZEROS
     C     QCPC$0        ANDGT     *ZEROS
     C                   SETON                                        59
     C                   GOTO      NXTB
     C                   ENDIF
      *
      * OUTPUT RECORD
      *
     C                   MOVEL     VPRCL         QCPCL3
     C***                  MOVELUSDEPT    QCLOC
     C                   MOVEL     USERID        QCUSER
     C                   Z-ADD     TDATE         QCDTLA
     C                   Z-ADD     TIMOD         QCTIME
     C     VACT          IFEQ      'A'
     C                   WRITE     RQDISC
     C                   ENDIF
     C     VACT          IFEQ      'C'
     C                   UPDATE    RQDISC
     C                   ENDIF
     C     VACT          IFEQ      'D'
     C                   DELETE    RQDISC
     C                   ENDIF
      ** IF HERE SOMETHING MAY HAVE CHANGED UPDATE LKITM FILE
     C                   EXSR      UPDLKI
     C                   GOTO      RSTRTA
      *
     C     END           TAG
     C                   SETON                                        LR
      ***********************
      ** UPDATE LKITM FILE **
      ***********************
     C     UPDLKI        BEGSR
     C     KEYC          SETLL     FMINVTP3
     C     NXTLKI        TAG
     C     KEYC          READE     FMINVTP3                               90
     C   90              GOTO      ENDLKI
     C     KEY18         KLIST
     C                   KFLD                    IMITEM
     C                   KFLD                    IMSIZE
     C                   KFLD                    IMWHSE
      ** GET RECORD
     C     KEY18         CHAIN     FLKITM                             78
      ** TAKE CARE OF DELETES
     C     IMSTAT        IFEQ      'D'
     C     IMPRPL        OREQ      'N'
     C  N78              DELETE    RLKITM
     C                   END
      ** NOW ALL OTHERS
     C                   Z-ADD     0             #OPRC             9 2
     C                   Z-ADD     0             OIQDDC            4 2
     C                   Z-ADD     0             OHBLCU            6 0
     C                   Z-ADD     0             OHORD#            6 0
     C                   Z-ADD     1             QTYORD            8 1
     C                   MOVEL     '1'           PRICD             1
     C                   MOVEL     'N'           OICTCD            1
     C                   MOVEL     'N'           OIFRQD            1
     C                   Z-ADD     0             VOLDSC            4 2
     C                   CALL      '#PRICE'
     C                   PARM                    OHBLCU
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    IMBPUM
     C                   PARM                    QTYORD
     C                   PARM                    PRICD
     C                   PARM                    #OPRC
     C                   PARM                    OIQDDC
     C                   PARM                    OICTCD
     C                   PARM                    VOLDSC
     C                   PARM                    OIFRQD
     C                   PARM                    OHORD#
     C                   PARM                    IMORDD
     C                   Z-ADD     #OPRC         LKUPRI
      ** GET DESCRIPTION
     C                   MOVEL     *BLANKS       DESCO            60
     C                   MOVEL     'I'           TYPE              1
     C                   CALL      'GETDESC'
     C                   PARM                    IMITEM
     C                   PARM                    IMSIZE
     C                   PARM                    IMWHSE
     C                   PARM                    TYPE
     C                   PARM                    DESCO
     C                   MOVEL     DESCO         LKDES1
     C                   MOVEL     IMITEM        LKITEM
     C                   MOVEL     IMSIZE        LKSIZE
     C                   MOVEL     IMWHSE        LKWHSE
     C                   Z-ADD     IMCOMP        LKCOMP
     C                   MOVEL     IMITEM        LKITEM
     C                   Z-ADD     IMQTOH        LKPOH
     C                   Z-ADD     IMQTAL        LKPAL
      ** GET NEXT LATER
     C   78              Z-ADD     0             LKNOH
     C   78              Z-ADD     0             LKNAL
     C                   MOVEL     IMLOOK        LKLOOK
     C   78              WRITE     RLKITM
     C  N78              UPDATE    RLKITM
     C                   GOTO      NXTLKI
     C     ENDLKI        ENDSR
      *
      ***********************
      ** OVERRIDE ROUTINE  **
      ***********************
     C     BLDOVR        BEGSR
     C     KEYC          CHAIN     FQDISCO                            97
     C  N97              DO
     C                   Z-ADD     QCDTBG        ##CYMD
     C                   EXSR      @DTCNV
     C                   Z-ADD     ##MDY         BEGDAT
     C                   Z-ADD     QCDTEN        ##CYMD
     C                   EXSR      @DTCNV
     C                   Z-ADD     ##MDY         ENDDAT
     C                   ENDDO
     C   97              DO
     C                   Z-ADD     0             BEGDAT
     C                   Z-ADD     0             ENDDAT
     C                   ENDDO
     C     NXTOVR        TAG
     C                   WRITE     SCRNBD
     C                   SETOFF                                       202123
     C                   SETOFF                                       303132
     C                   SETOFF                                       333435
     C                   SETOFF                                       363738
     C                   SETOFF                                       395051
     C                   SETOFF                                       525354
     C                   SETOFF                                       555657
     C                   SETOFF                                       5859
     C                   SETOFF                                       909177
     C                   READ      SCRNBD                                 90
      *
     C   KC
     COR KG              DO
     C                   SETON                                        LR
     C                   GOTO      ENDOVR
     C                   ENDDO
     C   KF              GOTO      ENDOVR
      ** CHECK DESCRIPTION
     C                   SETOFF                                       10
     C     QCDESC        IFLE      *BLANKS
     C                   SETON                                        10
     C                   GOTO      NXTOVR
     C                   END
      ** CHECK TYPE 1=LINE ONLY 2=ENTIRE ORDER
     C                   SETOFF                                       12
     C     QCDTYP        IFNE      1
     C     QCDTYP        ANDNE     2
     C                   SETON                                        12
     C                   GOTO      NXTOVR
     C                   END
      ** CHECK BASED ON R=REQ DATE O=ORDER DATE
     C                   SETOFF                                       13
     C     QCDTCD        IFNE      'O'
     C     QCDTCD        ANDNE     'R'
     C                   SETON                                        13
     C                   GOTO      NXTOVR
     C                   END
      ** CHECK DATES   BEGIN
     C     BEGDAT        IFLE      0
     C                   SETON                                        20
     C                   GOTO      NXTOVR
     C                   END
     C                   Z-ADD     BEGDAT        ##MDY
     C                   EXSR      @DT@A1
     C   90              SETON                                        20
     C   90              GOTO      NXTOVR
     C                   Z-ADD     ##CYMD        QCDTBG
      *
      ** CHECK DATES   ENDING
     C     ENDDAT        IFLE      0
     C                   SETON                                        23
     C                   GOTO      NXTOVR
     C                   END
     C                   Z-ADD     ENDDAT        ##MDY
     C                   EXSR      @DT@A1
     C   90              SETON                                        23
     C   23              GOTO      NXTOVR
     C                   Z-ADD     ##CYMD        QCDTEN
     C     QCDTBG        IFGT      QCDTEN
     C                   SETON                                        202123
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
      * QTY 1
      *
     C     QCPQN1        IFEQ      *ZEROS
     C                   SETON                                        30
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPCT1        IFEQ      *ZEROS
     C     QCPC$1        ANDEQ     *ZEROS
     C                   SETON                                        31
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPCT1        IFGT      *ZEROS
     C     QCPC$1        ANDGT     *ZEROS
     C                   SETON                                        31
     C                   GOTO      NXTOVR
     C                   ENDIF
     C     QCPQN1        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 2
      *
     C  N77QCPQN1        IFNE      LIMIT
     C     QCPQN2        ANDLE     QCPQN1
     C                   SETON                                        32
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN2        IFGT      *ZEROS
     C     QCPCT2        ANDEQ     *ZEROS
     C     QCPC$2        ANDEQ     *ZEROS
     C                   SETON                                        33
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN2        IFGT      *ZEROS
     C     QCPCT2        ANDGT     *ZEROS
     C     QCPC$2        ANDGT     *ZEROS
     C                   SETON                                        33
     C                   GOTO      NXTOVR
     C                   ENDIF
     C     QCPQN2        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 3
      *
     C  N77QCPQN2        IFNE      LIMIT
     C     QCPQN3        ANDLE     QCPQN2
     C                   SETON                                        34
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN3        IFGT      *ZEROS
     C     QCPCT3        ANDEQ     *ZEROS
     C     QCPC$3        ANDEQ     *ZEROS
     C                   SETON                                        35
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN3        IFGT      *ZEROS
     C     QCPCT3        ANDGT     *ZEROS
     C     QCPC$3        ANDGT     *ZEROS
     C                   SETON                                        35
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
      * QTY 4
      *
     C  N77QCPQN3        IFNE      LIMIT
     C     QCPQN4        ANDLE     QCPQN3
     C                   SETON                                        36
     C                   GOTO      NXTOVR
     C                   ENDIF
     C     QCPQN3        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
     C     QCPQN4        IFGT      *ZEROS
     C     QCPCT4        ANDEQ     *ZEROS
     C     QCPC$4        ANDEQ     *ZEROS
     C                   SETON                                        37
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN4        IFGT      *ZEROS
     C     QCPCT4        ANDGT     *ZEROS
     C     QCPC$4        ANDGT     *ZEROS
     C                   SETON                                        37
     C                   GOTO      NXTOVR
     C                   ENDIF
     C     QCPQN4        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 5
      *
     C  N77QCPQN4        IFNE      LIMIT
     C     QCPQN5        ANDLE     QCPQN4
     C                   SETON                                        38
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN5        IFGT      *ZEROS
     C     QCPCT5        ANDEQ     *ZEROS
     C     QCPC$5        ANDEQ     *ZEROS
     C                   SETON                                        39
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN5        IFGT      *ZEROS
     C     QCPCT5        ANDGT     *ZEROS
     C     QCPC$5        ANDGT     *ZEROS
     C                   SETON                                        39
     C                   GOTO      NXTOVR
     C                   ENDIF
     C     QCPQN5        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 6
      *
     C  N77QCPQN5        IFNE      LIMIT
     C     QCPQN6        ANDLE     QCPQN5
     C                   SETON                                        50
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN6        IFGT      *ZEROS
     C     QCPCT6        ANDEQ     *ZEROS
     C     QCPC$6        ANDEQ     *ZEROS
     C                   SETON                                        51
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN6        IFGT      *ZEROS
     C     QCPCT6        ANDGT     *ZEROS
     C     QCPC$6        ANDGT     *ZEROS
     C                   SETON                                        51
     C                   GOTO      NXTOVR
     C                   ENDIF
     C     QCPQN6        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 7
      *
     C  N77QCPQN6        IFGT      0
     C     QCPQN6        ANDNE     LIMIT
     C     QCPQN7        ANDLE     QCPQN6
     C                   SETON                                        52
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN7        IFGT      *ZEROS
     C     QCPCT7        ANDEQ     *ZEROS
     C     QCPC$7        ANDEQ     *ZEROS
     C                   SETON                                        53
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN7        IFGT      *ZEROS
     C     QCPCT7        ANDGT     *ZEROS
     C     QCPC$7        ANDGT     *ZEROS
     C                   SETON                                        53
     C                   GOTO      NXTOVR
     C                   ENDIF
     C     QCPQN7        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 8
      *
     C  N77QCPQN7        IFGT      0
     C     QCPQN7        ANDNE     LIMIT
     C     QCPQN8        ANDLE     QCPQN7
     C                   SETON                                        54
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN8        IFGT      *ZEROS
     C     QCPCT8        ANDEQ     *ZEROS
     C     QCPC$8        ANDEQ     *ZEROS
     C                   SETON                                        55
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN8        IFGT      *ZEROS
     C     QCPCT8        ANDGT     *ZEROS
     C     QCPC$8        ANDGT     *ZEROS
     C                   SETON                                        55
     C                   GOTO      NXTOVR
     C                   ENDIF
     C     QCPQN8        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 9
      *
     C  N77QCPQN8        IFGT      0
     C     QCPQN8        ANDNE     LIMIT
     C     QCPQN9        ANDLE     QCPQN8
     C                   SETON                                        56
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN9        IFGT      *ZEROS
     C     QCPCT9        ANDEQ     *ZEROS
     C     QCPC$9        ANDEQ     *ZEROS
     C                   SETON                                        57
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN9        IFGT      *ZEROS
     C     QCPCT9        ANDGT     *ZEROS
     C     QCPC$9        ANDGT     *ZEROS
     C                   SETON                                        57
     C                   GOTO      NXTOVR
     C                   ENDIF
     C     QCPQN9        IFEQ      LIMIT
     C                   SETON                                        77
     C                   ENDIF
      *
      * QTY 10
      *
     C  N77QCPQN9        IFGT      0
     C     QCPQN9        ANDNE     LIMIT
     C     QCPQN0        ANDNE     LIMIT
     C                   SETON                                        58
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN0        IFGT      *ZEROS
     C     QCPCT0        ANDEQ     *ZEROS
     C     QCPC$0        ANDEQ     *ZEROS
     C                   SETON                                        59
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
     C     QCPQN0        IFGT      *ZEROS
     C     QCPCT0        ANDGT     *ZEROS
     C     QCPC$0        ANDGT     *ZEROS
     C                   SETON                                        59
     C                   GOTO      NXTOVR
     C                   ENDIF
      *
      * OUTPUT RECORD
      *
     C                   MOVEL     VPRCL         QCPCL3
     C***                  MOVELUSDEPT    QCLOC
     C                   MOVEL     USERID        QCUSER
     C                   Z-ADD     TDATE         QCDTLA
     C                   Z-ADD     TIMOD         QCTIME
     C   97              WRITE     RQDISCO
     C  N97              UPDATE    RQDISCO
     C     ENDOVR        ENDSR
      *
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
     C     USERID        CHAIN     FMUSER                             90
     C   90              MOVEL     '999'         USDEPT
     C     USDEPT        CHAIN     FMDEPT                             90
     C                   MOVEL     DESHFR        QCLOC
     C                   ENDSR
      ********************************************************************@DT@A1
      * VALIDATE DATES. INDICATOR 90 IS ON IF ERROR. 91-92 ALWAYS SETOF.  @DT@A1
      * YY GE 00  MM 01-12 DAY 01-28/29/30/31                             @DT@A1
      * ##MDY INPUT DATE MMDDYY                                           @DT@A1
      * ##CYMD OUTPUT DATE CYYMMDD IF DATE IS OK. ELSE ZERO.              @DT@A1
      * C IDENTIFIES 20 OR 21 CENTURY. C=0 FOR YY 70-99. C=1 FOR YY 00-69.@DT@A1
     C     @DT@A1        BEGSR                                                                 @DT@A
     C                   MOVE      ##MDY         #03A              3 0          MYY            @DT@A
     C                   MOVEL     0             #03A                           CYY            @DT@A
     C                   MOVEL     ##MDY         #04               4 0          MMDD           @DT@A
     C                   MOVEL     ##MDY         #02B              2 0          MM             @DT@A
     C                   MOVE      #04           #02C              2 0          DD             @DT@A
     C                   Z-ADD     ##MDY         ##MDY             6 0  90      YY IS NEGATIVE @DT@A
     C  N90              Z-ADD     #02B          #02               2 0    90    MM LT 01 ERROR @DT@A
     C  N90#02B          COMP      12                                 90        MM GT 12 ERROR @DT@A
     C  N90#02C          COMP      01                                   90      DD LT 01 ERROR @DT@A
     C  N90#02C          COMP      31                                 90  91    DD GT OR EQ 31 @DT@A
     C     #02B          COMP      07                                 92        MM 08-12       @DT@A
     C   921             ADD       #02B          #02                            MAKE MM ODD    @DT@A
     C     #02           DIV       2             #02                                           @DT@A
     C                   MVR                     #02                  92        31 DAY MONTH   @DT@A
     C   91
     CANN92              SETON                                        90        MM EVEN DD 31  @DT@A
     C     #02B          COMP      02                                     91    FEB            @DT@A
     C  N91                                                                                    @DT@A
     COR 90              GOTO      @DT@AX                                                      @DT@A
     C     #03A          DIV       4             #03               3 0          JUST FOR MVR   @DT@A
     C                   MVR                     #02                      91    LEAP YEAR      @DT@A
     C     #02C          COMP      29                                 90  92    DD GT 29 ERROR @DT@A
     C  N91
     CAN 92              SETON                                        90        NO LEAP DD 29  @DT@A
     C     @DT@AX        TAG                                                    GOOD DATE      @DT@A
     C                   MOVEL     #03A          ##CYMD            7 0          CYY----        @DT@A
     C                   MOVE      #04           ##CYMD                         CYYMMDD        @DT@A
     C     #03A          COMP      070                                  91                     @DT@A
     C   91              MOVEL     1             ##CYMD                         21ST CENTURY   @DT@A
     C   90              Z-ADD     0             ##CYMD                         ERROR          @DT@A
     C                   SETOFF                                       9192                     @DT@A
     C                   ENDSR                                                                 @DT@A
      ********************************************************************@DT@A1
      * ##CYMD INPUT DATE CYYMMDD                                         @DT@A1
      * ##MDY OUTPUT DATE MMDDYY IF VALID  90 ON IF ##CYMD = 0            @DT@A1
     C     @DTCNV        BEGSR                                                                 @DT@A
     C                   Z-ADD     0             ##MDY             6 0                         @DT@A
     C                   Z-ADD     ##CYMD        ##CYMD            7 0  9090                   @DT@A
     C   90              GOTO      END@CN                                                      @DT@A
     C                   MOVEL     ##CYMD        ##CYR             3 0
     C                   MOVE      ##CYR         ##MDY
     C                   MOVE      ##CYMD        ##MMDD            4 0
     C                   MOVEL     ##MMDD        ##MDY
     C     END@CN        ENDSR                                                                 @DT@A
