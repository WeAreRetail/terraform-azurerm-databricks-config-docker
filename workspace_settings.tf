
# Tips
# To get the setting names, open the Dev Tools while browsing
# the settings on the web interface. Toggle a setting and look at the 
# call to workspace-conf

resource "databricks_workspace_conf" "workspace_conf" {
  custom_config = {
    "enableDbfsFileBrowser" = true
    "enableDcs"             = true # Container services (Docker)
    "enableExportNotebook"  = false
    "enableWebTerminal"     = true
  }
}
