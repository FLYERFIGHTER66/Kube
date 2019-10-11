/*********************************************************************/
/*   PROGRAM-------- PRODCLCL                                        */
/*   DATE WRITTEN--- 12/04/98                                        */
/*   PROGRAMMER----- EFD                                             */
/*   DESCRIPTION---- SPACE ALLOCATION REPORT                         */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&EOJ) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(1)

             CALL       PGM(PRODCL)
             RTVDTAARA  DTAARA(*LDA (58 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'X') THEN(GOTO CMDLBL(END))

             RTVDTAARA  DTAARA(*LDA (57 1)) RTNVAR(&EOJ)
             IF         COND(&EOJ = 'Y') THEN(DO)
             SBMJOB     CMD(CALL PGM(PRODCLCLJ))
             GOTO END
             ENDDO

             QSYS/OVRPRTF FILE(REPORT) TOFILE(*LIBL/QSYSPRT) DEV(Q1) +
                          PAGESIZE(66 132) LPI(6) CPI(10) +
                          ALIGN(*NO) FORMTYPE(*STD)
             CALL       PGM(PRODCLR)

 END:        ENDPGM
