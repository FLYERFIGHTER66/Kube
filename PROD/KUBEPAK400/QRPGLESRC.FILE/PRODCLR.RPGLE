0002 H*--------------------------------------------------------------
0003 H*
0004 H*** COPYRIGHT <C> BY EFD ENTERPRISES INC.     1998
0005 H*
0006 H*       THIS MATERIAL WAS PREPARED BY AND IS PROPRIETARY TO
0007 H*       E F D ENTERPRISES INC. ALL RIGHTS RESERVED.  THE
0008 H*       METHODS AND TECHNIQUES DESCRIBED HEREIN ARE CONSIDERED
0009 H*       TRADE SECRETS AND/OR CONFIDENTIAL.  REPRODUCTION OR
0010 H*       DISTRIBUTION, IN WHOLE OR IN PART, IS FORBIDDEN EXCEPT
0011 H*       BY EXPRESS WRITTEN PERMISSION OF
0012 H*       EFD ENTERPRISES INC.  215-657-8212
0013 H*
0014 H*--------------------------------------------------------------
0017 F*
0018 F***          THIS PROGRAM PRINTS THE SPACE ALLOCATION REPORT
0019 F*            USING THE QUERY FILE, FOR SELECTED PRODUCT
0020 F*            CLASSES.       EFD 12/04/98
0021 F*
     F*     CHANGES LOG:                                               E
     F*
0022 F*   1/08/03  CAB  CHANGED LENGHT FROM 132 TO 120 IN ORDER TO
0023 F*            PRINT ON  P1.
0024 F*
0027 FPRODCOUT  IF   E           K DISK
     F                                     RENAME(PRODCOUT:RPRODI)
0027 FFMINVT    IF   E           K DISK
0027 FFMPRCL    IF   E           K DISK
0027 FFMCOMP    IF   E           K DISK
     FFPTABLE   IF   F  203     2AIDISK    KEYLOC(2)
     FFCALEN    IF   E           K DISK
0029 F*****REPORT  O   F     132     OF     PRINTER
CAB  FREPORT    O    F  120        PRINTER OFLIND(*INOF)

     D  Order          S              7S 0
     D  ToSow          S              7S 0

0031  ** DATE ROUTINE ARRAYS
0001 D #JD             S             03  0 DIM(13) CTDATA PERRCD(13) ASCEND                      @DT
     D #DY             S              3  0 DIM(12) CTDATA PERRCD(12) ASCEND                      @DT
0033 D GS              S              8  2 DIM(52)                              PRD CLS SQ.FT GRM
0034 D TGS             S              8  2 DIM(52)                              TOTAL SQ. FT. GRM
0035 D HS              S              8  2 DIM(52)                              PRD CLS SQ.FT.HLD
     D NS              S              8  2 DIM(52)                              PRD CL PROD HOLD
0036 D THS             S              8  2 DIM(52)                              TOTAL SQ.FT. HOLD
0037 D GF              S              8  0 DIM(52)                              PRD CLS QTY.  GRM
0038 D TGF             S              8  0 DIM(52)                              TOTAL QUANTY. GRM
0039 D HF              S              8  0 DIM(52)                              PRD CLS QTY. .HLD
     D NF              S              8  0 DIM(52)                              PRD LC QTY PROD
0040 D THF             S              8  0 DIM(52)                              TOTAL QUNTY. HOLD
0041 D DP              S              6  0 DIM(52)                              DATES IN MMDDYY
0042 D PT2             S              9  2 DIM(10)                              PRINT ARRAY FOR 2 DE
0043 D PT0             S             10  0 DIM(10)                              PRINT ARRAY FOR NO D
0044 D DSH             S             12    DIM(10)                              PRINT UNDERSCORE
0045 D EQL             S             12    DIM(10)                              PRINT EQUAL
0046 D PLG             S              7  0 DIM(99) ASCEND                       PLUG DATES       BIR
     D BR              S              7  0 DIM(12)                              BEG QTY RANGE
     D EN              S              7  0 DIM(12)                               END QTY RANGE
     D FC              S              5  0 DIM(12)                               FACTOR TO ADD
     D PCT             S              5  2 DIM(12)                               FACTOR %
     D IGB             S              4  0 DIM(4)
     D IGE             S              4  0 DIM(4)
     D IGW             S              2  0 DIM(4)
     D IGB7            S              7  0 DIM(4)                               BEG WKS GERM 7
     D IGE7            S              7  0 DIM(4)                               END WKS GERM 7
     D #BD             S              6  0 DIM(4)
     D #ED             S              6  0 DIM(4)
      ****************
      *   LDA        *
      ****************
     D                UDS
0332 D  PC                     1     40                                         PRODCL
     D                                     DIM(20)                                               PRO
0333 D  CO#                   41     42  0
0334 D  FROM                  43     49  0
0335 D  TO                    50     56  0
     D  JOBQ                  57     57
     D  LCANCL                58     58
     IFPTABLE   NS
      *           PRODN FACTOR TABLE MASTER
     I                                  1    1  PTSTAT
     I                                  2    3  PTABID
     I                                  4   33  PTDESC
     I                                 34   35  PTCTYP
     I                             P   36   83 0BR
     I                             P   84  131 0EN
     I                             P  132  167 0FC
     I                             P  168  203 2PCT
     IRPRODI
     I              OVERFLOW                    OVRF
     I              BREAKLVL                    BREAK
     IRMINVT
     I              IMBD1                       IGB(1)
     I              IMBD2                       IGB(2)
     I              IMBD3                       IGB(3)
     I              IMBD4                       IGB(4)
     I              IMED1                       IGE(1)
     I              IMED2                       IGE(2)
     I              IMED3                       IGE(3)
     I              IMED4                       IGE(4)
     I              IMWG1                       IGW(1)
     I              IMWG2                       IGW(2)
     I              IMWG3                       IGW(3)
     I              IMWG4                       IGW(4)
0336 I*                                                                   PRODCL
0337  *********************
0338 I** READ RECORDS     *
0339 I*********************
0399 C     NXT           TAG
     C                   READ      PRODCOUT                               90
     C   90              GOTO      END
0400 C*
0403 C*
0404 C     IMKEY         KLIST
0405 C                   KFLD                    OIITEM
0405 C                   KFLD                    OISIZE
0406 C     IMKEY         CHAIN     FMINVT                             98
      ** CHECK PROD CLASS
     C     IMPCL1        IFNE      OPCL1
     C     OPCL1         ANDGT     *BLANKS
     C                   EXSR      L2TOT
     C                   MOVE      *BLANKS       OPCL1             2
     C                   ENDIF
     C                   Z-ADD     1             X
     C     IMPCL1        LOOKUP    PC(X)                                  55
     C  N55              GOTO      NXT
     C                   MOVEL     IMPCL1        OPCL1
0407 C**
     C                   EXSR      GETGRM
0409 C                   Z-ADD     IMGERM        TOTGER            2 0
     C     IMGERM        COMP      0                                    9898
     C     IMFTAB        IFLE      *BLANKS
     C                   MOVEL     '01'          IMFTAB
     C                   END
     C     IMFTAB        IFEQ      '00'
     C                   MOVEL     '01'          IMFTAB
     C                   END
     C     IMFTAB        IFNE      '**'
     C     IMFTAB        CHAIN     FPTABLE                            70
     C                   END
