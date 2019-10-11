             CMD        PROMPT('Send FTP')
             PARM       KWD(INPUT) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('Member containing FTP script') +
                          PROMPT('Enter script member')
             PARM       KWD(OUTPUT) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('Member to write FTP log') +
                          PROMPT('Enter log member name')
