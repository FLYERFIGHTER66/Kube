             CMD        PROMPT('Delete B2B records for PO')
             PARM       KWD(BRKORID) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('PO#') +
                          PROMPT('Enter PO Number')
             PARM       KWD(FRORID) TYPE(*CHAR) LEN(30) PROMPT('From +
                          Org. ID') CHOICE('Ball +
                          Seed,Eason,Gloeckner,etc.') /* Ball +
                          Seed,Eason,Gloeckner,Griffin */
