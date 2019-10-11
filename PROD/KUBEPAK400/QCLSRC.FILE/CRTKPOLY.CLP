             PGM        PARM(&OVLNAME)
             DCL        VAR(&OVLNAME) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OVLFILE) TYPE(*CHAR) LEN(12)
             DCL        VAR(&DATALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FROM) TYPE(*CHAR) LEN(32) +
                          VALUE('\Overlays\')
             DCL        VAR(&TO) TYPE(*CHAR) LEN(32) +
                          VALUE('\QDLS\OVERLAYS\')

             RTVOBJD    OBJ(DATALIB) OBJTYPE(*FILE) RTNLIB(&DATALIB)

             CHGVAR     VAR(&OVLFILE) VALUE(&OVLNAME *TCAT '.oly')
             CHGVAR     VAR(&FROM) VALUE(&FROM *TCAT &OVLFILE)
             CHGVAR     VAR(&TO) VALUE(&TO *TCAT &OVLFILE)

             COPY       OBJ(&FROM) TOOBJ(&TO) REPLACE(*YES)

             CPYFRMPCD  FROMFLR('OVERLAYS') +
                          TOFILE(&DATALIB/OVERLAYS) +
                          FROMDOC(&OVLFILE) TOMBR(&OVLNAME) +
                          TRNTBL(*NONE) TRNFMT(*NOTEXT)

             CRTOVL     OVL(&DATALIB/&OVLNAME) +
                          FILE(&DATALIB/OVERLAYS) MBR(&OVLNAME) +
                          TEXT('Kube-Pak OVERLAY')

             ENDPGM
