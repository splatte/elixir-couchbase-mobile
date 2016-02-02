use Mix.Config

# In vagrant, start sync gateway with in-memory database using:
#  $ sync_gateway -bucket defaultbucket -interface 10.0.2.15:4984 -adminInterface :4985
#
# -adminInterface must be specified, otherwise it will bind to localhost only
config :couchbase_mobile,
  syncgw_host: "127.0.0.1",
  syncgw_port: 4984,
  syncgw_admin_port: 4985,
  syncgw_bucket: "defaultbucket"
