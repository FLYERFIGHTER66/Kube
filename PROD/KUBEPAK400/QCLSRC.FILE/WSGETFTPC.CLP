/*********************************************************************/
/*   PROGRAM-------- WSGETFTPC                                       */
/*   DATE WRITTEN--- 11 Jun 2018                                     */
/*   PROGRAMMER----- Vimala                                          */
/*   DESCRIPTION---- Program to GET Purchase Order XML from Brokers  */
/*                   into IFS folder using FTP                       */
/*   PARAMETERS----- WSPOEHRFTP, WSPOEHRLOG or                       */
/*                   WSPOMCVFTP, WSPOMCVLOG                          */
/*   REVISIONS------                                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&INPUT &OUTPUT)

             DCL        VAR(&INPUT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTPUT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&WKBROK) TYPE(*CHAR) LEN(10)

             OVRDBF     FILE(INPUT) TOFILE(QFTPSRC) MBR(&INPUT)
             OVRDBF     FILE(OUTPUT) TOFILE(QFTPSRC) MBR(&OUTPUT)

             CLRPFM     FILE(QFTPSRC) MBR(&OUTPUT)

             FTP        RMTSYS(SERVERNOTFOUND)

             DLTOVR     FILE(INPUT)
             DLTOVR     FILE(OUTPUT)

/* Pass Broker ID based on the FTP program                           */
             IF         COND(&INPUT = 'WSPOEHRFTP') THEN(CHGVAR +
                          VAR(&WKBROK) VALUE('3953'))

/*           CALL       PGM(WSFTPPO01) PARM(&WKBROK)                 */
/* Submit Job to read IFS file and process PO's                      * /  +
             SBMJOB     CMD(CALL PGM(WSFTPPO01) PARM(&WKBROK)) +
                          JOB(WEBBUILD2) JOBD(*LIBL/KUBE_NOLOG) +
                          JOBQ(QBATCH2) MSGQ(*NONE)           */
             CALL       PGM(WSFTPPO01) PARM(&WKBROK)

             ENDPGM
