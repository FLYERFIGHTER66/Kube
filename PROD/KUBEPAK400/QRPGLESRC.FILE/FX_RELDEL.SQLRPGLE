     **Free
         CTL-OPT
             DftActGrp(*no)
             DatFmt(*usa);
         // When a released order line is off mastered in total to another order,
         // the line is deleted while still released.  The order cannot then be deleted.
         // This SQL unreleases the deleted line.
         DCL-PI FX_RELDEL;
         END-PI;

         Exec SQL // Delete Ball x-mit file
         UPDATE FIORDR
         SET    OISHCD = 'N'
         WHERE  OISTAT = 'D'
           and  OIITYP = ' '
           and  OISHCD = 'R'
           and  OIQORD =  0
           and  OIORD# in ( Select OHORD# from FHORDR where OHSTAT = 'A' );

         *InLR = *on;
         Return;
