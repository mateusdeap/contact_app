# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ContactApp.Repo.insert!(%ContactApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ContactApp.Repo
alias ContactApp.Contacts.Contact

Repo.insert!(
  %Contact{
    first_name: "Frodo",
    last_name: "Baggins",
    phone: "N/A",
    email: "N/A"
  }
)
Repo.insert!(
  %Contact{
    first_name: "Samwise",
    last_name: "Gamgee",
    phone: "N/A",
    email: "N/A"
  }
)
Repo.insert!(
  %Contact{
    first_name: "Meriadoc",
    last_name: "Brandybuck",
    phone: "N/A",
    email: "N/A"
  }
)
Repo.insert!(
  %Contact{
    first_name: "Peregrin",
    last_name: "Took",
    phone: "N/A",
    email: "N/A"
  }
)