0410 C*
0412 C*
0415 C     IMPCL1        CHAIN     FMPRCL                             94
0421 C*
0422 C* MAINLINE CODE
0423 C*
0427 C** GET START WEEK
0428 C                   Z-ADD     1             D                 2 0
0429 C**                   Z-ADDOISOW     ##MDY
     C**                   EXSR @DT@A1
     C                   Z-ADD     OISOW         OISOWX            7 0
0430 C** LOOK AT THE ENTIRE PLUGD ARRAY TO FIND START
0431 C     OISOWX        LOOKUP    PLG(D)                             75  75
0432 C**  NO HIT SKIP RECORD
0433 C  N75              GOTO      NXT
0434 C** IF D IS GREATER THAN ENDAR WE DON'T NEED THIS RECORD
0435 C     D             COMP      ENDAR                              99
0436 C   99              GOTO      NXT
0437 C*
0438 C* S = START WEEK NUMBER
0439 C* T = TOTAL NUMBER OF WEEKS
0440 C*
0441 C** IF D IS LESS THAN STRTAR CALC WHEN TO START AND FOR HOW LONG
0442 C     D             IFLT      STRTAR
0443 C     STRTAR        SUB       D             WK                2 0
0444 C     TOTGER        SUB       WK            T                 2 0  99
0445 C**N99                Z-ADDSTRTAR    S       20
0445 C  N99              Z-ADD     1             S                 2 0
     C   99              GOTO      NXT
0446 C                   END
0447 C*
0448 C** IF D IS GREATER THAN OR EQUAL TO STRTAR
0449 C*
0450 C     D             IFGE      STRTAR
0451 C     D             SUB       STRTAR        WK
0452 C                   Z-ADD     TOTGER        T
0453 C     WK            ADD       1             S
0454 C**         S         COMP #WKS                 99
0455 C                   END
0456 C** IF 99 ON DON'T NEED THIS RECORD
0457 C   99              GOTO      NXT
0458 C** AT THIS POINT ALL THE SAME
0459 C*
0460 C** GET SQUARE FEET NEEDED
     C* ADD GETQTY SUBROUTINE TO ADD FACTOR
     C* TO QUANTITY
     C     IMFTAB        IFNE      '**'
     C                   EXSR      GETQTY
     C                   END
0461 C     IMCUBE        IFGT      0
0462 C     IMCUBE        MULT(H)   LEFT01        SQFT              8 2
0463 C                   ELSE
0464 C     LEFT01        MULT(H)   1.8           SQFT
0465 C                   END
     C***                  EXCPTTEST
0466 C*
0467 C* ADD TO THE ARRAYS
0468 C     T             DOWGT     0
0469 C** ONLY DO TIL END OF SELECTED WEEKS
0470 C     S             IFLE      #WKS
0471 C                   ADD       SQFT          GS(S)
0472 C                   ADD       SQFT          TGS(S)
0473 C                   ADD       LEFT01        GF(S)
0474 C                   ADD       LEFT01        TGF(S)
0475 C                   END
0476 C                   ADD       1             S
0477 C                   SUB       1             T
0478 C     S             IFEQ      53
0479 C                   Z-ADD     0             T
0480 C                   END
0481 C                   END
0482 C** PUT LAST WEEK IN HOLD ARRAY
0483 C     S             IFLE      #WKS
     C*          HSINCL    IFNE 'N'
0484 C                   ADD       SQFT          HS(S)
0486 C                   ADD       LEFT01        HF(S)
     C*                    ELSE
0484 C*                    ADD  SQFT      NS,S
0486 C*                    ADD  LEFT01    NF,S
     C*                    END
0485 C                   ADD       SQFT          THS(S)
0487 C                   ADD       LEFT01        THF(S)
0488 C                   END
     C**                   GOTO END
     C                   GOTO      NXT
0489 C     END           TAG
     C     OPCL1         IFGT      *BLANKS
     C                   EXSR      L2TOT
     C                   END
     C                   EXSR      LRTOT
     C                   SETON                                        LR
      *******************
      * PRINT PC TOTALS *
      ******************
     C     L2TOT         BEGSR
