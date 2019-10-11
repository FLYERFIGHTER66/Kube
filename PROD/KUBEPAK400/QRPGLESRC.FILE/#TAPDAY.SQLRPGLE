**Free
Ctl-Opt DftActGrp(*NO) Option(*NoDebugIO)
   ActGrp ('HTTP') BndDir('QC2LE');
Dcl-Pi #TAPDAY;
   Weekday  char(1);
End-Pi;

Exec SQL
  Set :Weekday = case when dayofweek(current date) > 1
                      then dayofweek(current date) - 1
                      else 7 end;
*InLR = *Off;
Return;
