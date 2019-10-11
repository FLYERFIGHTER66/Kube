             PGM

/*? FUTURE ?*/
             CALL       PGM(WEB030CL)

/*? FUTURE AVAILABILITY ?*/
             SBMJOB     CMD(CALL PGM(WEB006CL) PARM('1' 'WEB030FTP' +
                          'WEB030LOG')) JOB(SEND_FUTR) +
                          JOBQ(QBATCH2) MSGQ(WEBSITE)

 EOJ:        ENDPGM
