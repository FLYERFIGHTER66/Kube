     **Free
         //  :````````````````````````````````````````````````````````````:
         //  :       Monthly Late Charges (Assessed Daily)                :
         //  :............................................................:
         //  :````````````````````````````````````````````````````````````:
         //  : Created:  June 2004            ? Kube-Pak Corporation ?    :
         //  :      by:  William J. Behr                                  :
         //  :............................................................:

        /COPY QFunctDefn,#CopyRight  // Kube-Pak Corporation. All rights reserved.
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);

         DCL-PI TRKORDFEX;
           DCL-PARM Order# packed(6:0) Const; //Specify Order
         END-PI;

         dcl-pr qCmdExc extpgm ;
           *n char(1000) options(*varsize) const ;
           *n packed(15:5) const ;
         end-pr ;

         dcl-s ThisOrder packed(6:0);    // Order Number to Track
         dcl-s ThisMaster char(16);      // WRITE_SHP Master Tracking Number 16A
         dcl-s TrackingString char(52);  // Enough to hold 4 FedEx tracking nubers (12) with commas
         dcl-s FedExURL varchar(500);    // URL for FedEx Tracking website
         dcl-s Command char(1000);       // Command String

      //------------------------------------------------------------------------
      // Begin Program Logic
      //------------------------------------------------------------------------

         ThisOrder = Order#;

         Dow GetMaster() <> '*EOF';  //  Do While less than or equal to today
           TrackingString = %Trim(TrackingString) + ',' + %Trim(ThisMaster);
         EndDo;

         If TrackingString = *Blanks;
           Return;
          Else;
           TrackingString = %Subst(TrackingString:2:%Len(TrackingString)-1);
         ENDIF;

         FedExURL = 'https://www.fedex.com/apps/fedextrack/?tracknumbers='
                  + %Trim(TrackingString)
                  + '&cntry_code=us';

         Reset Command;
         Command = 'STRPCO';
         Monitor;
           qCmdExc(Command:%Len(%Trim(Command)));
         On-error;
           // PCO Most Likely already Started.
         EndMon;

         Reset Command;
         Command = 'STRPCCMD PCCMD(''explorer.exe "'+%Trim(FedExURL)+'"'')';
         qCmdExc(Command:%Len(%Trim(Command)));

         *InLR = *On;
         return;

      //------------------------------------------------------------------------
      // GetMaster - Get the next master tracking number
      //------------------------------------------------------------------------
         dcl-proc GetMaster;
           dcl-pi *n char(16);
           end-pi ;

         dcl-s LastMaster like(ThisMaster);

         LastMaster = ThisMaster;
         ThisMaster = '*EOF';

         Exec SQL // Get a Master Tracking Number for given Order
           SELECT DISTINCT MASTER#
             Into :ThisMaster
             FROM  Write_shp
           WHERE ( ORDER_1 = :ThisOrder
               or  ORDER_2 = :ThisOrder
               or  ORDER_3 = :ThisOrder
               or  ORDER_4 = :ThisOrder
               or  ORDER_5 = :ThisOrder )
              and  MASTER# > :LastMaster
           ORDER BY MASTER#;

           Return ThisMaster;
         end-proc;

