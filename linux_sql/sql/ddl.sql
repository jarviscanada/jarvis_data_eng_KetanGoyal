

CREATE TABLE IF NOT EXISTS PUBLIC.host_info
  (
     id                 BIGSERIAL NOT NULL PRIMARY KEY,
     hostname           VARCHAR NOT NULL UNIQUE,
     cpu_number         INT NOT NULL,
     cpu_architecture   VARCHAR(15) NOT NULL,
     cpu_model          VARCHAR(50) NOT NULL,
     cpu_mhz            DECIMAL(7,3) NOT NULL,
     L2_cache           INT NOT NULL,
     total_mem          INT NOT NULL,
     timestamp          TIMESTAMP NOT NULL
  );


  CREATE TABLE IF NOT EXISTS PUBLIC.host_usage
    (
       timestamp      TIMESTAMP NOT NULL,
       host_id        BIGSERIAL NOT NULL,
       memory_free    INT NOT NULL,
       cpu_idle       INT NOT NULL,
       cpu_kernel     INT NOT NULL,
       disk_io        INT NOT NULL,
       disk_available INT NOT NULL,
       FOREIGN KEY (host_id)
             REFERENCES host_info (id)
    );

