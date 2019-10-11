/*********************************************************************/
/*   PROGRAM-------- BIR280CL                                        */
/*   DATE WRITTEN---  3/01/99                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- BROKER ORDER ENTRY   (FOR INTERNAL USE)         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)

 NXTO:       CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (8 10)) VALUE('Y000000000')
             CHGDTAARA  DTAARA(*LDA (133 1)) VALUE('N')
             OVRPRTF    FILE(QPRINT) DEV(P3) PAGESIZE(66 80) LPI(6) +
                          CPI(10) FORMTYPE(*NAR) USRDTA('Griffin')
             CALL       PGM(GRF030)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ *EQ 'X') THEN(GOTO CMDLBL(END))

             OVRDBF     FILE(FMCUSTC) TOFILE(FMCUST)
             OVRDBF     FILE(FMCUSTB) TOFILE(FMCUST)
             CALL       PGM(BIR100)
             RTVDTAARA  DTAARA(*LDA (133 1)) RTNVAR(&EOJ)

             IF         COND(&EOJ *EQ 'X') THEN(GOTO CMDLBL(END))
             GOTO       CMDLBL(NXTO)

 END:        CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')

             RTVJOBA    CURLIB(&LIB)

             IF         COND(&LIB *EQ 'KUBEPAK400') THEN(DO)
             SBMJOB     CMD(CALL PGM(GRF010CL)) JOB(GRIF_FTP) +
                          JOBD(KUBEPAK) JOBQ(QBATCH) JOBPTY(9)
             ENDDO

             DLTOVR     FILE(*ALL)
             ENDPGM
