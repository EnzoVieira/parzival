defmodule Parzival.Tools do
  @moduledoc """
  The Tools context.
  """

  use Parzival.Context

  import Ecto.Query, warn: false

  alias Parzival.Repo
  alias Parzival.Tools.Faq

  @doc """
  Returns the list of faqs.

  ## Examples

      iex> list_faqs()
      [%Faqs{}, ...]

  """
  def list_faqs(params \\ %{})

  def list_faqs(opts) when is_list(opts) do
    Faq
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_faqs(flop) do
    Flop.validate_and_run(Faq, flop, for: Faq)
  end

  def list_faqs(%{} = flop, opts) when is_list(opts) do
    Faq
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Faq)
  end

  @doc """
  Gets a single faqs.

  Raises `Ecto.NoResultsError` if the Faqs does not exist.

  ## Examples

      iex> get_faqs!(123)
      %Faqs{}

      iex> get_faqs!(456)
      ** (Ecto.NoResultsError)

  """
  def get_faq!(id), do: Repo.get!(Faq, id)

  @doc """
  Creates a faqs.

  ## Examples

      iex> create_faqs(%{field: value})
      {:ok, %Faqs{}}

      iex> create_faqs(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_faq(attrs \\ %{}) do
    %Faq{}
    |> Faq.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a faqs.

  ## Examples

      iex> update_faqs(faqs, %{field: new_value})
      {:ok, %Faqs{}}

      iex> update_faqs(faqs, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_faq(%Faq{} = faq, attrs) do
    faq
    |> Faq.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a faqs.

  ## Examples

      iex> delete_faqs(faqs)
      {:ok, %Faqs{}}

      iex> delete_faqs(faqs)
      {:error, %Ecto.Changeset{}}

  """
  def delete_faq(%Faq{} = faq) do
    Repo.delete(faq)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking faqs changes.

  ## Examples

      iex> change_faqs(faqs)
      %Ecto.Changeset{data: %Faqs{}}

  """
  def change_faq(%Faq{} = faq, attrs \\ %{}) do
    Faq.changeset(faq, attrs)
  end

  alias Parzival.Tools.Announcement

  @doc """
  Returns the list of announcements.

  ## Examples

      iex> list_announcements()
      [%Announcement{}, ...]

  """
  def list_announcements(params \\ %{})

  def list_announcements(opts) when is_list(opts) do
    Announcement
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_announcements(flop) do
    Flop.validate_and_run(Announcement, flop, for: Announcement)
  end

  def list_announcements(%{} = flop, opts) when is_list(opts) do
    Announcement
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Announcement)
  end

  @doc """
  Gets a single announcement.

  Raises `Ecto.NoResultsError` if the Announcement does not exist.

  ## Examples

      iex> get_announcement!(123)
      %Announcement{}

      iex> get_announcement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_announcement!(id, preloads \\ []),
    do: Repo.get!(Announcement, id) |> Repo.preload(preloads)

  @doc """
  Creates a announcement.

  ## Examples

      iex> create_announcement(%{field: value})
      {:ok, %Announcement{}}

      iex> create_announcement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_announcement(attrs \\ %{}) do
    %Announcement{}
    |> Announcement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a announcement.

  ## Examples

      iex> update_announcement(announcement, %{field: new_value})
      {:ok, %Announcement{}}

      iex> update_announcement(announcement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_announcement(%Announcement{} = announcement, attrs) do
    announcement
    |> Announcement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a announcement.

  ## Examples

      iex> delete_announcement(announcement)
      {:ok, %Announcement{}}

      iex> delete_announcement(announcement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_announcement(%Announcement{} = announcement) do
    Repo.delete(announcement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking announcement changes.

  ## Examples

      iex> change_announcement(announcement)
      %Ecto.Changeset{data: %Announcement{}}

  """
  def change_announcement(%Announcement{} = announcement, attrs \\ %{}) do
    Announcement.changeset(announcement, attrs)
  end
end
