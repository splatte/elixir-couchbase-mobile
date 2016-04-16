# Elixir Couchbase Mobile

Elixir library to talk to Couchbase Mobile Sync Gateway using the REST API.

Only a small subset of functionality is supported at the moment, namely:

  * document manipulation
  * user management

## Installation

  1. Add couchbase_mobile to your list of dependencies in `mix.exs`:

        def deps do
          [{:couchbase_mobile, github: "splatte/elixir-couchbase-mobile", branch: "master"}]
        end

  2. Ensure couchbase_mobile is started before your application:

        def application do
          [applications: [:couchbase_mobile]]
        end

  3. Update config file in `config/` relevant for your environment:

        config :couchbase_mobile,
          syncgw_host: "127.0.0.1",
          syncgw_port: 4984,
          syncgw_admin_port: 4985,
          syncgw_bucket: "defaultbucket"
