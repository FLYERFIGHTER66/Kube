     h nomain PGMINFO(*PCML:*MODULE) THREAD(*SERIALIZE)
     h COPYRIGHT('+
     h 5722SS1, 5761SS1 (C) Copyright IBM Corp. 2007, 2007. All rights +
     h reserved. US Government Users Restricted Rights - Use, duplication +
     h or disclosure restricted by GSA ADP Schedule Contract with +
     h IBM Corp. Licensed Materials-Property of IBM')

     d ConvertTemp     pr
     *****************************************
     d  tempIn                       10    const
     d  tempOut                      10
     *****************************************
     p ConvertTemp     b                   export
     *****************************************
     d  ConvertTemp    pi
     d  tempIn                       10    const
     d  tempOut                      10
     *****************************************
     d tempI           s              8P 2
     d tempO           s              8P 2
     d value           S             50A
      /free
         value = %STR(%ADDR(tempIn));
         tempI=%DEC(value:7:2);
         tempO = (5/9)*(tempI - 32);
         value = %CHAR(tempO);
         tempOut = value;
          %STR(%ADDR(tempOut):10)=tempOut;
       /end-free
     p ConvertTemp     e
