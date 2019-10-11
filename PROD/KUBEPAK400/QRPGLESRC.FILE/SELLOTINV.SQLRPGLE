      /COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
?     // ?:````````````````````````````````````````````````````````````:?
?     // ?:         SELLOTINV - Sell Lot Inventory                     :?
?     // ?:............................................................:?
?     //  :````````````````````````````````````````````````````````````:
?     //  : Created:  Mar. 2013            ? Kube-Pak Corporation ?    :
?     //  :      by:  William J. Behr                                  :
?     //  :............................................................:
?     //  :````````````````````````````````````````````````````````````:
?     //  :   Program Description                                      :
?     //  : ```````````````````````                                    :
?     //  : This program is what is used to update Lot Inventory when  :
?     //  : we actually sell (Ship Confirm / Invoice) a Lot control    :
?     //  : item.  This program will update FALITEM, FDLOTRD, FDLOT,   :
?     //  : and FTRAY.                                                 :
?     //  :............................................................:


     FJTRORD    IF   E           K DISK                                         Join File
     FFTRAY     UF   E           K DISK                                         FTRAY
     FFALITEML5 UF   E           K DISK                                         FALITEM
     FFDLOTRDIDCUF   E           K DISK                                         FDLOTRD
     FFDLOTALOC UF   E           K DISK                                         FDOT

      //? Function Prototypes
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$Date
    ?D/COPY QFunctDefn,$MDYDate

      //? Program Prototype
     D SELLOTINV       PR                  ExtPgm('SELLOTINV')                  Prototype
     D Dim_ORDER                      6  0                                      Order Number
     D Dim_SEQ#                       3  0                                      Order Seq# to Start
     D Dim_QTY                        7  1                                      Quantity
      //? Program Interface
     D SELLOTINV       PI                                                       Procedure Interface
     D KORDER#                        6  0                                      Order Number
     D KSEQ#                          3  0                                      Order Seq# to Start
     D Quantity                       7  1                                      Quantity

      //? Field Definitions
     D Left2Remove     S              7  1                                       Quantity

      /FREE

       Left2Remove = Quantity;

       Setll (Korder#:KSeq#) JTRORD;
       ReadE (Korder#:KSeq#) JTRORD;
       DoW not %EOF(JTRORD) and Left2Remove > *Zero;
         Chain (TOTAG#) FTRAY;
         If %Found(FTRAY);
           TRORD# = TOORD#;
           TRSEQ# = TOSEQ#;
           TRSTAT = 'S'; // Sold
           TRCNTD = 'N';
           TRDTLA = $MDYDate($Date(0));
           TRTIME = $Now();
           TRUSER = 'SELLOTINVa';
           Chain (TOORD#:
                  TOSEQ#:
                  TRITEM:
                  TRSIZE:
                  TRSCYM:
                  TRCRDT) FALITEML5;
           If %Found(FALITEML5);
             AIQTOA -= 1;
             AIDTLA = $MDYDate($Date(0));
             AITIME = $Now();
             AIUSER = 'SELLOTINVb';
             Chain (AIITEM:
                    AISIZE:
                    AICRDY:
                    AICUST:
                    AISOWD:
                    AIGLOC) FDLOTRDIDC;
             If %Found(FDLOTRDIDC);
               LRQTOH -= 1;
               LRQTAL -= 1;
               LRDTLA = $MDYDate($Date(0));
               LRTIME = $Now();
               LRUSER = 'SELLOTINVc';
               Chain (LRITEM:
                      LRSIZE:
                      '   ' :
                      LRSOWD:
                      LRCRDY) FDLOTALOC;
               If %Found(FDLOTALOC);
                 LDQTOH -= 1;
                 LDQTAL -= 1;
                 LDDTLA = $MDYDate($Date(0));
                 LDTIME = $Now();
                 LDUSER = 'SELLOTINVd';
                 Update RDLOT;
                 Update RDLOTRD;
                 Update RALITEM;
                 Update RTRAY;
                 Left2Remove -= 1;
               ENDIF;
             ENDIF;
           ENDIF;
         ENDIF;
       ReadE (Korder#:KSeq#) JTRORD;
       ENDDO;


       DoU not %Found(FALITEML5)
       or  not %Found(FDLOTRDIDC)
       or  not %Found(FDLOTALOC)
       or  Left2Remove <= *Zero;
         If  Left2Remove > *Zero;
           Chain (Korder#:
                  KSeq#) FALITEML5;    //Logical Omits Quantity = *zero
           If %Found(FALITEML5);
             AIQTOA -= 1;
             AIDTLA = $MDYDate($Date(0));
             AITIME = $Now();
             AIUSER = 'SELLOTINVe';
             Chain (AIITEM:
                    AISIZE:
                    AICRDY:
                    AICUST:
                    AISOWD:
                    AIGLOC) FDLOTRDIDC;
             If %Found(FDLOTRDIDC);
               LRQTOH -= 1;
               LRQTAL -= 1;
               LRDTLA = $MDYDate($Date(0));
               LRTIME = $Now();
               LRUSER = 'SELLOTINVf';
               Chain (LRITEM:
                      LRSIZE:
                      '   ' :
                      LRSOWD:
                      LRCRDY) FDLOTALOC;
               If %Found(FDLOTALOC);
                 LDQTOH -= 1;
                 LDQTAL -= 1;
                 LDDTLA = $MDYDate($Date(0));
                 LDTIME = $Now();
                 LDUSER = 'SELLOTINVg';
                 Update RDLOT;
                 Update RDLOTRD;
                 Update RALITEM;
                 Left2Remove -= 1;
               ENDIF;
             ENDIF;
           ENDIF;
         ENDIF;
       ENDDO;

       *InLR = *On;

      /END-FREE
