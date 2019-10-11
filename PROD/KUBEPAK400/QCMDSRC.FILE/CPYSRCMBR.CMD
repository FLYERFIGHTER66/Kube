             CMD        PROMPT('Copy Source Member')
             PARM       KWD(SRCMBR) TYPE(*CHAR) LEN(10) MIN(0) +
                          CHOICE('Member to Copy') PROMPT('Member +
                          to Copy')
             PARM       KWD(SRCFIL) TYPE(*CHAR) LEN(10) MIN(0) +
                          CHOICE('Source File Name') PROMPT('Source +
                          File Name')
             PARM       KWD(SRCLIB) TYPE(*CHAR) LEN(10) MIN(0) +
                          CHOICE('Source Library') PROMPT('Source +
                          Library')
             PARM       KWD(TOLIB) TYPE(*CHAR) LEN(10) MIN(0) +
                          CHOICE('Destination Library') +
                          PROMPT('Destination Library')