0490 C** PUT TOTALS IN PRINT ARRAYS AND PRINT
0491 C** AT L2 TOTAL TIME
0492 C* A=THE ELEMENT IN ARRAYS WE MOVING FROM
0493 C* X=THE ELEMENT IN ARRAYS WE MOVING TO
0494 C*
0495 C** PRINT PRODUCT CLASS DESCRIPTION
0496 C   OF              EXSR      CHKOF
0497 C                   EXCEPT    PRTPC
0498 C** THESE PRINT THE FIRST 10 ELEMENTS
0499 C** DATE FIELDS
0500 C                   Z-ADD     1             A                 2 0
0501 C                   Z-ADD     1             X                 2 0
0502 C     A             DOUEQ     11
0503 C                   Z-ADD     DP(A)         PT0(X)
0504 C                   ADD       1             A
0505 C                   ADD       1             X
0506 C                   END
0507 C   OF              EXSR      CHKOF
0508 C                   EXCEPT    PRTDT
0509 C** GERMINATE SQ.FT.
0510 C                   Z-ADD     1             A                 2 0
0511 C                   Z-ADD     1             X                 2 0
0512 C     A             DOUEQ     11
0513 C                   Z-ADD     GS(A)         PT2(X)
0514 C                   ADD       1             A
0515 C                   ADD       1             X
0516 C                   END
0517 C*                    EXCPTPRTGS
0518 C** HOLD SQ.FT.
0519 C                   Z-ADD     1             A                 2 0
0520 C                   Z-ADD     1             X                 2 0
0521 C     A             DOUEQ     11
0522 C                   Z-ADD     HS(A)         PT2(X)
0523 C                   ADD       1             A
0524 C                   ADD       1             X
0525 C                   END
0526 C**                   EXCPTPRTHS
0527 C** TOTAL SQ.FT.
0528 C                   Z-ADD     1             A                 2 0
0529 C                   Z-ADD     1             X                 2 0
0530 C     A             DOUEQ     11
0531 C     GS(A)         ADD       HS(A)         PT2(X)
0532 C                   ADD       1             A
0533 C                   ADD       1             X
0534 C                   END
0535 C**                   EXCPTPRTTS
0536 C** GERMINATE UNITS
0537 C                   Z-ADD     1             A                 2 0
0538 C                   Z-ADD     1             X                 2 0
0539 C     A             DOUEQ     11
0540 C                   Z-ADD     GF(A)         PT0(X)
0541 C                   ADD       1             A
0542 C                   ADD       1             X
0543 C                   END
0544 C                   EXCEPT    PRTGF
0545 C** HOLD UNITS
0546 C                   Z-ADD     1             A                 2 0
0547 C                   Z-ADD     1             X                 2 0
0548 C     A             DOUEQ     11
0549 C                   Z-ADD     HF(A)         PT0(X)
0550 C                   ADD       1             A
0551 C                   ADD       1             X
0552 C                   END
0553 C                   EXCEPT    PRTHF
0554 C** TOTAL UNITS.
0555 C                   Z-ADD     1             A                 2 0
0556 C                   Z-ADD     1             X                 2 0
0557 C     A             DOUEQ     11
0558 C     GF(A)         ADD       HF(A)         PT0(X)
0559 C                   ADD       1             A
0560 C                   ADD       1             X
0561 C                   END
0562 C                   EXCEPT    PRTTF
0563 C** CHECK IF MORE WEEKS REQUESTED
0564 C*
0565 C     #WKS          COMP      10                                   8181
0566 C   81              GOTO      ENDL2
0567 C*
0568 C** THESE PRINT THE ELEMENTS 11 THRU 20
0569 C** DATE FIELDS
0570 C                   Z-ADD     11            A                 2 0
0571 C                   Z-ADD     1             X                 2 0
0572 C     X             DOUEQ     11
0573 C                   Z-ADD     DP(A)         PT0(X)
0574 C                   ADD       1             A
0575 C                   ADD       1             X
0576 C                   END
0577 C   OF              EXSR      CHKOF
0578 C                   EXCEPT    PRTDT
0579 C** GERMINATE SQ.FT.
0580 C                   Z-ADD     11            A                 2 0
0581 C                   Z-ADD     1             X                 2 0
0582 C     X             DOUEQ     11
0583 C                   Z-ADD     GS(A)         PT2(X)
0584 C                   ADD       1             A
0585 C                   ADD       1             X
0586 C                   END
0587 C**                   EXCPTPRTGS
0588 C** HOLD SQ.FT.
0589 C                   Z-ADD     11            A                 2 0
0590 C                   Z-ADD     1             X                 2 0
0591 C     X             DOUEQ     11
0592 C                   Z-ADD     HS(A)         PT2(X)
0593 C                   ADD       1             A
0594 C                   ADD       1             X
0595 C                   END
0596 C**                   EXCPTPRTHS
0597 C** TOTAL SQ.FT.
0598 C                   Z-ADD     11            A                 2 0
0599 C                   Z-ADD     1             X                 2 0
0600 C     X             DOUEQ     11
0601 C     GS(A)         ADD       HS(A)         PT2(X)
0602 C                   ADD       1             A
0603 C                   ADD       1             X
0604 C                   END
0605 C**                   EXCPTPRTTS
0606 C** GERMINATE UNITS
0607 C                   Z-ADD     11            A                 2 0
0608 C                   Z-ADD     1             X                 2 0
0609 C     X             DOUEQ     11
0610 C                   Z-ADD     GF(A)         PT0(X)
0611 C                   ADD       1             A
0612 C                   ADD       1             X
0613 C                   END
0614 C                   EXCEPT    PRTGF
0615 C** HOLD UNITS
0616 C                   Z-ADD     11            A                 2 0
0617 C                   Z-ADD     1             X                 2 0
0618 C     X             DOUEQ     11
0619 C                   Z-ADD     HF(A)         PT0(X)
0620 C                   ADD       1             A
0621 C                   ADD       1             X
0622 C                   END
0623 C                   EXCEPT    PRTHF
0624 C** TOTAL UNITS.
0625 C                   Z-ADD     11            A                 2 0
0626 C                   Z-ADD     1             X                 2 0
0627 C     X             DOUEQ     11
0628 C     GF(A)         ADD       HF(A)         PT0(X)
0629 C                   ADD       1             A
0630 C                   ADD       1             X
0631 C                   END
0632 C                   EXCEPT    PRTTF
0633 C** CHECK IF MORE WEEKS REQUESTED
0634 C*
0635 C     #WKS          COMP      20                                   8181
0636 C   81              GOTO      ENDL2
0637 C*
0638 C** THESE PRINT THE ELEMENTS 21 THRU 30
0639 C** DATE FIELDS
0640 C                   Z-ADD     21            A                 2 0
0641 C                   Z-ADD     1             X                 2 0
0642 C     X             DOUEQ     11
0643 C                   Z-ADD     DP(A)         PT0(X)
0644 C                   ADD       1             A
0645 C                   ADD       1             X
0646 C                   END
0647 C   OF              EXSR      CHKOF
0648 C                   EXCEPT    PRTDT
0649 C** GERMINATE SQ.FT.
0650 C                   Z-ADD     21            A                 2 0
0651 C                   Z-ADD     1             X                 2 0
0652 C     X             DOUEQ     11
0653 C                   Z-ADD     GS(A)         PT2(X)
0654 C                   ADD       1             A
0655 C                   ADD       1             X
0656 C                   END
0657 C**                   EXCPTPRTGS
0658 C** HOLD SQ.FT.
0659 C                   Z-ADD     21            A                 2 0
0660 C                   Z-ADD     1             X                 2 0
0661 C     X             DOUEQ     11
0662 C                   Z-ADD     HS(A)         PT2(X)
0663 C                   ADD       1             A
0664 C                   ADD       1             X
0665 C                   END
0666 C**                   EXCPTPRTHS
0667 C** TOTAL SQ.FT.
0668 C                   Z-ADD     21            A                 2 0
0669 C                   Z-ADD     1             X                 2 0
0670 C     X             DOUEQ     11
0671 C     GS(A)         ADD       HS(A)         PT2(X)
0672 C                   ADD       1             A
0673 C                   ADD       1             X
0674 C                   END
0675 C**                   EXCPTPRTTS
0676 C** GERMINATE UNITS
0677 C                   Z-ADD     21            A                 2 0
0678 C                   Z-ADD     1             X                 2 0
0679 C     X             DOUEQ     11
0680 C                   Z-ADD     GF(A)         PT0(X)
0681 C                   ADD       1             A
0682 C                   ADD       1             X
0683 C                   END
0684 C                   EXCEPT    PRTGF
0685 C** HOLD UNITS
0686 C                   Z-ADD     21            A                 2 0
0687 C                   Z-ADD     1             X                 2 0
0688 C     X             DOUEQ     11
0689 C                   Z-ADD     HF(A)         PT0(X)
0690 C                   ADD       1             A
0691 C                   ADD       1             X
0692 C                   END
0693 C                   EXCEPT    PRTHF
0694 C** TOTAL UNITS.
0695 C                   Z-ADD     21            A                 2 0
0696 C                   Z-ADD     1             X                 2 0
0697 C     X             DOUEQ     11
0698 C     GF(A)         ADD       HF(A)         PT0(X)
0699 C                   ADD       1             A
0700 C                   ADD       1             X
0701 C                   END
0702 C                   EXCEPT    PRTTF
0703 C** CHECK IF MORE WEEKS REQUESTED
0704 C*
0705 C     #WKS          COMP      30                                   8181
0706 C   81              GOTO      ENDL2
0707 C*
0708 C** THESE PRINT THE ELEMENTS 31 THRU 40
0709 C** DATE FIELDS
0710 C                   Z-ADD     31            A                 2 0
0711 C                   Z-ADD     1             X                 2 0
0712 C     X             DOUEQ     11
0713 C                   Z-ADD     DP(A)         PT0(X)
0714 C                   ADD       1             A
0715 C                   ADD       1             X
0716 C                   END
0717 C   OF              EXSR      CHKOF
0718 C                   EXCEPT    PRTDT
0719 C** GERMINATE SQ.FT.
0720 C                   Z-ADD     31            A                 2 0
0721 C                   Z-ADD     1             X                 2 0
0722 C     X             DOUEQ     11
0723 C                   Z-ADD     GS(A)         PT2(X)
0724 C                   ADD       1             A
0725 C                   ADD       1             X
0726 C                   END
0727 C**                   EXCPTPRTGS
0728 C** HOLD SQ.FT.
0729 C                   Z-ADD     31            A                 2 0
0730 C                   Z-ADD     1             X                 2 0
0731 C     X             DOUEQ     11
0732 C                   Z-ADD     HS(A)         PT2(X)
0733 C                   ADD       1             A
0734 C                   ADD       1             X
0735 C                   END
0736 C**                   EXCPTPRTHS
0737 C** TOTAL SQ.FT.
0738 C                   Z-ADD     31            A                 2 0
0739 C                   Z-ADD     1             X                 2 0
0740 C     X             DOUEQ     11
0741 C     GS(A)         ADD       HS(A)         PT2(X)
0742 C                   ADD       1             A
0743 C                   ADD       1             X
0744 C                   END
0745 C**                   EXCPTPRTTS
0746 C** GERMINATE UNITS
0747 C                   Z-ADD     31            A                 2 0
0748 C                   Z-ADD     1             X                 2 0
0749 C     X             DOUEQ     11
0750 C                   Z-ADD     GF(A)         PT0(X)
0751 C                   ADD       1             A
0752 C                   ADD       1             X
0753 C                   END
0754 C                   EXCEPT    PRTGF
0755 C** HOLD UNITS
0756 C                   Z-ADD     31            A                 2 0
0757 C                   Z-ADD     1             X                 2 0
0758 C     X             DOUEQ     11
0759 C                   Z-ADD     HF(A)         PT0(X)
0760 C                   ADD       1             A
0761 C                   ADD       1             X
0762 C                   END
0763 C                   EXCEPT    PRTHF
0764 C** TOTAL UNITS.
0765 C                   Z-ADD     31            A                 2 0
0766 C                   Z-ADD     1             X                 2 0
0767 C     X             DOUEQ     11
0768 C     GF(A)         ADD       HF(A)         PT0(X)
0769 C                   ADD       1             A
0770 C                   ADD       1             X
0771 C                   END
0772 C                   EXCEPT    PRTTF
0773 C** END OF TOTAL PRINT WE ONLY PRINT 40 WEEKS MAX
0774 C     ENDL2         TAG
0416 C** ZERO THE PROD. CLASS TOTAL ARRAYS
0417 C                   Z-ADD     0             GS
0418 C                   Z-ADD     0             HS
0419 C                   Z-ADD     0             GF
0420 C                   Z-ADD     0             HF
     C                   ENDSR
      ***********************
      ** PRINT FINAL TOTALS *
      ***********************
     C     LRTOT         BEGSR
