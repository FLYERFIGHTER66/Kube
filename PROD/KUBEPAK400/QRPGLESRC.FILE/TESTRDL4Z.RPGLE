**free
dcl-f FSTDPLGL4Z rename(FSTDPLGL4Z:rcdlots);
dsply %timestamp();
read FSTDPLGL4Z;
Dow not %eof();
  read FSTDPLGL4Z;
EndDo;
dsply %timestamp();
*inLR = *on;
return;
