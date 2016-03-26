defmodule CouchbaseMobile.AdminGWTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias CouchbaseMobile.AdminGW

  test "user POST" do
    use_cassette "user_create" do
      {:ok, response} = AdminGW.create_user("alice", "secret", %{})
      assert response.body == ""
      assert response.status_code == 201
    end
  end

  test "user PUT" do
    use_cassette "user_update" do
      {:ok, response} = AdminGW.update_user("alice", %{"email" => "me@alice.com"})
      assert response.body == ""
      assert response.status_code == 200

      {:ok, %HTTPoison.Response{:body => new_alice}} = AdminGW.get_user("alice")
      assert new_alice["email"] == "me@alice.com"
    end
  end

  test "user GET" do
    use_cassette "user_get" do
      {:ok, %HTTPoison.Response{:body => json}} = AdminGW.get_user("alice")
      assert json["name"] == "alice"
    end
  end

  test "user DELETE" do
    use_cassette "user_delete" do
      {:ok, response} = AdminGW.delete_user("alice")
      assert response.status_code == 200
      assert response.body == ""
    end
  end

  test "user LIST" do
    use_cassette "user_list" do
      {:ok, %HTTPoison.Response{:body => json}} = AdminGW.get_users()
      assert is_list(json)
      assert Enum.member?(json, "alice")
    end
  end
end