0775 C** PUT TOTALS IN PRINT ARRAYS AND PRINT
0776 C** AT LR TOTAL TIME
0777 C* A=THE ELEMENT IN ARRAYS WE MOVING FROM
0778 C* X=THE ELEMENT IN ARRAYS WE MOVING TO
0779 C*
0780 C** PRINT TOTAL HEADING LINE
0781 C                   SETON                                        55
0782 C                   EXCEPT    HEAD
0783 C                   EXCEPT    PRTOT
0784 C** THESE PRINT THE FIRST 10 ELEMENTS
0785 C** DATE FIELDS
0786 C                   Z-ADD     1             A                 2 0
0787 C                   Z-ADD     1             X                 2 0
0788 C     A             DOUEQ     11
0789 C                   Z-ADD     DP(A)         PT0(X)
0790 C                   ADD       1             A
0791 C                   ADD       1             X
0792 C                   END
0793 C                   EXCEPT    PRTDT
0794 C** GERMINATE SQ.FT.
0795 C                   Z-ADD     1             A                 2 0
0796 C                   Z-ADD     1             X                 2 0
0797 C     A             DOUEQ     11
0798 C                   Z-ADD     TGS(A)        PT2(X)
0799 C                   ADD       1             A
0800 C                   ADD       1             X
0801 C                   END
0802 C**                   EXCPTPRTGS
0803 C** HOLD SQ.FT.
0804 C                   Z-ADD     1             A                 2 0
0805 C                   Z-ADD     1             X                 2 0
0806 C     A             DOUEQ     11
0807 C                   Z-ADD     THS(A)        PT2(X)
0808 C                   ADD       1             A
0809 C                   ADD       1             X
0810 C                   END
0811 C**                   EXCPTPRTHS
0812 C** TOTAL SQ.FT.
0813 C                   Z-ADD     1             A                 2 0
0814 C                   Z-ADD     1             X                 2 0
0815 C     A             DOUEQ     11
0816 C     TGS(A)        ADD       THS(A)        PT2(X)
0817 C                   ADD       1             A
0818 C                   ADD       1             X
0819 C                   END
0820 C**                   EXCPTPRTTS
0821 C** GERMINATE UNITS
0822 C                   Z-ADD     1             A                 2 0
0823 C                   Z-ADD     1             X                 2 0
0824 C     A             DOUEQ     11
0825 C                   Z-ADD     TGF(A)        PT0(X)
0826 C                   ADD       1             A
0827 C                   ADD       1             X
0828 C                   END
0829 C                   EXCEPT    PRTGF
0830 C** HOLD UNITS
0831 C                   Z-ADD     1             A                 2 0
0832 C                   Z-ADD     1             X                 2 0
0833 C     A             DOUEQ     11
0834 C                   Z-ADD     THF(A)        PT0(X)
0835 C                   ADD       1             A
0836 C                   ADD       1             X
0837 C                   END
0838 C                   EXCEPT    PRTHF
0839 C** TOTAL UNITS.
0840 C                   Z-ADD     1             A                 2 0
0841 C                   Z-ADD     1             X                 2 0
0842 C     A             DOUEQ     11
0843 C     TGF(A)        ADD       THF(A)        PT0(X)
0844 C                   ADD       1             A
0845 C                   ADD       1             X
0846 C                   END
0847 C                   EXCEPT    PRTTF
0848 C** CHECK IF MORE WEEKS REQUESTED
0849 C*
0850 C     #WKS          COMP      10                                   8181
0851 C   81              GOTO      ENDLR
0852 C*
0853 C** THESE PRINT THE ELEMENTS 11 THRU 20
0854 C** DATE FIELDS
0855 C                   Z-ADD     11            A                 2 0
0856 C                   Z-ADD     1             X                 2 0
0857 C     X             DOUEQ     11
0858 C                   Z-ADD     DP(A)         PT0(X)
0859 C                   ADD       1             A
0860 C                   ADD       1             X
0861 C                   END
0862 C                   EXCEPT    PRTDT
0863 C** GERMINATE SQ.FT.
0864 C                   Z-ADD     11            A                 2 0
0865 C                   Z-ADD     1             X                 2 0
0866 C     X             DOUEQ     11
0867 C                   Z-ADD     TGS(A)        PT2(X)
0868 C                   ADD       1             A
0869 C                   ADD       1             X
0870 C                   END
0871 C**                   EXCPTPRTGS
0872 C** HOLD SQ.FT.
0873 C                   Z-ADD     11            A                 2 0
0874 C                   Z-ADD     1             X                 2 0
0875 C     X             DOUEQ     11
0876 C                   Z-ADD     THS(A)        PT2(X)
0877 C                   ADD       1             A
0878 C                   ADD       1             X
0879 C                   END
0880 C**                   EXCPTPRTHS
0881 C** TOTAL SQ.FT.
0882 C                   Z-ADD     11            A                 2 0
0883 C                   Z-ADD     1             X                 2 0
0884 C     X             DOUEQ     11
0885 C     TGS(A)        ADD       THS(A)        PT2(X)
0886 C                   ADD       1             A
0887 C                   ADD       1             X
0888 C                   END
0889 C**                   EXCPTPRTTS
0890 C** GERMINATE UNITS
0891 C                   Z-ADD     11            A                 2 0
0892 C                   Z-ADD     1             X                 2 0
0893 C     X             DOUEQ     11
0894 C                   Z-ADD     TGF(A)        PT0(X)
0895 C                   ADD       1             A
0896 C                   ADD       1             X
0897 C                   END
0898 C                   EXCEPT    PRTGF
0899 C** HOLD UNITS
0900 C                   Z-ADD     11            A                 2 0
0901 C                   Z-ADD     1             X                 2 0
0902 C     X             DOUEQ     11
0903 C                   Z-ADD     THF(A)        PT0(X)
0904 C                   ADD       1             A
0905 C                   ADD       1             X
0906 C                   END
0907 C                   EXCEPT    PRTHF
0908 C** TOTAL UNITS.
0909 C                   Z-ADD     11            A                 2 0
0910 C                   Z-ADD     1             X                 2 0
0911 C     X             DOUEQ     11
0912 C     TGF(A)        ADD       THF(A)        PT0(X)
0913 C                   ADD       1             A
0914 C                   ADD       1             X
0915 C                   END
0916 C                   EXCEPT    PRTTF
0917 C** CHECK IF MORE WEEKS REQUESTED
0918 C*
0919 C     #WKS          COMP      20                                   8181
0920 C   81              GOTO      ENDLR
0921 C*
0922 C** THESE PRINT THE ELEMENTS 21 THRU 30
0923 C** DATE FIELDS
0924 C                   Z-ADD     21            A                 2 0
0925 C                   Z-ADD     1             X                 2 0
0926 C     X             DOUEQ     11
0927 C                   Z-ADD     DP(A)         PT0(X)
0928 C                   ADD       1             A
0929 C                   ADD       1             X
0930 C                   END
0931 C                   EXCEPT    PRTDT
0932 C** GERMINATE SQ.FT.
0933 C                   Z-ADD     21            A                 2 0
0934 C                   Z-ADD     1             X                 2 0
0935 C     X             DOUEQ     11
0936 C                   Z-ADD     TGS(A)        PT2(X)
0937 C                   ADD       1             A
0938 C                   ADD       1             X
0939 C                   END
0940 C**                   EXCPTPRTGS
0941 C** HOLD SQ.FT.
0942 C                   Z-ADD     21            A                 2 0
0943 C                   Z-ADD     1             X                 2 0
0944 C     X             DOUEQ     11
0945 C                   Z-ADD     THS(A)        PT2(X)
0946 C                   ADD       1             A
0947 C                   ADD       1             X
0948 C                   END
0949 C**                   EXCPTPRTHS
0950 C** TOTAL SQ.FT.
0951 C                   Z-ADD     21            A                 2 0
0952 C                   Z-ADD     1             X                 2 0
0953 C     X             DOUEQ     11
0954 C     TGS(A)        ADD       THS(A)        PT2(X)
0955 C                   ADD       1             A
0956 C                   ADD       1             X
0957 C                   END
0958 C**                   EXCPTPRTTS
0959 C** GERMINATE UNITS
0960 C                   Z-ADD     21            A                 2 0
0961 C                   Z-ADD     1             X                 2 0
0962 C     X             DOUEQ     11
0963 C                   Z-ADD     TGF(A)        PT0(X)
0964 C                   ADD       1             A
0965 C                   ADD       1             X
0966 C                   END
0967 C                   EXCEPT    PRTGF
0968 C** HOLD UNITS
0969 C                   Z-ADD     21            A                 2 0
0970 C                   Z-ADD     1             X                 2 0
0971 C     X             DOUEQ     11
0972 C                   Z-ADD     THF(A)        PT0(X)
0973 C                   ADD       1             A
0974 C                   ADD       1             X
0975 C                   END
0976 C                   EXCEPT    PRTHF
0977 C** TOTAL UNITS.
0978 C                   Z-ADD     21            A                 2 0
0979 C                   Z-ADD     1             X                 2 0
0980 C     X             DOUEQ     11
0981 C     TGF(A)        ADD       THF(A)        PT0(X)
0982 C                   ADD       1             A
0983 C                   ADD       1             X
0984 C                   END
0985 C                   EXCEPT    PRTTF
0986 C** CHECK IF MORE WEEKS REQUESTED
0987 C*
0988 C     #WKS          COMP      30                                   8181
0989 C   81              GOTO      ENDLR
0990 C*
0991 C** THESE PRINT THE ELEMENTS 31 THRU 40
0992 C** DATE FIELDS
0993 C                   Z-ADD     31            A                 2 0
0994 C                   Z-ADD     1             X                 2 0
0995 C     X             DOUEQ     11
0996 C                   Z-ADD     DP(A)         PT0(X)
0997 C                   ADD       1             A
0998 C                   ADD       1             X
0999 C                   END
1000 C                   EXCEPT    PRTDT
1001 C** GERMINATE SQ.FT.
1002 C                   Z-ADD     31            A                 2 0
1003 C                   Z-ADD     1             X                 2 0
1004 C     X             DOUEQ     11
1005 C                   Z-ADD     TGS(A)        PT2(X)
1006 C                   ADD       1             A
1007 C                   ADD       1             X
1008 C                   END
1009 C**                   EXCPTPRTGS
1010 C** HOLD SQ.FT.
1011 C                   Z-ADD     31            A                 2 0
1012 C                   Z-ADD     1             X                 2 0
1013 C     X             DOUEQ     11
1014 C                   Z-ADD     THS(A)        PT2(X)
1015 C                   ADD       1             A
1016 C                   ADD       1             X
1017 C                   END
1018 C**                   EXCPTPRTHS
1019 C** TOTAL SQ.FT.
1020 C                   Z-ADD     31            A                 2 0
1021 C                   Z-ADD     1             X                 2 0
1022 C     X             DOUEQ     11
1023 C     TGS(A)        ADD       THS(A)        PT2(X)
1024 C                   ADD       1             A
1025 C                   ADD       1             X
1026 C                   END
1027 C**                   EXCPTPRTTS
1028 C** GERMINATE UNITS
1029 C                   Z-ADD     31            A                 2 0
1030 C                   Z-ADD     1             X                 2 0
1031 C     X             DOUEQ     11
1032 C                   Z-ADD     TGF(A)        PT0(X)
1033 C                   ADD       1             A
1034 C                   ADD       1             X
1035 C                   END
1036 C                   EXCEPT    PRTGF
1037 C** HOLD UNITS
1038 C                   Z-ADD     31            A                 2 0
1039 C                   Z-ADD     1             X                 2 0
1040 C     X             DOUEQ     11
1041 C                   Z-ADD     THF(A)        PT0(X)
1042 C                   ADD       1             A
1043 C                   ADD       1             X
1044 C                   END
1045 C                   EXCEPT    PRTHF
1046 C** TOTAL UNITS.
1047 C                   Z-ADD     31            A                 2 0
1048 C                   Z-ADD     1             X                 2 0
1049 C     X             DOUEQ     11
1050 C     TGF(A)        ADD       THF(A)        PT0(X)
1051 C                   ADD       1             A
1052 C                   ADD       1             X
1053 C                   END
1054 C                   EXCEPT    PRTTF
1055 C** END OF TOTAL PRINT WE ONLY PRINT 48 WEEKS MAX
1056 C     ENDLR         TAG
     C                   ENDSR
