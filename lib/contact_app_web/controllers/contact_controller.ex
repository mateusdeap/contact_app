defmodule ContactAppWeb.ContactController do
  use ContactAppWeb, :controller

  alias ContactApp.Contacts
  alias ContactApp.Contacts.Contact
  
  def index(conn, %{"page" => page_param}) do
    page = String.to_integer(page_param)
    contacts = Contacts.list_contacts(page)
    render(conn, :index, contacts: contacts, page: page)
  end
  def index(conn, %{"q" => q}) do
    contacts = Contacts.list_contacts(q)
    case Plug.Conn.get_req_header(conn, "hx-trigger") do
      [] -> render(conn, :index, contacts: contacts)
      ["search"] ->
        put_root_layout(conn, false)
        |> render(:rows, contacts: contacts, layout: false)
    end
  end
  def index(conn, %{}) do
    contacts = Contacts.list_contacts(1)
    render(conn, :index, contacts: contacts, page: 1)
  end

  def count(conn, _params) do
    count = Contacts.count()
    text(conn, "(#{count} total Contacts)")
  end

  def new(conn, _params) do
    changeset = Contacts.change_contact(%Contact{})
    render(conn, :new, changeset: changeset)
  end

  def email(conn, %{"contact" => contact_params}) do
    changeset = Contacts.change_contact(%Contact{}, contact_params)
    text(conn, get_errors_for(changeset, :email))
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

    case Plug.Conn.get_req_header(conn, "hx-trigger") do
      ["delete-btn"] ->
        conn
        |> put_flash(:info, "Contact deleted successfully.")
        |> put_status(303)
        |> redirect(to: ~p"/contacts")

      [] ->
        text(conn, "")
    end
  end

  def get_errors_for(changeset, attribute) do
    case changeset.errors[attribute] do
      {message, _} ->
        attribute_name = Atom.to_string(attribute) |> String.capitalize()
        "#{attribute_name} #{message}"

      nil -> ""
    end
  end
end
