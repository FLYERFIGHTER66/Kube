             PGM

             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)

             RTVOBJD    OBJ(*LIBL/PGMLIB) OBJTYPE(*FILE) RTNLIB(&LIBR)

             CLRPFM     FILE(&LIBR/QFTPSRC)                MBR(MEM010LOG)
             OVRDBF     FILE(INPUT)  TOFILE(&LIBR/QFTPSRC) MBR(MEM010FTP)
             OVRDBF     FILE(OUTPUT) TOFILE(&LIBR/QFTPSRC) MBR(MEM010LOG)

             FTP        RMTSYS(SERVERNOTFOUND)

             ENDPGM
