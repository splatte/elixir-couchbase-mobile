defmodule CouchbaseMobile do
  use HTTPotion.Base

  def process_request_headers(headers) do
    Dict.put(headers, :"Content-Type", "application/json")
  end

  def process_response_body(body) do
    body
      |> IO.iodata_to_binary
      |> read_json
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
    defdelegate create_user(), to: CouchbaseMobile.AdminAPI.User
  end
end
