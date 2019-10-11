     H DFTACTGRP(*NO) ACTGRP('KLEMENT') BNDDIR('HTTPAPI')
      /copy HTTPAPI_H
     D url             S           1000a   varying
     D stmf            s           1000a   varying
     D rc              s             10i 0
     D errMsg          s             52a   varying

     C     *ENTRY        PLIST
     C                   PARM                    ZipCode          15 5

      /free
         stmf = '/tmp/testrest.xml';
         url = 'https://www.zipwise.com/webservices/zipinfo.phpEST/'
               +'?key=8nxmg0hzy6nhi82t&zip=00501&format=xml';

         rc = http_get(url: stmf);
         if (rc<>1 and rc<>500);
           http_crash();
         endif;
         if rc=500;
           errMsg = 'did not work';
           dsply errMsg;
          else;
           dsply 'Worked...  check stream file.';
         endif;
         *inlr = *on;
      /end-free
