             CMD        PROMPT('Archive a Log')
             PARM       KWD(LIBR) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('Library Name, *LIBL') +
                          PROMPT('Enter the Library')
             PARM       KWD(FILE) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('File Name') +
                          PROMPT('Enter the File Name')
             PARM       KWD(NAME) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('Member Name') +
                          PROMPT('Enter the Member Name')
             PARM       KWD(TYPE) TYPE(*CHAR) LEN(10) MIN(1) +
                          CHOICE('Member Type') +
                          PROMPT('Enter the Member Type')
             PARM       KWD(MBRD) TYPE(*CHAR) LEN(50)  +
                          CHOICE('Member Description') +
                          PROMPT('Enter the Member Description')
