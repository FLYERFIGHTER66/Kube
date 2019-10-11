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
      *PROGRAM NAME-------- #EXLN
      *SYSTEM-------------- ORDER ENTRY
      *APPLICATION--------- EXTEND LINE      (CALLED PROGRAM)
      *
      *            CHANGE--DATE-------DESCRIPTION
      *
      *
      ***********************
      ** START HERE        **
      ***********************
      *
     C     *ENTRY        PLIST
     C                   PARM                    QTYORD            8 1
     C                   PARM                    VUPRIC            9 4
     C                   PARM                    VDISC             4 2
     C                   PARM                    #LINGR            9 2
     C                   PARM                    #LINNT            9 2
     C                   PARM                    #LINDS            7 2
      *
      *  #EXLN IS USED TO EXTEND THE VALUE OF A ORDER DETAIL LINE
      *
      * USER WILL NEED TO LOAD FIELDS AS FOLLOWS
      *
      *       ORDQTY    CONTAINS QUANTITY
      *       VUPRIC    CONTAINS PRICE
      *       VDISC     CONTAINS QUANTITY DISCOUNT PCT.
      *
      * PROGRAM WILL RETURN THE FOLLOWING:
      *
      *       #LINGR    EXTENDED GROSS AMOUNT
      *       #LINNT    EXTENDED NET AMOUNT
      *       #LINDS    DISCOUNT DOLLAR AMOUNT
      *
      * EXTEND GROSS AMOUNT
      *
     C     QTYORD        MULT(H)   VUPRIC        #LINGR            9 2
      *
      * ADJUST FOR DISCOUNT PERCENT
      *
     C     VDISC         IFGT      0
     C                   MOVE      VDISC         WKDISC            4 4
     C     1             SUB       WKDISC        WKDISC
     C     VUPRIC        MULT(H)   WKDISC        #PRC             11 4
     C                   ELSE
     C                   Z-ADD     VUPRIC        #PRC
     C                   END
      *
      * CALCULATE LINE NET AMOUNT
      *
     C     QTYORD        MULT(H)   #PRC          #LINNT            9 2
      *
      * CALCULATE DISCOUNT DOLLAR AMOUNT
      *
     C     #LINGR        SUB       #LINNT        #LINDS            7 2
      *
     C                   SETON                                        LR
