defmodule CouchbaseMobile.SyncGWTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock

  alias CouchbaseMobile.SyncGW

  test "document POST" do
    use_cassette "document_create" do
      %HTTPotion.Response{:body => json} = SyncGW.create_document(%{"hello" => "world", "count" => 5})

      assert Map.has_key? json, "id"
      assert Map.has_key? json, "rev"
      assert json["ok"] == true
    end
  end

  test "document PUT new" do
    use_cassette "document_create_with_id" do
      %HTTPotion.Response{:body => json} = SyncGW.create_document("new_document_with_id", %{"likes" => 3, "comments" => 5})

      assert json["id"] == "new_document_with_id"
      assert json["ok"] == true
    end
  end

  test "document PUT update" do
    use_cassette "document_update" do
      updated_doc = %{"count" => 7}
      current_rev = "1-00758affb49955e3ac41b11bb35667fa"

      %HTTPotion.Response{:body => json} = SyncGW.update_document("c6a83216f25cd4adf00bfa2d729aef02", current_rev, updated_doc)

      assert json["_rev"] != current_rev
      assert json["ok"] == true
    end
  end

  test "document GET" do
    use_cassette "document_get" do
      %HTTPotion.Response{:body => json} = SyncGW.get_document("c6a83216f25cd4adf00bfa2d729aef02")

      assert json["_id"] == "c6a83216f25cd4adf00bfa2d729aef02"
      assert json["hello"] == "world"
      assert json["count"] == 5
    end
  end

  test "document GET 404" do
    use_cassette "document_get_404" do
      response = SyncGW.get_document("this_doc_id_does_not_exist")

      assert response.status_code == 404
      assert response.body["error"] == "not_found"
    end
  end

  test "document DELETE" do
    use_cassette "document_delete" do
      %HTTPotion.Response{:body => json} = SyncGW.delete_document("c6a83216f25cd4adf00bfa2d729aef02", "1-00758affb49955e3ac41b11bb35667fa")
      assert json["ok"] == true
    end
  end
end
