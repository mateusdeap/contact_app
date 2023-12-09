defmodule ContactAppWeb.ContactController do
  use ContactAppWeb, :controller

  alias ContactApp.Contacts
  alias ContactApp.Contacts.Contact
  
  def index(conn, _params) do
    contacts = Contacts.list_contacts("")
    render(conn, :index, contacts: contacts)
  end

  def new(conn, _params) do
    changeset = Contacts.change_contact(%Contact{})
    csrf_token = get_csrf_token()
    render(conn, :new, changeset: changeset, token: csrf_token)
  end

  def create(conn, %{"contact" => contact_params}) do
    case Contacts.create_contact(contact_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Contact created successfully")
        |> redirect(to: ~p"/contacts")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset, token: get_csrf_token())
    end
  end

  def show(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    render(conn, :show, contact: contact)
  end

  def edit(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    changeset = Contacts.change_contact(contact)
    render(conn, :edit, contact: contact, changeset: changeset, token: get_csrf_token())
  end

  def update(conn, %{"id" => id, "contact" => contact_params}) do
    contact = Contacts.get_contact!(id)

    case Contacts.update_contact(contact, contact_params) do
      {:ok, contact} ->
        conn
        |> put_flash(:info, "Contact update successfully.")
        |> redirect(to: ~p"/contacts/#{contact}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, contact: contact, changeset: changeset, token: get_csrf_token())
    end
  end

  def delete(conn, %{"id" => id}) do
    contact = Contacts.get_contact!(id)
    {:ok, _contact} = Contacts.delete_contact(contact)

    conn
    |> put_flash(:info, "Contact deleted successfully.")
    |> redirect(to: ~p"/contacts")
  end
end