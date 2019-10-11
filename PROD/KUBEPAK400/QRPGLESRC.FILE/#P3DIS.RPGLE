      ** CHANGE LOG:
      * 1/27/99 EFD ALLOW FOR OVER-RIDE FILE
      *
      *  #P3DIS - ITEM PRICING ROUTINE
      *
     FFMINVT    IF   E           K DISK
     FFIORDR    UF   E           K DISK
     FFHORDR    IF   E           K DISK
     FFQDISC    IF   E           K DISK
     FFQDISCO   IF   E           K DISK
      ** IORDR SUMMARY ARRAYS
     D P3C             S              2    DIM(20)                              P.C. 3
     D P3Q             S             11  1 DIM(20)                              QTY.
      ** MINVT ARRAYS
     D IP1             S              9  4 DIM(5)                               PRICE U/M 1
      ** FPDISC ARRAYS
     D QQN             S             11  1 DIM(10) ASCEND                       PC QTY
     D QCT             S              5  2 DIM(10)                              PC DISC %
     D QCT4            S              5  4 DIM(10)                              PC DISC 4 DEC
     D QC$             S              9  4 DIM(10)                              PC DISC $
     IRMINVT
     I              IMSEL1                      IP1(1)
     I              IMSEL2                      IP1(2)
     I              IMSEL3                      IP1(3)
     I              IMSEL4                      IP1(4)
     I              IMSEL5                      IP1(5)
     IRQDISC
      ** QUANTITIES
     I              QCPQN1                      QQN(1)
     I              QCPQN2                      QQN(2)
     I              QCPQN3                      QQN(3)
     I              QCPQN4                      QQN(4)
     I              QCPQN5                      QQN(5)
     I              QCPQN6                      QQN(6)
     I              QCPQN7                      QQN(7)
     I              QCPQN8                      QQN(8)
     I              QCPQN9                      QQN(9)
     I              QCPQN0                      QQN(10)
      ** PERCENT 5.2
     I              QCPCT1                      QCT(1)
     I              QCPCT2                      QCT(2)
     I              QCPCT3                      QCT(3)
     I              QCPCT4                      QCT(4)
     I              QCPCT5                      QCT(5)
     I              QCPCT6                      QCT(6)
     I              QCPCT7                      QCT(7)
     I              QCPCT8                      QCT(8)
     I              QCPCT9                      QCT(9)
     I              QCPCT0                      QCT(10)
      ** PRICE 5.4
     I              QCPC$1                      QC$(1)
     I              QCPC$2                      QC$(2)
     I              QCPC$3                      QC$(3)
     I              QCPC$4                      QC$(4)
     I              QCPC$5                      QC$(5)
     I              QCPC$6                      QC$(6)
     I              QCPC$7                      QC$(7)
     I              QCPC$8                      QC$(8)
     I              QCPC$9                      QC$(9)
     I              QCPC$0                      QC$(10)
      *
     IRQDISCO
      ** QUANTITIES
     I              QCPQN1                      QQN(1)
     I              QCPQN2                      QQN(2)
     I              QCPQN3                      QQN(3)
     I              QCPQN4                      QQN(4)
     I              QCPQN5                      QQN(5)
     I              QCPQN6                      QQN(6)
     I              QCPQN7                      QQN(7)
     I              QCPQN8                      QQN(8)
     I              QCPQN9                      QQN(9)
     I              QCPQN0                      QQN(10)
      ** PERCENT 5.2
     I              QCPCT1                      QCT(1)
     I              QCPCT2                      QCT(2)
     I              QCPCT3                      QCT(3)
     I              QCPCT4                      QCT(4)
     I              QCPCT5                      QCT(5)
     I              QCPCT6                      QCT(6)
     I              QCPCT7                      QCT(7)
     I              QCPCT8                      QCT(8)
     I              QCPCT9                      QCT(9)
     I              QCPCT0                      QCT(10)
      ** PRICE 5.4
     I              QCPC$1                      QC$(1)
     I              QCPC$2                      QC$(2)
     I              QCPC$3                      QC$(3)
     I              QCPC$4                      QC$(4)
     I              QCPC$5                      QC$(5)
     I              QCPC$6                      QC$(6)
     I              QCPC$7                      QC$(7)
     I              QCPC$8                      QC$(8)
     I              QCPC$9                      QC$(9)
     I              QCPC$0                      QC$(10)
      *
      ****************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    CMCUST            6 0
     C                   PARM                    OHORD#            6 0
     C                   PARM                    PRICD             1
     C                   MOVEL     PRICD         P                 1 0
     C     P             IFLE      0
     C                   Z-ADD     1             P
     C                   END
     C                   MOVE      *BLANKS       P3C
     C                   Z-ADD     0             P3Q
     C                   Z-ADD     0             LSTX
     C     OHORD#        CHAIN     FHORDR                             90
     C                   Z-ADD     OHDTOR        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        ORCYMD            7 0
     C                   Z-ADD     OHDTRQ        ##MDY
     C                   CALL      '@DT@A1'
     C                   PARM                    ##MDY             6 0          DATE MDY
     C                   PARM                    ##CYMD            7 0          DATE CYYMMDD
     C                   PARM                    ##ERR             1            ERROR IF = Y
     C                   Z-ADD     ##CYMD        RQCYMD            7 0
     C     OHORD#        SETLL     FIORDR
     C     NXTIN         TAG
     C     OHORD#        READE     FIORDR                                 90
     C   90              GOTO      ENDIN
     C     OIITYP        IFNE      ' '
     C     OIBPUM        ORNE      OIBLUM
     C                   GOTO      NXTIN
     C                   END
     C     MINKEY        KLIST
     C                   KFLD                    OIITEM
     C                   KFLD                    OISIZE
     C                   KFLD                    OIWHSE
     C     MINKEY        CHAIN     FMINVT                             91
     C   91              GOTO      NXTIN
     C     IMPCL3        IFLE      *BLANKS
     C                   GOTO      NXTIN
     C                   END
     C     DISKEY        KLIST
     C                   KFLD                    OIWHSE
     C                   KFLD                    IMPCL3
     C     DISKEY        CHAIN     FQDISCO                            92
     C   92              GOTO      NOOVER
     C  N92QCDTCD        IFEQ      'O'
     C     ORCYMD        IFLT      QCDTBG
     C     ORCYMD        ORGT      QCDTEN
     C                   GOTO      NOOVER
     C                   ENDIF
     C                   ELSE
     C     RQCYMD        IFLT      QCDTBG
     C     RQCYMD        ORGT      QCDTEN
     C                   GOTO      NOOVER
     C                   ENDIF
     C                   END
     C                   GOTO      USOVER
     C     NOOVER        TAG
     C     DISKEY        CHAIN     FQDISC                             92
     C   92              GOTO      NXTIN
     C     USOVER        TAG
      ** IF NOT FOR ENTIRE ORDER DO NOT USE
     C     QCDTYP        IFNE      2
     C                   GOTO      NXTIN
     C                   END
     C                   Z-ADD     1             X                 5 0
     C     IMPCL3        LOOKUP    P3C(X)                                 94
     C   94              ADD       OIQORD        P3Q(X)
     C  N94              DO
     C                   ADD       1             LSTX              2 0
     C                   Z-ADD     LSTX          X
     C                   Z-ADD     OIQORD        P3Q(X)
     C                   MOVEL     IMPCL3        P3C(X)
     C                   ENDDO
     C                   GOTO      NXTIN
     C     ENDIN         TAG
      ** SEE IF WE FOUND ANY
     C     LSTX          IFLE      0
     C                   GOTO      END
     C                   END
      ** IF HERE SOME ITEMS QUALIFY
     C     OHORD#        SETLL     FIORDR
     C     NXTOUT        TAG
     C     OHORD#        READE     FIORDR                                 90
     C   90              GOTO      END
     C     OIITYP        IFNE      ' '
     C     OIOVER        OREQ      'Y'
     C     OIBPUM        ORNE      OIBLUM
     C                   GOTO      NXTOUT
     C                   END
     C     MINKEY        CHAIN     FMINVT                             91
     C   91              GOTO      NXTOUT
     C     IMPCL3        IFLE      *BLANKS
     C***        IP1,1     ORGT .00
     C                   GOTO      NXTOUT
     C                   END
      **
     C     DISKEY        CHAIN     FQDISCO                            92
     C   92              GOTO      NOOVR1
     C  N92QCDTCD        IFEQ      'O'
     C     ORCYMD        IFLT      QCDTBG
     C     ORCYMD        ORGT      QCDTEN
     C                   GOTO      NOOVR1
     C                   ENDIF
     C                   ELSE
     C     RQCYMD        IFLT      QCDTBG
     C     RQCYMD        ORGT      QCDTEN
     C                   GOTO      NOOVR1
     C                   ENDIF
     C                   END
     C                   GOTO      USOVR1
     C     NOOVR1        TAG
     C     DISKEY        CHAIN     FQDISC                             92
     C   92              GOTO      NXTOUT
     C     USOVR1        TAG
     C                   Z-ADD     1             X
     C     IMPCL3        LOOKUP    P3C(X)                                 91
     C   91              DO
      ** SEE IF PRICE 1 >0 AND QTY=1 IF SO USE AS BASE PRICE+SEL1(MINVT
     C     QQN(1)        IFEQ      1
     C     QC$(1)        ANDGT     .00
     C     IP1(P)        ADD       QC$(1)        #PRC              9 4
     C                   ELSE
     C     IP1(P)        IFGT      0.00
     C                   Z-ADD     IP1(P)        #PRC              9 4
     C                   ELSE
     C                   Z-ADD     IP1(P)        #PRC              9 4
     C                   ENDIF                                                  IP1,P>0.00
     C                   ENDIF                                                  QQN,1=1
      ** NOW CHECK FOR DISCOUNT
     C                   Z-ADD     1             X1                5 0
     C     P3Q(X)        LOOKUP    QQN(X1)                              9090
     C   90QCT(X1)       IFGT      .00
     C                   MOVE      QCT(X1)       #DISC             5 2
     C                   EXSR      CALDIS
     C                   ELSE
     C     IP1(P)        ADD       QC$(X1)       #PRC
     C                   END                                                    QCT,X1>0
     C                   ENDDO                                                  N98 DO
     C                   Z-ADD     #PRC          OIUPRI
     C                   Z-ADD     #DISC         OIQDDC
     C     OIQORD        MULT(H)   OIUPRI        OIEXT$
     C                   UPDATE    RIORDR
     C                   GOTO      NXTOUT
     C     END           TAG
     C*                    SETON                     LR
     C                   MOVEA     '0'           *IN
     C                   UNLOCK    FIORDR
     C                   RETURN
      ** CALC DISCOUNT PERCENT
     C     CALDIS        BEGSR
     C     #DISC         IFGT      0.0
     C     #DISC         DIV(H)    100           #DPC              5 4
     C     1.0000        SUB       #DPC          #DCPA             5 4
     C                   MULT(H)   #DCPA         #PRC
     C                   Z-ADD     0             #DISC
     C                   END
     C                   ENDSR
