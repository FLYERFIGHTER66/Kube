             PGM
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(6)

             RTVJOBA    DATE(&DATE)

             CHGDTAARA  DTAARA(*LDA (001 02)) VALUE('01')
             CHGDTAARA  DTAARA(*LDA (003 06)) VALUE(&DATE)
             CHGDTAARA  DTAARA(*LDA (009 12)) VALUE('000000000000')
             CHGDTAARA  DTAARA(*LDA (025 03)) VALUE('000')
             CHGDTAARA  DTAARA(*LDA (100 10)) VALUE('*PDF')
             CHGDTAARA  DTAARA(*LDA (110 10)) VALUE('*NAR')
             CHGDTAARA  DTAARA(*LDA (120 02)) VALUE('01')
             CHGDTAARA  DTAARA(*LDA (123 04)) VALUE('*YES')
             CHGDTAARA  DTAARA(*LDA (127 04)) VALUE('*NO ')

             CALL PGM(*LIBL/ARC310CLJQ)

 END:        ENDPGM
