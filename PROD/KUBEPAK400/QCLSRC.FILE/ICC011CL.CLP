             PGM

             CHGDTAARA  DTAARA(*LDA (*ALL)) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (134 8)) VALUE('ICC011')
             CHGDTAARA  DTAARA(*LDA (142 30)) VALUE(' Item +
                          Parameters Printout')

             CALL       PGM(DEF998)

             RUNQRY     QRY(GROWPARAMS) QRYFILE((*SAME)) +
                          OUTTYPE(*PRINTER) PRTDEV(XERPRT01) +
                          FORMTYPE(*HOLES)

             SNDPGMMSG  MSG('Load prepunched 8.5" x 11" paper into +
                          tray one of the canon copier (with the +
                          holes to the left) and then release the +
                          parameters report using the D P command') +
                          TOPGMQ(*EXT)

 END:        ENDPGM
