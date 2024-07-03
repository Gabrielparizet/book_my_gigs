defmodule BookMyGigs.Accounts.AccountsTest do
  use BookMyGigs.DataCase, async: true
  doctest BookMyGigs

  alias BookMyGigs.Repo
  alias BookMyGigs.Accounts
  alias BookMyGigs.Accounts.Storage

  test "update_accounts can update an email and/or a password" do
    account =
      %Storage.Account{
        email: "test@gmail.com",
        password: "ThisIsMyPassword123?"
      }
      |> Repo.insert!()

    email_params = %{
      "account" => %{
        "email" => "modified_email@gmail.com"
      }
    }

    assert Accounts.update_account(email_params, account.id) ==
             %{
               :email => "modified_email@gmail.com",
               :id => account.id
             }

    password_params = %{
      "account" => %{
        "password" => "ModifiedPassword123?"
      }
    }

    assert Accounts.update_account(password_params, account.id) ==
             %{
               :email => "modified_email@gmail.com",
               :id => account.id
             }

    modified_account = Repo.get_by(Storage.Account, email: "modified_email@gmail.com")

    hash = modified_account.password

    assert Bcrypt.verify_pass("ModifiedPassword123?", hash) == true
  end

  test "hash_password/1" do
    password = "ThisIsAPassword123?"

    hash_password = Accounts.hash_password(password)

    assert Bcrypt.verify_pass(password, hash_password) == true
  end
end
