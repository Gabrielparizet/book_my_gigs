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
end
