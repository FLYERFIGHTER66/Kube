             PGM
             DCL        VAR(&FMMENU) TYPE(*LGL) VALUE('1')

             CALL       PGM(SOW500CL) PARM(&FMMENU)
             ENDPGM
