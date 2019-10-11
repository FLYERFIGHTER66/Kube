**FREE

  Ctl-Opt  debug option(*NODEBUGIO : *SRCSTMT )
           dftactgrp(*no)
           actgrp(*caller)
           DatFmt(*USA)
           thread(*serialize);

  dcl-pr FEDEX_PICK             extpgm('FEDEX_PICK');
  //mondayDate                  date const;
  end-pr;

  dcl-s Ready_Bay_Week          date;

  SqlState = '00000';
  Exec SQL SET OPTION COMMIT = *NONE,
                   CloSqlCsr = *EndMod;

  SetOverrides();
  Open BIR310
  GetData();
  DoW SQLCode = '00000';
    Exec SQL Fetch C1 into :PayType, :KP_Order;
      If SQLCode = '00000';
        PrintPick();
      ENDIF;

  ENDDO;


  Return ;

  //---------------------------------------------------------------------
  // Set File Overrides
  //---------------------------------------------------------------------
  dcl-proc  setOverrides;

    Exec SQL // Override the printer file to PDF
      call QSYS2/QCMDEXEC('OVRPRTF FILE(BIR310)' +
             ' TOFILE(*LIBL/QSYSPRT) DEVTYPE(*AFPDS) PAGESIZE(66 80) LPI(6)' +
             ' CPI(10) ALIGN(*NO) TOSTMF(''' +  :Link  + ''') WSCST(*PDF)');

  end-proc;

  //---------------------------------------------------------------------
  // Get Data
  //---------------------------------------------------------------------
  dcl-proc  get_data;

    Exec SQL
      Declare C1 Cursor for
      select
          case    when ohtmcd in ('02','03','20','21','26','29','32')
            then 'COD'
            else 'TERMS'
          end             as PAYTYPE,
      ord.ohord#          as KP_ORDER

      from fhordr as ord
      join XATABE1 on OHSHPC = TBC6 and TBTB = 'FX'  and TBC6 <= '30'

      where OHSTAT = 'A'
        and OHDTRY = date7(READY_BAY_WEEK)

      ORDER BY
      PAYTYPE,
      OHALPH
      Fetch First Row Only;


  end-proc;