1057 C**
1058 C**
1059 C** SKIP TO NEW PAGE ON OF
1060 CSR   CHKOF         BEGSR
1061 CSR                 EXCEPT    HEAD
1062 CSR                 EXCEPT    PRTPC
1063 CSR                 SETOFF                                       OF
1064 CSR                 ENDSR
1065 C**
1066 C**
     C**************
     C* GETGRM     *
     C**************
     C     GETGRM        BEGSR
      ** DECIDE IF WEEKS OR DATES
     C     IGB(1)        IFGT      99
     C                   GOTO      GTWKS
     C                   END
      ** GET CALENDAR RECORD
     C     OIDTRQ        CHAIN     FCALEN                             90
     C   90              GOTO      ENDX
     C                   Z-ADD     1             XA                1 0
     C     NXTX          TAG
      ** FIRST CHECK FOR SAME YEAR WEEKS
     C     CLWEEK        IFGE      IGB(XA)
     C     CLWEEK        IFLE      IGE(XA)
     C                   Z-ADD     IGW(XA)       IMGERM            2 0
     C                   GOTO      ENDX
     C                   END
     C                   END
      ** NOW CHECK FOR DIFF YEAR WEEKS
     C     IGE(XA)       IFLT      IGB(XA)
     C     CLWEEK        IFGE      IGB(XA)
     C     CLWEEK        IFLE      53
     C                   Z-ADD     IGW(XA)       IMGERM
     C                   GOTO      ENDX
     C                   END
     C                   END
     C     CLWEEK        IFLE      IGE(XA)
     C     CLWEEK        IFGT      0
     C                   Z-ADD     IGW(XA)       IMGERM
     C                   GOTO      ENDX
     C                   END
     C                   END
     C                   END                                                    IGE < IGB
     C                   ADD       1             XA
     C     XA            IFLE      4
     C                   GOTO      NXTX
     C                   ELSE
     C                   GOTO      ENDX
     C                   END
      ** THE GERM ARRAY IS DATE NOT WEEK #
     C     GTWKS         TAG
     C                   MOVE      OIDTRQ        BYR               2 0
      ** BUILD WEEKS GERM ARRAY
     C     1             DO        4             X                 2 0
     C     IGB(X)        IFGT      IGE(X)
     C     BYR           ADD       100           BYN               3 0
     C     BYN           SUB       1             EYR               2 0
     C                   ELSE
     C                   Z-ADD     BYR           EYR
     C                   END
     C                   MOVEL     IGB(X)        ##MDY
     C                   MOVE      EYR           ##MDY
     C                   EXSR      @DT@A1
     C   90              DO
     C     IGB(X)        IFEQ      0229
     C                   SUB       1             IGB(X)
     C                   MOVEL     IGB(X)        ##MDY
     C                   MOVE      EYR           ##MDY
     C                   EXSR      @DT@A1
     C                   END
     C                   ENDDO
     C                   Z-ADD     ##CYMD        IGB7(X)
     C                   MOVEL     IGE(X)        ##MDY
     C                   MOVE      BYR           ##MDY
     C                   EXSR      @DT@A1
     C   90              DO
     C     IGE(X)        IFEQ      0229
     C                   SUB       1             IGE(X)
     C                   MOVEL     IGE(X)        ##MDY
     C                   MOVE      BYR           ##MDY
     C                   EXSR      @DT@A1
     C                   END
     C                   ENDDO
     C                   Z-ADD     ##CYMD        IGE7(X)
      ** SEE IF DATE FITS
     C     IGB7(X)       IFGT      0
     C     OIRVDT        ANDGE     IGB7(X)
     C     OIRVDT        ANDLE     IGE7(X)
     C                   Z-ADD     IGW(X)        IMGERM
     C                   GOTO      ENDGRM
     C                   ENDIF
     C                   ENDDO
     C     ENDGRM        TAG
     C     ENDX          TAG
     C*
     C     EGTGRM        ENDSR
     C*
     C*****************
     C* GETQTY     *
     C**************
     C     GETQTY        BEGSR
     C                   Eval      Order = LEFT01
     C                   Z-ADD     LEFT01        SOWQTY            6 1
     C     IMFTAB        IFEQ      '**'
     C                   GOTO      ENDPTB
     C                   END
     C* CALCULATE NUMBER OF LABELS
     C                   DO        12            X                 2 0
     C*
     C*
     C     SOWQTY        IFGE      BR(X)
     C     SOWQTY        ANDLE     EN(X)
     C     FC(X)         IFGT      0
     C     SOWQTY        ADD       FC(X)         WRKFLD            5 1
     C                   ELSE
     C     PCT(X)        DIV(H)    100           WRKPC             5 4
     C     1             ADD       WRKPC         WRKPCT            5 4
     C     SOWQTY        MULT(H)   WRKPCT        WRKFLD
     C                   MOVE      WRKFLD        TST1              1 1
     C     1             SUB       TST1          ADD1              1 1
     C                   ADD       ADD1          WRKFLD
     C                   END
     C                   Z-ADD     WRKFLD        LEFT01
     C                   GOTO      ENDPTB
     C                   END
     C*
     C                   END
     C     ENDPTB        TAG
     C*
