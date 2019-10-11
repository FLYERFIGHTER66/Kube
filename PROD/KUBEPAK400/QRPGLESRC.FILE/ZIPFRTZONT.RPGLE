**Free
   CTL-OPT
     DftActGrp(*no)
     DatFmt(*usa);

   DCL-PI ZIPFRTZONT;
   END-PI;

   /include QFunctFree,$ZIPFRTZON

   dsply ('The Freight Zone for Zip 08724 is ' + $ZIPFRTZON('08724'));
   dsply ('The Freight Zone for Zip 23456 is ' + $ZIPFRTZON('23456'));
   dsply ('The Freight Zone for Zip 07095 is ' + $ZIPFRTZON('07095'));
   dsply ('The Freight Zone for Zip 19126 is ' + $ZIPFRTZON('19126'));

   *InLR = *On;
   Return;
