**FREE
        Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO) Debug(*Yes) AlwNull(*UsrCtl);

        Dcl-Pi TESTCARD;
          inCCARD char(16);
        End-Pi;

        Dcl-F TESTCARDFM workstn;
        monitor;
          ccard = %int(inCCARD);
          on-error;
          ccard = 0;
        EndMon;
        exfmt record;

        *InLR = *On;
        return;

