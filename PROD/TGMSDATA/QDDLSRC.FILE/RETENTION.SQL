  CREATE or REPLACE TABLE webservices_retention_policy for SYSTEM NAME RETENTION

 ( Directory           CHAR(256)      NOT NULL,
   File_beg_with       CHAR(32)       NOT NULL WITH DEFAULT,
   File_end_with       CHAR(32)       NOT NULL WITH DEFAULT,
   File_contains       CHAR(32)       NOT NULL WITH DEFAULT,
   File_type           CHAR(40)       NOT NULL WITH DEFAULT,
   Retention_days      DEC(4,0)       NOT NULL WITH DEFAULT,
   Seq                 DEC(4,0)       NOT NULL WITH DEFAULT
  ) RCDFMT RETENTIONR;

