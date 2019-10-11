             CMD        PROMPT('Balance Master To Trucking')
             PARM       KWD(CHANGE) TYPE(*CHAR) LEN(4) RSTD(*YES) +
                          DFT('*NO ') VALUES('*YES' '*NO ') +
                          CHOICE('*YES or *NO') PROMPT('Change +
                          Selection Criteria ?')
             PARM       KWD(PRINTER) TYPE(*CHAR) LEN(10) +
                          CHOICE('Printer I.D.') PROMPT('Printer to +
                          use for reports')
