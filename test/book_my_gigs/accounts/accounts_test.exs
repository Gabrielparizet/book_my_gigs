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
        hash_password: "ThisIsMyPassword123?"
      }
      |> Repo.insert!()

    email_params = %{
      "account" => %{
        "email" => "modified_email@gmail.com"
      }
    }

    assert Accounts.update_account(email_params, account.id) ==
             %Accounts.Account{
               :email => "modified_email@gmail.com",
               :hash_password => "ThisIsMyPassword123?"
             }

    hash_password_params = %{
      "account" => %{
        "hash_password" => "ModifiedPassword123?"
      }
    }

    assert Accounts.update_account(hash_password_params, account.id) ==
             %Accounts.Account{
               :email => "modified_email@gmail.com",
               :hash_password => "ModifiedPassword123?"
             }
  end
end
