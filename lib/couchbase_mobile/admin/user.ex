defmodule CouchbaseMobile.AdminAPI.User do
  @moduledoc """
  """

  alias CouchbaseMobile.AdminGW

  def endpoint, do: "/" <> Application.get_env(:couchbase_mobile, :syncgw_bucket) <> "/_user/"

  def create_user(name, password, user_extras) do
    user_credentials = %{
      "name" => name,
      "password" => password
    }
    params = Map.merge(user_credentials, user_extras)
    AdminGW.request(:post, endpoint, params)
  end

  def update_user(name, user_extras) do
    params = user_extras
    AdminGW.request(:put, endpoint <> name, params)
  end

  def get_user(name) do
    AdminGW.request(:get, endpoint <> name)
  end

  def delete_user(name) do
    AdminGW.request(:delete, endpoint <> name)
  end

  def get_users() do
    AdminGW.request(:get, endpoint)
  end
end
