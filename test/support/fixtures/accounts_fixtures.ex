defmodule Rocketsized.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Rocketsized.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Rocketsized.Accounts.register_user()

    user
  end

  def confirmed_user_fixture(attrs \\ %{}) do
    user_fixture(attrs)
    |> Rocketsized.Accounts.User.confirm_changeset()
    |> Rocketsized.Repo.update!()
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
