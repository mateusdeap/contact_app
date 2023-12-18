defmodule ContactApp.Contacts do
  import Ecto.Query, warn: false
  alias ContactApp.Repo

  alias ContactApp.Contacts.Contact

  def list_contacts(""), do: Repo.all(Contact)
  def list_contacts(page) when is_integer(page) do
    Repo.all(from c in Contact, limit: 10, offset: ^(page - 1)*10)
  end
  def list_contacts(query) do
    Repo.all(
      from c in Contact,
        where: ilike(c.first_name, ^"%#{query}%"),
        or_where: ilike(c.last_name, ^"%#{query}%")
    )
  end

  def get_contact!(id), do: Repo.get!(Contact, id)

  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  def update_contact(%Contact{} = contact, attrs) do
    contact
    |> Contact.changeset(attrs)
    |> Repo.update()
  end

  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  def change_contact(%Contact{} = contact, attrs \\ %{}) do
    Contact.changeset(contact, attrs)
  end

  def count() do
    from(c in Contact, select: count(c))
    |> Repo.one
  end
end
