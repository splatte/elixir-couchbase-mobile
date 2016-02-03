defmodule CouchbaseMobile do
  use HTTPotion.Base

  def process_request_headers(headers) do
    Dict.put(headers, :"Content-Type", "application/json")
  end

  def process_response_body(body) do
    binary_body = body |> IO.iodata_to_binary
    case binary_body  do
      "" -> binary_body
      _ -> binary_body |> read_json
    end
  end

  def http(verb, url, params \\ "") do
    case params do
      "" -> apply(CouchbaseMobile, verb, [url])
      _  -> apply(CouchbaseMobile, verb, [url, [body: params |> write_json]])
    end
  end

  defp read_json(data) do
    data |> Poison.decode!
  end

  def write_json(data) do
    data |> Poison.encode!
  end

  defmodule SyncGW do
    def base_url, do: "http://#{Application.get_env(:couchbase_mobile, :syncgw_host)}:#{Application.get_env(:couchbase_mobile, :syncgw_port)}"

    def request(verb, endpoint, params \\ "") do
      CouchbaseMobile.http(verb, base_url <> endpoint, params)
    end

    @doc """
    Creates a new document in the database.

    ## Reference
    http://developer.couchbase.com/documentation/mobile/1.1.0/develop/references/sync-gateway/rest-api/document/post---db-/index.html
    """
    defdelegate create_document(doc), to: CouchbaseMobile.API.Document

    @doc """
    Creates a new document with specified id.

    ## Reference
    http://developer.couchbase.com/documentation/mobile/1.1.0/develop/references/sync-gateway/rest-api/document/put---db---doc-/index.html
    """
    defdelegate create_document(id, doc), to: CouchbaseMobile.API.Document

    @doc """
    Updates a document.

    ## Reference
    http://developer.couchbase.com/documentation/mobile/1.1.0/develop/references/sync-gateway/rest-api/document/put---db---doc-/index.html
    """
    defdelegate update_document(id, rev, doc), to: CouchbaseMobile.API.Document

    @doc """
    Retrieves a document.

    ## Reference
    http://developer.couchbase.com/documentation/mobile/1.1.0/develop/references/sync-gateway/rest-api/document/get---db---doc-/index.html
    """
    defdelegate get_document(id), to: CouchbaseMobile.API.Document

    @doc """
    Deletes a document.

    ## Reference
    http://developer.couchbase.com/documentation/mobile/1.1.0/develop/references/sync-gateway/rest-api/document/delete---db---doc-/index.html
    """
    defdelegate delete_document(id, rev), to: CouchbaseMobile.API.Document
  end

  defmodule AdminGW do
    def base_url, do: "http://#{Application.get_env(:couchbase_mobile, :syncgw_host)}:#{Application.get_env(:couchbase_mobile, :syncgw_admin_port)}"

    def request(verb, endpoint, params \\ "") do
      CouchbaseMobile.http(verb, base_url <> endpoint, params)
    end

    @doc """
    Create a new user.

    ## Reference
    http://developer.couchbase.com/documentation/mobile/1.1.0/develop/references/sync-gateway/admin-rest-api/user/post-user/index.html
    """
    defdelegate create_user(name, password, user_extras), to: CouchbaseMobile.AdminAPI.User

    @doc """
    Update an existing user.

    ## Reference
    http://developer.couchbase.com/documentation/mobile/1.1.0/develop/references/sync-gateway/admin-rest-api/user/put-user/index.html
    """
    defdelegate update_user(name, user_extras), to: CouchbaseMobile.AdminAPI.User

    @doc """
    Get the specified user.

    ## Reference
    http://developer.couchbase.com/documentation/mobile/1.1.0/develop/references/sync-gateway/admin-rest-api/user/get-user/index.html
    """
    defdelegate get_user(name), to: CouchbaseMobile.AdminAPI.User

    @doc """
    Delete a user.

    ## Reference
    http://developer.couchbase.com/documentation/mobile/1.1.0/develop/references/sync-gateway/admin-rest-api/user/delete-user/index.html
    """
    defdelegate delete_user(name), to: CouchbaseMobile.AdminAPI.User

    @doc """
    Get the list of users.

    ## Reference
    http://developer.couchbase.com/documentation/mobile/1.1.0/develop/references/sync-gateway/admin-rest-api/user/get-user-list/index.html
    """
    defdelegate get_users(), to: CouchbaseMobile.AdminAPI.User
  end
end
