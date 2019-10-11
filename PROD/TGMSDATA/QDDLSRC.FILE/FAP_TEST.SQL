  CREATE or REPLACE TABLE FAP_TEST

 ( id              DEC(10,0)      NOT NULL,
   ap_ip_address   CHAR(80)       NOT NULL WITH DEFAULT,
   ap_name         CHAR(40)       NOT NULL WITH DEFAULT,
   ap_section      CHAR(10)       NOT NULL WITH DEFAULT,
   ap_reset        CHAR(160)      NOT NULL WITH DEFAULT,
   ap_bay          CHAR(10)       NOT NULL WITH DEFAULT,
   ap_status       CHAR(1)        NOT NULL WITH DEFAULT
  ) RCDFMT RAP_TEST