WJB ?C                   Call      '#SOWFACTOR'
WJB ?C                   Parm                    IMITEM
WJB ?C                   Parm                    IMSIZE
WJB ?C                   Parm                    IMFTAB
WJB ?C                   Parm                    Order
WJB ?C                   Parm                    ToSow
     C                   Eval      LEFT01 = ToSow
     C                   ENDSR
      ***********************
      ** START UP ROUTINE  **
      ***********************
     C     *INZSR        BEGSR
     C                   TIME                    TIMOD             6 0
     C                   TIME                    TMWRK            12 0
     C                   MOVE      TMWRK         TDATE             6 0
0341 C** GET CO NAME
0342 C                   MOVEL     '01'          MCKEY             4
0343 C                   MOVE      CO#           MCKEY
0344 C     CO#           CHAIN     FMCOMP                             94
0345 C  N94              MOVEL     MCNAME        ORGNAM           30
0347 C** SETUP TOTAL LINE ARRAYS "_","="
0348 C                   MOVE      *BLANKS       LOAD10           10
0349 C                   MOVE      '________'    LOAD10
0350 C                   MOVE      LOAD10        DSH(1)
0351 C                   MOVE      LOAD10        DSH(2)
0352 C                   MOVE      LOAD10        DSH(3)
0353 C                   MOVE      LOAD10        DSH(4)
0354 C                   MOVE      LOAD10        DSH(5)
0355 C                   MOVE      LOAD10        DSH(6)
0356 C                   MOVE      LOAD10        DSH(7)
0357 C                   MOVE      LOAD10        DSH(8)
0358 C                   MOVE      LOAD10        DSH(9)
0359 C                   MOVE      LOAD10        DSH(10)
0360 C                   MOVE      '========'    LOAD10
0361 C                   MOVE      LOAD10        EQL(1)
0362 C                   MOVE      LOAD10        EQL(2)
0363 C                   MOVE      LOAD10        EQL(3)
0364 C                   MOVE      LOAD10        EQL(4)
0365 C                   MOVE      LOAD10        EQL(5)
0366 C                   MOVE      LOAD10        EQL(6)
0367 C                   MOVE      LOAD10        EQL(7)
0368 C                   MOVE      LOAD10        EQL(8)
0369 C                   MOVE      LOAD10        EQL(9)
0370 C                   MOVE      LOAD10        EQL(10)
0371 C** MOVE FROM TO DATES INTO MMDDYY
     C                   MOVE      TO            TOWK              6 0
     C                   MOVE      FROM          FROMWK            6 0
