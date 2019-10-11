             CMD        PROMPT('Delete B2B records for PO')
             PARM       KWD(ORDER) TYPE(*DEC) LEN(6) REL(*GT 0) +
                          MIN(1) CHOICE('KP Order Number') +
                          PROMPT('Enter Order Number')
             PARM       KWD(HTTPSTS) TYPE(*INT4) RSTD(*YES) DFT(0) +
                          VALUES(0) CHOICE('HTTP Status') +
                          PROMPT('From Org. ID')

