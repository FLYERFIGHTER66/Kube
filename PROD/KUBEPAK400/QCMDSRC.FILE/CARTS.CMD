             CMD        PROMPT('Display Carts for Order')
             PARM       KWD(SDATE) TYPE(*DEC) LEN(6) MIN(0) +
                          CHOICE('MM/DD/YY') PROMPT('Order Ship Date')
             PARM       KWD(ORDER) TYPE(*DEC) LEN(6) MIN(0) +
                          CHOICE('KP Order') PROMPT('Order Number')
             PARM       KWD(CARTS) TYPE(*DEC) LEN(5) MIN(0) +
                          PROMPT('Carts')
             PARM       KWD(SHOW) TYPE(*CHAR) LEN(1) RSTD(*YES) +
                          DFT('Y') VALUES('Y' 'N') MIN(0) +
                          CHOICE('MM/DD/YY') PROMPT('Order Ship Date')
