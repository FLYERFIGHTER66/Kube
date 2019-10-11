*Free
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes) AlwNull(*UsrCtl)
        BndDir('HTTPAPI');

        Dcl-F FARHST    Disk(*Ext) Keyed Usage(*Update);
        Dcl-F FARHST_BK Disk(*Ext) Keyed Usage(*Input)  prefix(BK_)
                                                        rename(RARHST:BKARHST);

      //Procedure Interface Declaration : *Entry Parameters
        Dcl-Pi WSPCI005BK End-Pi;

       DoW not %EOF(FARHST);
         Read FARHST;
         If not %eof(FARHST) and HSFIL2 <> *Blanks;
           Chain (HSCUST) FARHST_BK;
           If %FOUND(FARHST_BK);
             HSCRC# = BK_HSCRC#;
             HSFIL1 = BK_HSFIL1;
             HSINCL = BK_HSINCL;
             HSCRDT = BK_HSCRDT;
             HSBANK = BK_HSBANK;
             HSFIL2 = BK_HSFIL2;
             Update RARHST;
           EndIf;
         EndIf;
       EndDo;

       *InLR = *On;
       Return;
