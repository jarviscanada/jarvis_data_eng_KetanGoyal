

CREATE TABLE if not exists PUBLIC.host_info
  (
     id                 SERIAL NOT NULL PRIMARY KEY AUTO_INCREMENT,
     hostname           VARCHAR NOT NULL UNIQUE,
     cpu_number         INT NOT NULL,
     cpu_architecture   VARCHAR(15) NOT NULL,
     cpu_model          VARCHAR(50) NOT NULL,
     cpu_mhz            FLOAT(7,3) NOT NULL,
     L2_cache           INT NOT NULL,
     total_mem          INT NOT NULL,
     timestamp          TIMESTAMP NOT NULL
  );


  CREATE TABLE if not exists PUBLIC.host_usage
    (
       timestamp      TIMESTAMP NOT NULL,
       host_id        SERIAL NOT NULL FOREIGN key,
       memory_free    INT NOT NULL,
       cpu_idle       INT NOT NULL,
       cpu_kernel     INT NOT NULL,
       disk_io        INT NOT NULL,
       disk_available INT NOT NULL
    );
