defmodule ContactAppWeb.ContactHTML do
  use ContactAppWeb, :html
  
  embed_templates "contact_html/*"

  def get_errors_for(%Ecto.Changeset{action: nil} = _changeset, _), do: ""
  def get_errors_for(changeset, attribute) do
    case changeset.errors[attribute] do
      {message, _} ->
        attribute_name = Atom.to_string(attribute) |> String.capitalize()
        "#{attribute_name} #{message}"

      nil -> ""
    end
  end
end
