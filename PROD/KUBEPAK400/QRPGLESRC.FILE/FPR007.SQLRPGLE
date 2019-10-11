     H/COPY QFunctDefn,@CopyRight                                               ?Copyright Info.
     H DftActGrp(*No)
     H BndDir('*LIBL/KPFUNCTION')                                               ?Use KP Functions
     H DatFmt(*Usa)
      //? :````````````````````````````````````````````````````````````:?
      //? :   Title:  Upload Finished Production Schedule Info         :?
      //? :............................................................:?
      //? :````````````````````````````````````````````````````````````:
      //? : Created:  January 2016         ? Kube-Pak Corporation ?    :
      //? :      by:  William J. Behr                                  :
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :   Program Description                                     ?:
      //? : ```````````````````````                                   ?:
      //? :                                                           ?:
      //? :............................................................:
      //? :````````````````````````````````````````````````````````````:
      //? :?  Edit Log                                                ?:
      //? :                                                           ?:
      //? :  WJB    -? 1/22/16 - Initial Programming                  ?:
      //? :         -?  /  /   - _____________________________________?:
      //? :............................................................:

      //? Main procedure prototype & interface
     D FPR005          PR                  ExtPgm('FPR005')
     D FPR005          PI

      *? Function Prototypes
    ?D/COPY QFunctDefn,QCMDEXC
    ?D/COPY QFunctDefn,$_Dates
    ?D/COPY QFunctDefn,$Now
    ?D/COPY QFunctDefn,$User

      *? Fields
     D  Command        S            256A   inz(*Blanks)
     D  User           S             10A   inz(*Blanks)
     D  Today7         S              7S 0 inz(*Zero)
     D  Today          S              6S 0 inz(*Zero)
     D  Now            S              6S 0 inz(*Zero)
     D  Year           S              4S 0 inz(2016)

      /Free

         Today7 = $Date7($Date(0));
         Today  = $MDYDate($Date(0));
         Now    = $Now();
         User   = $User();

         Exec SQL
           INSERT INTO FTINVT
             ( SELECT 'A'                 as ITSTAT
               , FSITEM                   as ITITEM
               , FSSIZE                   as ITSIZE
               , 1                        as ITTCOM
               , ' '                      as ITTWSE
               , ' '                      as ITTLOC
               , 'P'                      as ITTYPE
               , 0                        as ITFCOM
               , ' '                      as ITFWSE
               , ' '                      as ITFLOC
               , :Today                   as ITTDAT
               , 'Kube-Pak Projections'   as ITDESC
               , 'Projections Upload'     as ITTREF
               , FSSOWT                   as ITTQTY
               , 'EA'                     as ITTUOM
               , 'Y'                      as ITGLUD
               , 0                        as ITVEND
               , ' '                      as ITCMRC
               , 0                        as ITCOST
               , ' '                      as ITCDFL
               , :Today                   as ITDTLA
               , :Now                     as ITTIME
               , :User                    as ITUSER
               , ' '                      as ITREPO
               , ' '                      as ITRBLD
               , 0                        as ITCOAV
               , ' '                      as ITVITM
               , ' '                      as ITCFLG
               , 0                        as ITGLAC
               , 0                        as ITUPC
               , 0                        as ITULC
               , 0                        as ITUIC
               , 0                        as ITTRAN
               , 0                        as ITORD#
               , 0                        as ITSEQ#
               , ' '                      as ITLOT
               , ' '                      as ITRSCD
               , 0                        as ITLBS#
               , :Today7                  as ITYDAT
               , 0                        as ITYWGT
               , 'PRJ'                    as ITREAS
               FROM FFINSUM
               WHERE FSSTAT = 'U' and FSPROJ = 'N');

         Exec SQL
           Update FMINVT
           Set    IMQTOH = IMQTOH + (Select sum(FSSOWT)
                                     FROM   FFINSUM
                                     WHERE  FSITEM||FSSIZE = IMITEM||IMSIZE
                                       and  FSSTAT = 'U'
                                       and  FSPROJ = 'N')
             ,    IMQTAV = IMQTAV + (Select sum(FSSOWT)
                                     FROM   FFINSUM
                                     WHERE FSITEM||FSSIZE = IMITEM||IMSIZE
                                       and  FSSTAT = 'U'
                                       and  FSPROJ = 'N')
             ,    IMDTLA = :Today
             ,    IMTIME = :Now
             ,    IMUSER = 'FPR007'
           Where  IMITEM||IMSIZE in (Select FSITEM||FSSIZE
                                     FROM FFINSUM
                                     WHERE FSSTAT = 'U' and FSPROJ = 'N');

           Exec SQL
             Update  FFINSUM
             Set     FSPROJ = 'Y'
               ,     FSDTLA = :Today
               ,     FSTIME = :Now
               ,     FSUSER =  User
               ,     FSPROG = 'FPR007'
             WHERE   FSSTAT = 'U' and FSPROJ = 'N';

         *InLR = *On;

       /End-Free
