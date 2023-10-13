resource "shoreline_notebook" "data_import_failures_in_postgresql" {
  name       = "data_import_failures_in_postgresql"
  data       = file("${path.module}/data/data_import_failures_in_postgresql.json")
  depends_on = [shoreline_action.invoke_dump_restore,shoreline_action.invoke_import_data,shoreline_action.invoke_import_data_pgsql]
}

resource "shoreline_file" "dump_restore" {
  name             = "dump_restore"
  input_file       = "${path.module}/data/dump_restore.sh"
  md5              = filemd5("${path.module}/data/dump_restore.sh")
  description      = "Check the integrity of the data being imported"
  destination_path = "/tmp/dump_restore.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "import_data" {
  name             = "import_data"
  input_file       = "${path.module}/data/import_data.sh"
  md5              = filemd5("${path.module}/data/import_data.sh")
  description      = "Data formatting issues: One possible root cause of data import failures in PostgreSQL is issues with data formatting. This can occur when data is not properly formatted for the database, or when there are inconsistencies in the data that prevent it from being imported correctly."
  destination_path = "/tmp/import_data.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "import_data_pgsql" {
  name             = "import_data_pgsql"
  input_file       = "${path.module}/data/import_data_pgsql.sh"
  md5              = filemd5("${path.module}/data/import_data_pgsql.sh")
  description      = "Fix the data format in the file being imported so it's compatible with the target PostgreSQL database"
  destination_path = "/tmp/import_data_pgsql.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_dump_restore" {
  name        = "invoke_dump_restore"
  description = "Check the integrity of the data being imported"
  command     = "`chmod +x /tmp/dump_restore.sh && /tmp/dump_restore.sh`"
  params      = ["DATABASE_NAME"]
  file_deps   = ["dump_restore"]
  enabled     = true
  depends_on  = [shoreline_file.dump_restore]
}

resource "shoreline_action" "invoke_import_data" {
  name        = "invoke_import_data"
  description = "Data formatting issues: One possible root cause of data import failures in PostgreSQL is issues with data formatting. This can occur when data is not properly formatted for the database, or when there are inconsistencies in the data that prevent it from being imported correctly."
  command     = "`chmod +x /tmp/import_data.sh && /tmp/import_data.sh`"
  params      = ["DATABASE_NAME","TABLE_NAME","FILE_PATH"]
  file_deps   = ["import_data"]
  enabled     = true
  depends_on  = [shoreline_file.import_data]
}

resource "shoreline_action" "invoke_import_data_pgsql" {
  name        = "invoke_import_data_pgsql"
  description = "Fix the data format in the file being imported so it's compatible with the target PostgreSQL database"
  command     = "`chmod +x /tmp/import_data_pgsql.sh && /tmp/import_data_pgsql.sh`"
  params      = ["DATABASE_NAME","TABLE_NAME","FILENAME"]
  file_deps   = ["import_data_pgsql"]
  enabled     = true
  depends_on  = [shoreline_file.import_data_pgsql]
}

