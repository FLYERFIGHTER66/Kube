             CMD        PROMPT('Find the ZIP+4 for an Address')
             PARM       KWD(ADDRESS) TYPE(*CHAR) LEN(30) +
                          PROMPT('Street Address')
             PARM       KWD(TOWN) TYPE(*CHAR) LEN(18) MIN(1) +
                          PROMPT('Town to Find')
             PARM       KWD(STATE) TYPE(*CHAR) LEN(02) MIN(1) +
                          CHOICE('2 digit Abbreviaition') +
                          PROMPT('State')