0372 C     TOWK          MULT      100.0001      TOP               6 0
0373 C     FROMWK        MULT      100.0001      FROMP             6 0
0374 C** SET UP PLUG ARRAY
     C                   Z-ADD     FROM          ##CYMD
     C                   EXSR      @DT@B1
     C                   EXSR      @DAYWK
     C     #Y            IFNE      1
     C                   SUB       1             #Y
     C                   SUB       #Y            ##DDD
     C                   EXSR      @DT@D0
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        TO
     C                   END                                                       #Y<>1
      ** NOW GO BACK 20 WEEKS
     C                   SUB       140           ##DDD
     C                   Z-ADD     1             FP                3 0
     C     NXTPLG        TAG
     C                   EXSR      @DT@D0
     C                   EXSR      @DT@A1
     C                   Z-ADD     ##CYMD        PLG(FP)
     C                   ADD       1             FP
     C     FP            IFLT      100
     C                   ADD       7             ##DDD
     C                   GOTO      NXTPLG
     C                   END
0374 C** SET UP DATE ARRAY
0375 C                   Z-ADD     1             FX                2 0
0376 C     FROM          LOOKUP    PLG(FX)                            75  75
0377 C   75              Z-ADD     FX            STRTAR            2 0
0378 C                   Z-ADD     1             TX                2 0
0379 C     TO            LOOKUP    PLG(TX)                            75  75
0380 C** FIND OUT NUMBER OF WEEKS
0381 C     TX            SUB       FX            XX                2 0
0382 C                   ADD       1             XX
0383 C     XX            IFGT      52
0384 C                   Z-ADD     52            XX
0385 C                   END
0386 C     XX            ADD       1             #WKS              2 0
0387 C     TX            ADD       1             ENDAR             2 0
0388 C                   ADD       2             XX
0389 C                   Z-ADD     1             X                 2 0
0390 C*** MOVE MONDAY DATES INTO DATE ARRAY YYMD
0391 C     X             DOUEQ     XX
0392 C** MOVE INTO PRINT ARRAY
0393 C                   MOVE      PLG(FX)       TOWK
0393 C     TOWK          MULT      100.0001      DP(X)
0394 C                   ADD       1             X
0395 C                   ADD       1             FX
0396 C                   END
0397 C                   SETON                                        91
0398 C                   EXCEPT    HEAD
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
      ********************************************************************@DT@B1
      * CONVERT CYYMMDD TO DAY OF CENTURY DDDDD. INDICATOR 90 MINUS DATE  @DT@B1
      * ##CYMD INPUT DATE CYYMMDD                                         @DT@B1
      * ##DDD OUTPUT DAY OF CENTURY DDDDD. BASE DATE IS 01/01/1900        @DT@B1
      * INDICATORS USED 90-92.                                            @DT@B1
      ********************************************************************@DT@B1
     C     @DT@B1        BEGSR                                                                 @DT@B
     C                   Z-ADD     ##CYMD        ##CYMD            7 0  90      NEG DATE       @DT@B
      * CONVERT YEAR TO DAYS                                              @DT@B1
     C                   MOVEL     ##CYMD        #03               3 0          YY             @DT@B
     C     #03           MULT      365           ##DDD             5 0          FIRST LEAP     @DT@B
     C     #03           DIV       4             #03                      93    # OF LEAPS     @DT@B
     C                   MVR                     #02A              2 0    91    LEAP YEAR      @DT@B
     C   91
     CANN93#03           SUB       1             #03                                           @DT@B
     C     #03           ADD       ##DDD         ##DDD                          DAYS FOR LEAP  @DT@B
      * CONVERT MONTH TO DAYS                                             @DT@B1
     C                   MOVE      ##CYMD        #04               4 0          MMDD           @DT@B
     C                   MOVEL     #04           #02A                           MM             @DT@B
     C     #DY(#02A)     ADD       ##DDD         ##DDD                          DAY OF YEAR    @DT@B
     C     #02A          COMP      02                                 92        GT FEB         @DT@B
     C   91
     CAN 92
     CANN931             ADD       ##DDD         ##DDD                          LP YR MM 3-12  @DT@B
      * ADD DAY OF MONTH                                                  @DT@B1
     C                   MOVE      ##CYMD        #02               2 0          DD             @DT@B
     C     #02           ADD       ##DDD         ##DDD                          ADD DAYS       @DT@B
     C   90              Z-ADD     0             ##DDD                                         @DT@B
     C                   SETOFF                                       919293                   @DT@B
     C                   ENDSR                                                                 @DT@B
      ********************************************************************@DT@B1
0006 C********************************************************************@DT@D0
0007 C* CONVERT DAY OF CENTURY DDDDD TO MMDDYY                            @DT@D0
0008 C* ##DDD INPUT DAY OF CENTURY.                                       @DT@D0
0009 C* ##MDY OUTPUT DATE MMDDYY.                                         @DT@D0
0010 C* INDICATOR 90 IS A MINUS DATE.                                     @DT@D0
0011 C* INDICATORS 91-93 USED.                                            @DT@D0
0012 C********************************************************************@DT@D0
0003 C     @DT@D0        BEGSR                                                                 @DT@D
0013 C                   Z-ADD     0             ##MDY             6 0                         @DT@D
0014 C                   SETOFF                                       919293                   @DT@D
0015 C* TEST IF ZERO OR NEGATIVE                                          @DT@D0
0016 C     ##DDD         SUB       1             #05               5 0  90      REDUCE DDD BY 1@DT@D
0017 C   90              GOTO      @DT@DX                                       ERROR          @DT@D
0018 C* CALCULATE YEARS AND DAY OF YEAR                                   @DT@D0
0019 C     #05           DIV       365           #03               3 0          CYY            @DT@D
0020 C                   MVR                     #03A              3 0          DDD            @DT@D
0021 C* CALCULATE # OF LEAPS                                              @DT@D0
0022 C     #03           DIV       4             #02               2 0    92    # LEAPS        @DT@D
0023 C                   MVR                     #01               1 0    91    LEAP YEAR      @DT@D
     C   92
0024 CAN 91              SETOFF                                       91        1900 NOT LEAP  @DT@D
0025 C     #03A          ADD       1             #03A                           ADD TO DDD BY 1@DT@D
0026 C* IF LEAP YEAR, REDUCE # OF LEAPS BY ONE.                           @DT@D0
0027 CSR 91#02           SUB       1             #02                                           @DT@D
0028 CSR   #03A          SUB       #02           #03A                 92                       @DT@D
0029 C* IF DAYS NOT POSITIVE, ADJUST YEARS.                               @DT@D0
0030 CSRN92#03A          ADD       365           #03A                                          @DT@D
0031 C  N92#03           SUB       1             #03                    91      NO LONGER LEAP @DT@D
0032 C* DETERMINE IF NEW YEAR IS A LEAP.                                  @DT@D0
     CSRN92
