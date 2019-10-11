     H/Copy QFunctDefn,@CopyRight                                               ?Copyright Info.
     H BndDir('KPFUNCTION')
     H DATFMT(*USA)
     H NOMAIN

     FFalItemL3 UF   E           K DISK    UsrOpn
     FFdLotRdIDCUF   E           K DISK    UsrOpn
     FFdLotRd990UF   E           K DISK    Rename(RDLOTRD:RdLotRD990)
     F                                     Prefix(L990_) UsrOpn
     FFdLotRdCLTUF   E           K DISK    Rename(RDLOTRD:RdLotRDCLT)
     F                                     Prefix(CLT_)  UsrOpn
     FJAlItem990IF   E           K DISK    UsrOpn


      // Function Prototypes
     D/Copy QFunctDefn,$_OE
     D/Copy QFunctDefn,$_LOT

      // $DlcLotInv - Procedure to Deallocate Lot Inventory
     P $DlcLotInv      B                   Export
     D $DlcLotInv      PI
     D  $Ord#                         6P 0 Const                                Order Number
     D  $Seq#                         3P 0 Const                                Order Sequence #
     D  $OQty                        11P 1 Const                                Order Qty to Reduce
     D  $P_Item                      12A   Const
     D  $P_Size                       3A   Const
     D  $P_SowD                       7P 0 Const
     D  $P_CRdy                       7P 0 Const

     D  $Left2Move     S             11P 1
     D  $ThisMove      S             11P 1

      /Free

           If not %Open( FdLotRD990 );
             Open    FdLotRD990  ;
           EndIf;

           If not %Open( FdLotRdIDC );
             Open    FdLotRdIDC  ;
           EndIf;

           If not %Open( JAlItem990 );
             Open    JAlItem990  ;
           EndIf;

           If not %Open( FdLotRDCLT );
             Open    FdLotRDCLT  ;
           EndIf;

           If not %Open( FalItemL3  );
             Open    FalItemL3   ;
           EndIf;

           $Left2Move = $OQty;
         //  Check if 990 Lot Information was passed in...  if so dealocate specific 990 lot
           If $P_Item <> *Blanks;
             SetLL ($Ord#:
                    $Seq#:
                    $P_Item:
                    $P_Size:
                    $P_SowD:
                    $P_CRdy   ) JALITEM990;
             If %Equal(JALITEM990);
               ReadE ($Ord#:
                      $Seq#:
                      $P_Item:
                      $P_Size:
                      $P_SowD:
                      $P_CRdy   ) JALITEM990;
               If not %Eof(JALITEM990);
                 Chain (LRITEM:
                        LRSIZE:
                        LRWHSE:
                        LRSOWD:
                        LRCRDY:
                        LRCUST:
                        LRGLOC ) FDLOTRD990;
                 Chain (AIITEM:
                        AISIZE:
                        AIWHSE:
                        AISOWD:
                        AICRDY:
                        AICUST:
                        AIGLOC ) FDLOTRDCLT;
                 Chain (AIORD#:
                        AIOSEQ:
                        AIITEM:
                        AISIZE:
                        AISOWD:
                        AIGLOC:
                        AICRDY:
                        AICUST ) FALITEML3;
                 If  %Found(FDLOTRD990)
                 and %Found(FDLOTRDCLT)
                 and %Found(FALITEML3);
                   If %abs(LRQTOH) > AIQTOA;
                     Eval $ThisMove = %abs(LRQTOH);
                     Else;
                     Eval $ThisMove = AIQTOA;
                   ENDIF;
                   If $ThisMove > $Left2Move;
                     $ThisMove = $Left2Move;
                   ENDIF;
                   L990_LRQTOH += $ThisMove;
                   L990_LRQTAV += $ThisMove;
                   CLT_LRQTOH  -= $ThisMove;
                   CLT_LRQTAL  -= $ThisMove;
                   AIQTOA      -= $ThisMove;
                   Update RdLotRD990;
                   Update RdLotRDCLT;
                   Update RAlItem;
                   $Left2Move -= $ThisMove;
                 ELSE;
                   UnLock FdLotRD990;
                   UnLock FdLotRDCLT;
                   UnLock FalItemL3;
                 ENDIF;
               ENDIF;
             ENDIF;
           ENDIF;



         //  If $Left2Move > *zero Dealocate from any FALITEM records with associated 990 records
           DoW $OrdSeq990($Ord#:$Seq#) and $Left2Move > *Zero;
             SetLL ($Ord#:$Seq#) JALITEM990;
             If %Equal(JALITEM990);
               ReadE ($Ord#:
                      $Seq#:
                      $P_Item:
                      $P_Size:
                      $P_SowD:
                      $P_CRdy   ) JALITEM990;
               If not %Eof(JALITEM990);
                 Chain (LRITEM:
                        LRSIZE:
                        LRWHSE:
                        LRSOWD:
                        LRCRDY:
                        LRCUST:
                        LRGLOC ) FDLOTRD990;
                 Chain (AIITEM:
                        AISIZE:
                        AIWHSE:
                        AISOWD:
                        AICRDY:
                        AICUST:
                        AIGLOC ) FDLOTRDCLT;
                 Chain (AIORD#:
                        AIOSEQ:
                        AIITEM:
                        AISIZE:
                        AISOWD:
                        AIGLOC:
                        AICRDY:
                        AICUST ) FALITEML3;
                 If  %Found(FDLOTRD990)
                 and %Found(FDLOTRDCLT)
                 and %Found(FALITEML3);
                   If %abs(LRQTOH) > AIQTOA;
                     Eval $ThisMove = %abs(LRQTOH);
                     Else;
                     Eval $ThisMove = AIQTOA;
                   ENDIF;
                   If $ThisMove > $Left2Move;
                     $ThisMove = $Left2Move;
                   ENDIF;
                   L990_LRQTOH += $ThisMove;
                   L990_LRQTAV += $ThisMove;
                   CLT_LRQTOH  -= $ThisMove;
                   CLT_LRQTAL  -= $ThisMove;
                   AIQTOA      -= $ThisMove;
                   Update RdLotRD990;
                   Update RdLotRDCLT;
                   Update RAlItem;
                   $Left2Move -= $ThisMove;
                 ELSE;
                   UnLock FdLotRD990;
                   UnLock FdLotRDCLT;
                   UnLock FalItemL3;
                 ENDIF;
               ENDIF;
             ENDIF;
           ENDDO;



         //  If $Left2Move > *zero Dealocate from any FALITEM record remaining
           SetLL ($Ord#:$Seq#) FALITEML3;
           ReadE ($Ord#:$Seq#) FALITEML3;
           DoW not %Eof(FALITEML3);
             Chain (AIITEM:
                    AISIZE:
                    AIWHSE:
                    AISOWD:
                    AICRDY:
                    AICUST:
                    AIGLOC ) FDLOTRDCLT;
             If %Found(FDLOTRDCLT);
               If AIQTOA <= $Left2Move;
                 $ThisMove = AIQTOA;
               ENDIF;
               If $ThisMove > $Left2Move;
                 $ThisMove = $Left2Move;
               ENDIF;
               AIQTOA -= $ThisMove;
               CLT_LRQTAL  -= $ThisMove;
               CLT_LRQTAV  += $ThisMove;
               Update RdLotRDCLT;
               Update RAlItem;
               $Left2Move = $Left2Move - $ThisMove;
               If $Left2Move <= *Zero;
                 Leave;
               EndIf;
             EndIf;
             ReadE ($Ord#:$Seq#) FALITEML3;
           EndDo;

           If %Open( FdLotRdIDC );
             Close   FdLotRdIDC  ;
           EndIf;

           If %Open( JAlItem990 );
             Close   JAlItem990  ;
           EndIf;

           If %Open( FdLotRD990 );
             Close   FdLotRD990  ;
           EndIf;

           If %Open( FdLotRDCLT );
             Close   FdLotRDCLT  ;
           EndIf;

           If %Open( FalItemL3  );
             Close   FalItemL3   ;
           EndIf;

           Return;

      /End-Free
     P $DlcLotInv      E
