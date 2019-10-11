             PGM        PARM(&TYPE)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MYWS) TYPE(*CHAR) LEN(10)
             RTVJOBA    JOB(&MYWS)
             IF         COND(&TYPE *EQ 'C') THEN(SNDBRKMSG MSG('Use +
                          the WRKCFGSTS (Work with Configuration +
                          Status) command to perform this System 36 +
                          function') TOMSGQ(&MYWS))
             IF         COND(&TYPE *EQ 'G') THEN(WRKWTR WTR(*ALL))
             IF         COND(&TYPE *EQ 'H') THEN(SNDBRKMSG MSG('Use +
                          the WRKCFGSTS (Work with Configuration +
                          Status) command to perform this System 36 +
                          function') TOMSGQ(&MYWS))
             IF         COND(&TYPE *EQ 'J') THEN(WRKJOBQ JOBQ(QBATCH))
             IF         COND(&TYPE *EQ 'L') THEN(SNDBRKMSG MSG('Use +
                          the WRKCFGSTS (Work with Configuration +
                          Status) command to perform this System 36 +
                          function') TOMSGQ(&MYWS))
             IF         COND(&TYPE *EQ 'M') THEN(MNGSPLF ??USER(*CURRENT))
             IF         COND(&TYPE *EQ 'P') THEN(WRKSPLF)
             IF         COND(&TYPE *EQ 'S') THEN(DSPJOB)
             IF         COND(&TYPE *EQ 'U') THEN(WRKUSRJOB USER(*ALL))
             IF         COND(&TYPE *EQ 'W') THEN(SNDBRKMSG MSG('Use +
                          the WRKCFGSTS (Work with Configuration +
                          Status) command to perform this System 36 +
                          function') TOMSGQ(&MYWS))
             IF         COND(&TYPE *EQ ' ') THEN(DSPJOB)
             ENDPGM