0033 CANN91#01           COMP      1                                      91    IS A LEAP      @DT@D
0034 C* IF LEAP YEAR WAS MINUS                                            @DT@D0
     CSRN92
0035 CAN 91#03A          ADD       1             #03A                                          @DT@D
0036 C*                                                                   @DT@D0
0037 CSR   @DT@DA        TAG                                                                   @DT@D
0038 C* CALCULATE MONTH AND DAY.                                          @DT@D0
0039 CSR                 Z-ADD     2             #02                    9293                   @DT@D
0040 C* LEAP YEAR.                                                        @DT@D0
0041 CSR 91#03A          COMP      60                                 93  92                   @DT@D
     CSR 91
0042 CAN 93#03A          SUB       1             #03A                                          @DT@D
     CSR 91
0043 CAN 92              Z-ADD     3             #02                                           @DT@D
0044 CSRN92#03A          LOOKUP    #JD(#02)                           93  93                   @DT@D
0045 C*                                                                   @DT@D0
0046 CSR   #02           SUB       1             #02                                           @DT@D
0047 CSR   #03A          SUB       #JD(#02)      #03A                                          @DT@D
0048 CSR                 Z-ADD     #03A          #04               4 0                         @DT@D
0049 CSR                 MOVEL     #02           #04                                           @DT@D
0050 CSR                 Z-ADD     #03           ##MDY                                         @DT@D
0051 CSR                 MOVEL     #04           ##MDY                                         @DT@D
0052 C*                                                                   @DT@D0
0053 CSR                 SETOFF                                       919293                   @DT@D
0054 CSR   @DT@DX        ENDSR                                                                 @DT@D
     C*
0006 C********************************************************************
0007 C* FIGURES OUT DAY OF THE WEEK THAT ENTERED DATE IS.
0008 C* ##DDD INPUT DATE DDDDD - RESULT FROM @DT@B2
0009 C* #Y OUTPUT INDEX REFLECTING DAY OF WEEK
0011 C********************************************************************
0003 CSR   @DAYWK        BEGSR
0285 CSR   ##DDD         DIV       7.0000        #WKSN            10 5
0286 CSR                 MOVE      #WKSN         ##R               5 5
0287 CSR   ##R           MULT(H)   7             #Y                1 0
     C*
0288 CSR   #Y            IFGT      7
0289 CSR   #Y            SUB       7             #Y
     CSR                 END
     C*
     CSR   #Y            IFEQ      0
     CSR                 Z-ADD     7             #Y
     CSR                 END
     C*
0293 CSR                 ENDSR
      *
0055 C********************************************************************@DT@D0
1067 OREPORT    E            HEAD           1 03
1068 O                       ORGNAM              83
1069 O          E            HEAD           1
1070 O                                            6 'PRCSP'
1071 O                                           64 'SPACE PLANNING'
1072 O                                           74 'FROM:'
1073 O                       FROMP         Y     83
1074 O                                           88 'TO:'
1075 O                       TOP           Y     96
CAB  O                                          114 'PAGE'
CAB  O                       PAGE          2    120
1078 O          E            HEAD           2
1079 O                       UDATE         Y      8
1080 O                                           40 'FOR PRODUCT CLASSES:'
1081 O                       PC(1)               43
1081 O                       PC(2)               46
1081 O                       PC(3)               49
1081 O                       PC(4)               52
1081 O                       PC(5)               55
1081 O                       PC(6)               58
1081 O                       PC(7)               61
1081 O                       PC(8)               64
1081 O                       PC(9)               67
1081 O                       PC(10)              70
1081 O                       PC(11)              73
1081 O                       PC(12)              76
1081 O                       PC(13)              79
1081 O                       PC(14)              81
1081 O                       PC(15)              83
1081 O                       PC(16)              86
1081 O                       PC(17)              89
1081 O                       PC(18)              92
1081 O                       PC(19)              95
1081 O                       PC(20)              98
1082 O***                      TIMOD    132 '  :  :  '
CAB  O                       TIMOD              120 '  :  :  '
1078 O*       E  2             HEAD
1079 O*                                   8 'STRAR'
     O*                        STRTAR    11
1079 O*                                  18 'ENDAR'
     O*                        ENDAR     21
     O*                        PLG,1 Y   35
1083 O** PRINT PRODUCT CLASS DESCRIPTION
1084 O          EF           PRTPC          1
1085 O                       OPCL1                4
1086 O                       PCDESC              36
1087 O               OF                          57 '***** CONTINUED *****'
1088 O** PRINT TOTAL LINES DESCRIPTION
1089 O          EF           PRTOT       2  1
1090 O                                           25 '*** TOTAL ALL CLASSES **'
1091 O** PRINT WEEK DATE HEADINGS
1092 O          EF           PRTDT          1
CAB  O                       PT0            B   120 '      /  /  '
1094 O** PRINT GERMINATION SQ.FT.
1095 O**      EF 1             PRTGS
1096 O*                                  10 'GERM SQ.FT'
CAB  O*                        PT2   4B 120
1098 O** PRINT HOLD  SQ.FT.
1099 O*       EF 0             PRTHS
1100 O*                                  10 'HOLD SQ.FT'
CAB  O*                        PT2   4B 120
1102 O** PRINT DASH LINE
1103 O*       EF 1    N55      PRTHS
1104 O*                        DSH      120
1105 O** PRINT EQUAL LINE
1106 O*       EF11     55      PRTHS
1107 O*                        EQL      120
1108 O** PRINT TOTAL SQ.FT.
1109 O*       EF 2             PRTTS
1110 O*                                  10 'TOT. SQ.FT'
1111 O*                        PT2   4B 120
1112 O** PRINT GERMINATION UNITS.
1113 O          EF           PRTGF          1
1114 O***                                10 'GERM UNITS'
CAB  O                                            2 'GU'
1115 O                       PT0           4B   120
1116 O** PRINT HOLD  UNITS.
1117 O          EF           PRTHF          0
1118 O***                                10 'HOLD UNITS'
CAB  O                                            2 'HU'
CAB  O                       PT0           4B   120
1120 O** PRINT DASH LINE
1121 O          EF  N55      PRTHF          1
CAB  O                       DSH                120
1123 O** PRINT EQUAL LINE
1124 O          EF   55      PRTHF       1  1
CAB  O                       EQL                120
1126 O** PRINT TOTAL UNITS.
1127 O          EF           PRTTF          2
1128 O***                                10 'TOT. UNITS'
CAB  O                                            2 'TU'
CAB  O                       PT0           4B   120
1121 O**      EF 1             TEST
1129 O*                        OIITEM    15
1129 O*                        OISIZE    19
1129 O*                        IMPCL1    24
1129 O*                        OISOWXY   34
1129 O*                        T         40
1129 O*                        S         43
1129 O*                        D         51
1129 O*                        OIDTRQY   60
1129 O*                        LEFT014   75
1129 O*                        SOWQTY4   85
1129 O*                        TOTGER4   95
**  02 03 04 05 06 07 08 09 10 11 12   DAY OF YEAR FROM START OF MONTH.
000031059090120151181212243273304334365
** FEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC DAY OF YEAR FROM START OF MONTH.
    31059090120151181212243273304334
