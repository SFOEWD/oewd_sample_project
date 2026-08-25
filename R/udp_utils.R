connect_to_udp <- function(schema="SNAPSHOTS") {
  DBI::dbConnect(odbc::odbc(),
                 Driver = "Snowflake",
                 Server = Sys.getenv("UDP_SERVER"),
                 Database = Sys.getenv("UDP_DATABASE"),
                 Schema = schema,
                 Warehouse = Sys.getenv("UDP_WAREHOUSE"),
                 UID = Sys.getenv("UDP_UID"),
                 Authenticator = "snowflake_jwt",
                 PRIV_KEY_FILE = Sys.getenv("UDP_PRIV_KEY_FILE"),
                 PRIV_KEY_FILE_PWD = Sys.getenv("UDP_PRIV_KEY_FILE_PWD")
  )
}
