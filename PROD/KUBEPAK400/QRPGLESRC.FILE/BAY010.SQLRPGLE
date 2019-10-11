**free
    CTL-OPT
        DftActGrp(*no)
        DatFmt(*usa)
        BndDir('*LIBL/KPFUNCTION')
        ALWNULL(*InputOnly);

    //? Main procedure prototype & interface
    dcl-pr BAY010          ExtPgm('BAY010');
      #SHIPDATE   packed(7:0);
      #MASTER     packed(2:0);
      #ORDER      packed(6:0);
    end-pr;
    dcl-pi BAY010;
      #SHIPDATE   packed(7:0);
      #MASTER     packed(2:0);
      #ORDER      packed(6:0);
    end-pi;

    dcl-f BAY010P printer OFLIND(Overflow);

    //? Data Structures

    //? Field Definitions
    Dcl-s  OverFlow  ind  Inz(*Off);
    dcl-s ThisShipDate zoned(7:0) Inz(0);
    dcl-s ThisMaster zoned(2:0) Inz(0);
    dcl-s ThisOrder zoned(6:0) Inz(0);

    ThisShipDate = #SHIPDATE;
    ThisMaster   = #MASTER;
    ThisOrder    = #ORDER;

    PrintDetails();

    *InLR = *On;
    Return;

    //--------------------------------------------------------------------
      dcl-Proc PrintDetails;
    //--------------------------------------------------------------------

        GetData();

        GetRecord();
        DoW SQLState = '00000' ;
          Write Header;
          Write Boxes2;
          Write Detail;
          GetRecord();
        EndDo;

        Exec SQL Close C1;

      end-proc;


    //--------------------------------------------------------------------
      dcl-Proc GetData;
    //--------------------------------------------------------------------

        Exec SQL Declare C1 Cursor for
          select
            set_dt.datefld                    as Ship_Week,
            PGMSTR                            as Master,
            'Bay'||left(trim(OHLOC)||'--',2)  as Bay,
            OHLOC                             as Cart_Loc,
            POLOWC                            as Shelves,
            POLOWF                            as Cart_Type,
            shp_dt.dotw_name || ' - ' ||
              trim(char(month(shp_dt.datefld))) || '/' ||
              trim(char(day(shp_dt.datefld))) as ShpDayDate,
            trim(OHNAME)                      as Cust_Name,
            trim(OHSHP2)                      as ShpAdr_1,
            trim(OHSHP3)                      as ShpAdr_2,
            trim(OHSHCT) || ', ' || OHSHST    as ShpAdr_CST,
            trim(OHSHCT) || ', ' || OHSHST|| ' '|| trim(OHSHZP)
                                              as ShpCTSTZP,
            OHCUST                            as Customer,
            ord_dt.datefld                    as OrderDate,
            req_dt.datefld                    as Req_Date,
            OHORD#                            as Order#,
            SVDESC                            as ShpViaName
          from S105R9YM.TGMSDATA.FPLGSETO#    as setup
          join S105R9YM.TGMSDATA.FHORDR       as orders   on setup.PGORD# = orders.OHORD#
          join S105R9YM.TGMSDATA.FPPO         as fppo     on setup.PGORD# = fppo.POORD#
          join S105R9YM.TGMSDATA.FCALEN_ALL   as set_dt   on setup.PGWKDT  = set_dt.cymd7
          join S105R9YM.TGMSDATA.FCALEN_ALL   as shp_dt   on orders.OHDTCN = shp_dt.mdy6
          join S105R9YM.TGMSDATA.FCALEN_ALL   as ord_dt   on orders.OHDTOR = ord_dt.mdy6
          join S105R9YM.TGMSDATA.FCALEN_ALL   as req_dt   on orders.OHDTRQ = req_dt.mdy6
          join S105R9YM.TGMSDATA.FMSVIA       as svia     on orders.OHSHPC = svia.SVCODE

          where   setup.PGWKDT = :ThisShipDate
            and   setup.PGMSTR = :ThisMaster
            and ( setup.PGORD# = :ThisOrder or :ThisOrder = 0 )
            and   OHLOC <> ' '
          Order by OHLOC, POLOWC
          For Read Only;

        Exec SQL Close C1;
        Exec SQL Open C1;

      end-proc;
    //--------------------------------------------------------------------
      dcl-Proc GetRecord;
    //--------------------------------------------------------------------

        Exec SQL Fetch C1
          into :Ship_Week,
               :Master,
               :Bay,
               :Cart_Loc,
               :Shelves,
               :Cart_Type,
               :ShpDayDate,
               :Cust_Name,
               :ShpAdr_1,
               :ShpAdr_2,
               :ShpAdr_CSt,
               :ShpCTSTZP,
               :Customer,
               :OrderDate,
               :Req_Date,
               :Order#,
             //:ShpViaCode,
               :ShpViaName;

        bc_order# = %char(Order#);
        bc_cust# = %char(Customer);

        If ShpAdr_2 = *blank;
          ShpAdr_2 = ShpCTSTZP;
          ShpCTSTZP = *Blanks;
        ENDIF;

        Cart_Loc2 = Cart_Loc;
        Shelves2 = Shelves;

        pNames(Cust_Name);
        ShpAdr_CSt = center(ShpAdr_CSt:%len(ShpAdr_CSt));

      end-proc;


    //--------------------------------------------------------------------
      dcl-Proc pNames;
    //--------------------------------------------------------------------
        dcl-pi *n;
          Name_To_Print char(30) const;
        END-PI;

          dcl-s SizeOfName zoned(2:0);
          dcl-s Middle     zoned(2:0);
          dcl-s Split      zoned(2:0);
          dcl-s x          zoned(2:0);

          Name0101 = *Blanks;
          Name0201 = *Blanks;
          Name0202 = *Blanks;

          NAMESIZE1  = 1;
          NAMESIZE21 = 1;
          NAMESIZE22 = 1;

          SizeOfName = %len( %trim(Name_To_Print) );

          If SizeOfName > 12; // Split
            // Find Break nearest the middle
            Middle = %div(SizeOfName:2);

            dou x >= Middle-1;
              Select;
                When %subst(Name_To_Print:Middle + x:1) = ' ';
                  Split = Middle + x;
                  X = 99;
                When %subst(Name_To_Print:Middle - x:1) = ' ';
                  Split = Middle - x;
                  X = 99;
                Other;
                  X += 1;
              ENDSL;
            ENDDO;
            If Split = 0;
              Name0101 = Name_To_Print;
              NAMESIZE1  = SizeTheName(Name0101);
              Else;
              Name0201 = %Trim(%subst(Name_To_Print:1:Split));
              NAMESIZE21 = SizeTheName(Name0201);
              Name0202 = %Trim(%subst(Name_To_Print:Split:SizeOfName-Split+1));
              NAMESIZE22 = SizeTheName(Name0202);
            ENDIF;
          Else; // Don't Split
            Name0101 = Name_To_Print;
            NAMESIZE1  = SizeTheName(Name0101);
        ENDIF;

      end-proc;


    //--------------------------------------------------------------------
      dcl-Proc Center;
    //--------------------------------------------------------------------
        dcl-pi *n varChar(256);
          Text_to_Center varchar(256) const;
          Length_Centered_In packed(3:0) const;
        END-PI;

        dcl-s Blanks256 char(256) Inz(*blanks);
        dcl-s centered256 char(256) Inz(*blanks);
        dcl-s buffer packed(3:0) Inz(*blanks);

        reset buffer;
        reset Blanks256;
        reset centered256;

        If %Len(%Trim(Text_to_Center)) > Length_Centered_In;
          return Text_to_Center;
        ENDIF;

        buffer = %int((Length_Centered_In - %Len(%Trim(Text_to_Center)))/2) ;
        centered256 =  %subst(blanks256:1:buffer) + %Trim(Text_to_center);

        return centered256;

      end-proc;


    //--------------------------------------------------------------------
      dcl-Proc SizeTheName;
    //--------------------------------------------------------------------
        dcl-pi *n zoned(4:1);
          NameToSize char(30) const;
        END-PI;

        dcl-s fontPoints zoned(4:1);

        // size    = 8" * 100(pt/in) * factor / characters to print
        fontPoints = 8  * 100        *  1.2   / %Len(%Trim(NameToSize));
        If fontPoints > 150;
          fontPoints = 150;
        ENDIF;

        return fontPoints;

      end-proc;

