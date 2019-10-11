             CMD        PROMPT('Verify Device is a printer')
             PARM       KWD(DEVICE) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('Enter Device Description') +
                          PROMPT('Enter Printer to be Tested')
