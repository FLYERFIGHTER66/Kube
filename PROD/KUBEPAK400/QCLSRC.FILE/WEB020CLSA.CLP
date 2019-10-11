             PGM

/*? FINISHED ?*/
             CALL       PGM(WEB020CL)

/*? SEND TO WEBSITE ?*/
             CALL       PGM(WEB006CL) PARM('1' 'WEB020FTP' 'WEB020LOG')

 EOJ:        ENDPGM
