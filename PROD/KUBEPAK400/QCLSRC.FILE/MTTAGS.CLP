             PGM        PARM(&MEMBER)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CRTDATE) TYPE(*CHAR) LEN(13)
             DCL        VAR(&SQL) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SQL1) TYPE(*CHAR) LEN(32) +
                          VALUE('UPDATE MTDSHIST SET MTTMSTMP = ''')
             DCL        VAR(&TIMEST) TYPE(*CHAR) LEN(26) +
                          VALUE('2001-01-01-23.15.00.000000')
             DCL        VAR(&SQL2) TYPE(*CHAR) LEN(26) +
                          VALUE(''' WHERE YEAR(MTTMSTMP)<> 0')

             RTVMBRD    FILE(MTDSHIST) MBR(&MEMBER) CRTDATE(&CRTDATE)
               /* DATE FORMAT - 1160317145131 = 3/17/2016 @ 14:51:31 */
             CHGVAR     VAR(%SST(&TIMEST 03 2)) VALUE(%SST(&CRTDATE 02 2))
             CHGVAR     VAR(%SST(&TIMEST 06 2)) VALUE(%SST(&CRTDATE 04 2))
             CHGVAR     VAR(%SST(&TIMEST 09 2)) VALUE(%SST(&CRTDATE 06 2))
             CHGVAR     VAR(%SST(&TIMEST 12 2)) VALUE(%SST(&CRTDATE 08 2))
             CHGVAR     VAR(%SST(&TIMEST 15 2)) VALUE(%SST(&CRTDATE 10 2))
             CHGVAR     VAR(%SST(&TIMEST 18 2)) VALUE(%SST(&CRTDATE 12 2))

             CHGVAR     VAR(&SQL) VALUE(&SQL1 *TCAT &TIMEST *TCAT +
                          &SQL2)

             OVRDBF     FILE(MTDSHIST) TOFILE(*LIBL/MTDSHIST) +
                          MBR(&MEMBER)
             RUNSQL     SQL(&SQL) COMMIT(*NONE)
             DLTOVR     FILE(MTDSHIST)

 EOJ:        ENDPGM
