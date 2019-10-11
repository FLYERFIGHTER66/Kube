**Free
        Ctl-Opt Pgminfo(*Pcml:*Module) DftActGrp(*NO) Option(*NoDebugIO)
           ActGrp ('HTTP') BndDir('QC2LE');

        Dcl-Pi WSORDACKTS ExtPgm;
           POrderNo@    Char(6);
        End-Pi;

        Dcl-Pr WSORDERACK ExtPgm;
           POrderNo     Packed(6) Const;
           HttpStatus   Int(10:0);
        End-Pr;

        Dcl-Pr SNDPCMSG ExtPgm;
           PCMessage    Char(256) Const;
        End-Pr;

        dcl-s  HttpStatus   Int(10:0);

        WSORDERACK(%int(%trim(POrderNo@)):HttpStatus);

        If HttpStatus = 200;
          SNDPCMSG('Success!\n\n' +
                   'This acknowledgement was sent electronically');
        Else;
          SNDPCMSG('Send Failure\n\n' +
                   'This acknowledgement was NOT sent electronically\n' +
                   'Received http response:'+ %char(HttpStatus) );
        EndIf;

        Return;
