**free
  Ctl-Opt Pgminfo(*Pcml:*Module) DftActGrp(*NO) Option(*NoDebugIO)
     ActGrp ('HTTP') BndDir('QC2LE''KPFUNCTION');

  //Procedure Interphase
  Dcl-Pi WSINVOICET ;
     InvNum@       Char(6);
  End-Pi;

  //Procedure Prototype
  Dcl-Pr WSINVOICE extpgm('WSINVOICE');
     PInvNum       packed(6:0);
     HttpStatus    Int(10:0);
  End-Pr;

  //Program Status Data Structure :
  Dcl-Ds Pgmstatus PSDS;
     Job     Char(10) Pos(244);
     User    Char(10) Pos(254);
     Rundate Zoned(6) Pos(276);
     Runtime Zoned(6) Pos(282);
     Pgm     Char(10) Pos(334);
  End-Ds;

  dcl-s thisInvoice packed(6:0);
  dcl-s HttpStatus    Int(10:0);

  thisInvoice =  %int(InvNum@);

  dsply ('Submitting invoice: ' + InvNum@);
  WSINVOICE(thisInvoice:HttpStatus);

  *InLR = *On;
  return;
