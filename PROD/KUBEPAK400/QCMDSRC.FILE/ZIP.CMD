             CMD        PROMPT('Find the ZIP Code for a town')
             PARM       KWD(TOWN) TYPE(*CHAR) LEN(18) MIN(1) +
                          PROMPT('Town to Find')
             PARM       KWD(STATE) TYPE(*CHAR) LEN(02) MIN(1) +
                          CHOICE('2 digit Abbreviaition') +
                          PROMPT('State')
