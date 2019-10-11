             CMD        PROMPT('Orion Development Environment') +
                          TEXT('Start or End the Orion Environment')
             PARM       KWD(TASK) TYPE(*CHAR) LEN(6) RSTD(*YES) +
                          DFT(*START) VALUES(*START *END) MIN(0) +
                          CHOICE('*START, *END') PROMPT('Orion Task +
                          - Start or End')
