             CMD        PROMPT('Print Daily Cart Requirements')
             PARM       KWD(PRINTER) TYPE(*CHAR) LEN(10) MIN(0) +
                          CHOICE('Printer to Use') PROMPT('Printer +
                          to Use')
             PARM       KWD(DATE) TYPE(*DEC) LEN(6) MIN(0) +
                          CHOICE('Date in MMDDYY') PROMPT('Ship +
                          Date for Report')
             PARM       KWD(MASTER) TYPE(*DEC) LEN(2) MIN(0) +
                          CHOICE('Master Number') PROMPT('Master # +
                          for Report')
