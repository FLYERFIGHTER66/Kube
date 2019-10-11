     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*no)
     H BndDir('*LIBL/KPFUNCTION')
     H DatFmt(*usa)
      /Free

         exec sql  // Set Tax Exempt Flag to 'Y' according list provided by Bill Swanekamp
           UPDATE FMCUST
           SET    CMTXST = 'Y'
           WHERE  CMBABB in (
             'BALL ',
             'BFG  ',
             'EHR  ',
             'EXPR ',
             'FLTNT',
             'GEIG ',
             'GLOC ',
             'GRIF ',
             'GRIME',
             'HOME ',
             'LIMO ',
             'MARY ',
             'MASTR',
             'MCGR ',
             'MCHU ',
             'MESSI',
             'MICH ',
             'MILI ',
             'NEWHO',
             'PARK ',
             'PENN ',
             'RAYM ',
             'RDS  ',
             'RUTG ',
             'SHSG ',
             'SYN  ',
             'TRICO',
             'VAUG ',
             'WHOLE');

         exec sql  // Set Tax Exempt Flag to 'N' according list provided by Bill Swanekamp
           UPDATE FMCUST
           SET    CMTXST = 'N'
           WHERE  CMBABB in (
             'BRICK',
             'COTT ');

         exec sql  // Set Tax Exempt Flag to 'Y' for Brickman outside on NJ per Bill Swanekamp
           UPDATE FMCUST
           SET    CMTXST = 'Y'
           WHERE  CMBABB = 'BRICK' and CMSTST <> 'NJ';

         *InLR = *On;

      /End-Free
