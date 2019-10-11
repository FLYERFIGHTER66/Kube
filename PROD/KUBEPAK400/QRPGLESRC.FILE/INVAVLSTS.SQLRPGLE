**Free
    CTL-OPT
        DftActGrp(*no)
        Actgrp(*caller)
        Thread(*serialize)
        BndDir('*LIBL/KPFUNCTION')
        Debug(*Yes)
        Pgminfo(*Pcml:*Module)
        Option(*SrcStmt : *NoDebugIO)
        DatFmt(*usa);

    DCL-PI INVAVLSTS;
    // This program is used to check on the inventory availability status of an item.
      DCL-PARM ThisItem Char(12);    // Item
      DCL-PARM ThisSize Char(3);     // Size
      DCL-PARM ThisDate Date;        // Ready Date
      DCL-PARM ThisType Char(10);    // PLUG_CTL_TYPE
      DCL-PARM ErrorNumber Zoned(1:0);    // ERROR NUMBER
      DCL-PARM ErrorDescription Char(35); // ERROR DESCRIPTION
    END-PI;

    // ?Procedure Prototype Declaration : Call CL program to Retreive MSG
    Dcl-Pr RtvErrMsg Extpgm('WSRTVMSG');            // CL Program
       WkMsgId  Char(7)   Const;                    // Msg Id
       WkMsgF   Char(10)  Const;                    // Msg File
       WKMsg    Char(132)      ;                    // Msg
       WkDta    Char(10)       ;                    // Msg Data
    End-Pr;

    DCL-F FMINVT keyed;

    If ThisType = *Blanks;
      ThisType = 'WEB';
    ENDIF;

    Chain (ThisItem:ThisSize) FMINVT;

    Select;
      When not %Found(FMINVT);
        ErrorNumber = 1; // Not a valid Kube-Pak item
      When IMSTAT <> 'A';
        ErrorNumber = 2; // Item Dropped from Kube-Pak program
      When not Authorized(ThisType:IMSOWC);
        ErrorNumber = 3; // Not authorized to sell item
      When not Available(ThisItem:ThisSize:ThisDate);
        ErrorNumber = 4; // Currently Unavailable
      When SowDate(ThisItem:ThisSize:ThisDate) < NextSowDate(ThisItem:ThisSize);
        ErrorNumber = 6; // Item Past Sow/Stick Date
      When not isOnHand(ThisItem:ThisSize:ThisDate) ;
        ErrorNumber = 5; // Item not in inventory
      Other;
        ErrorNumber = 0; // No Error found
    ENDSL;

    If ErrorNumber > 0;
      ErrorDescription = %trim(errorMessage(ErrorNumber));
     else;
      ErrorDescription = ' ';
    EndIf;

    *InLR = *On;
    Return;

    // :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
    // :  Authorized                                                           :
    // :.......................................................................:
    dcl-proc Authorized;
      dcl-pi *n ind;
        ThisType char(10);
        ThisSOWC char(1);
      END-PI;
      dcl-s Authorized ind Inz(*off);

      Reset Authorized;
      Authorized = *off;
      Exec SQL Select '1' into :Authorized from Inventory_View_Control_File
        where PLUG_CTL_TYPE = :ThisType and PLUG_CTL_CODE = :ThisSOWC
                Fetch First Row Only;

      return Authorized;

    END-PROC;


    // :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
    // :  Available                                                            :
    // :.......................................................................:
    dcl-proc Available;
      dcl-pi *n ind;
        ThisItem char(12);
        ThisSize char(3);
        ThisDate date;
      END-PI;
      dcl-s Available ind Inz(*on);

      Reset Available;
      Exec SQL Select '0' into :Available from Unavailable_items_400
                Where AVITEM = :ThisItem
                  and DATEFLD = :ThisDate
                Fetch First Row Only;
      If Available;
        Exec SQL Select '0' into :Available from Unavailable_item_Size_400
                  Where AVITEM = :ThisItem
                    and AVSIZE = :ThisSize
                    and DATEFLD = :ThisDate
                Fetch First Row Only;
      ENDIF;

      return Available;

    END-PROC;

    // :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
    // :  SowDate                                                              :
    // :.......................................................................:
    dcl-proc SowDate;
      dcl-pi *n date;
        ThisItem char(12);
        ThisSize char(3);
        ThisDate date;
      END-PI;
      dcl-s SowDate date;

      Exec SQL
        Set :SowDate = SowDate(:ThisItem, :ThisSize, :ThisDate);

      return SowDate ;

    END-PROC;

    // :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
    // :  NextSowDate                                                          :
    // :.......................................................................:
    dcl-proc NextSowDate;
      dcl-pi *n date;
        ThisItem char(12);
        ThisSize char(3);
      END-PI;
      dcl-s NextSowDate date;

      Exec SQL
        Select
          case when IMFRSZ = 'CUT' then Next_Sow_Date_Cut
                                    else Next_Sow_Date_Seed
          end
        into :NextSowDate
        from  FMINVT
        where IMITEM = :ThisItem
          and IMSIZE = :ThisSize
        Fetch First Row Only;

      return NextSowDate;

    END-PROC;

    // :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
    // :  isOnHand                                                             :
    // :.......................................................................:
    dcl-proc isOnHand;
      dcl-pi *n ind;
        ThisItem char(12);
        ThisSize char(3);
        ThisDate date;
      END-PI;
      //dcl-s isOnHand ind Inz(*off);
      //Reset isOnHand;

      //Exec SQL Select '1' into :isOnHand from Kube_Pak_Standard_Plug_Inventory
      //          Where Item_Number = :ThisItem
      //            and Item_Size = :ThisSize
      //            and Ready_Date = :ThisDate
      //           and Quantity_Available > 0
      //         Fetch First Row Only;


      dcl-s isOnHand ind Inz(*on);
      Reset isOnHand;
      Exec SQL Select '0' into :isOnHand from Kube_Pak_Standard_Plug_Inventory
                Where Item_Number = :ThisItem
                  and Item_Size = :ThisSize
                  and Ready_Date = :ThisDate
                  and Quantity_Available = 0
                Fetch First Row Only;

      return isOnHand;

    END-PROC;

    // :''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''':
    // :  errorMessage                                                         :
    // :.......................................................................:
    dcl-proc errorMessage;
      dcl-pi *n char(35);
        ThisError Zoned(1:0);
      END-PI;

      dcl-S WkDta       Char(10) Inz;
      dcl-s thisMessage char(132) Inz('Error');

      Reset thisMessage;

       // Call CL program to Get Error Msg
       Monitor;
         RtvErrMsg('STS000'+%char(thisError):'WSMSGF':thisMessage:WkDta);
       On-Error;
       EndMon;

      return thisMessage;

    END-PROC;
