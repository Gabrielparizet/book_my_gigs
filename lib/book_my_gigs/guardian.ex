defmodule BookMyGigs.Guardian do
  @moduledoc """
  Guardian implementation module
  """
  use Guardian, otp_app: :book_my_gigs

  alias BookMyGigs.Accounts

  def subject_for_token(resource, _claims) do
    sub = to_string(resource.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]

    resource = Accounts.get_account_by_id!(id)
    {:ok, resource}
  end

  def authenticate(email, password) do
    case BookMyGigs.Accounts.get_account_by_email(email) do
      nil ->
        {:error, :unauthorized}

      resource ->
        hash_password = resource.password

        case validate_password(password, hash_password) do
          true -> create_token(resource)
          false -> {:error, :reason_for_error}
        end
    end
  end

  def validate_password(password, hash_password) do
    Bcrypt.verify_pass(password, hash_password)
  end

  defp create_token(account) do
    {:ok, token, _full_claims} = encode_and_sign(account)

    {:ok, account, token}
  end

  def sign_out(token) do
    case decode_and_verify(token) do
      {:ok, _claims} ->
        {:ok, nil}

      {:error, _reason} ->
        {:error, :invalid_token}
    end
  end
end
