defmodule Parzival.Repo.Seeds.Tools do
  import Ecto.Query

  alias Parzival.Repo

  alias Parzival.Accounts.User

  alias Parzival.Tools.Faq
  alias Parzival.Tools.Announcement

  def run do
    seed_faqs()
  end

  def seed_faqs do
    case Repo.all(Faq) do
      [] ->
        [
          %{
            question: "Is JOIN attendance free?",
            answer: "Yes! JOIN is completly free."
          },
          %{
            question: "I am not a student, can I attend the event?",
            answer:
              "Yes! JOIN is open to all the community. Everyone can register and participate in our talks and most contests. Please check our general regulation to know in which contests you can qualify for prizes."
          },
          %{
            question: "How can I contact the JOIN team?",
            answer:
              "You can e-mail us to join@di.uminho.org or leave a message on our social media accounts."
          },
          %{
            question: "Where will the event take place?",
            answer: "JOIN will be at the Departamento de Informática at Universidade do Minho"
          }
        ]
        |> Enum.each(&Repo.insert!(Faq.changeset(%Faq{}, &1)))

      _ ->
        Mix.shell().error("Found faqs, aborting seeding faqs.")
    end
  end

  def seed_announcements do
    admins = Repo.all(where(User, role: :admin))

    case Repo.all(Announcement) do
      [] ->
        for _n <- 1..40 do
          Announcement.changeset(
            %Announcement{},
            %{
              title: Faker.Lorem.sentence(3..5),
              text: Faker.Lorem.sentence(200..400),
              author_id: Enum.random(admins).id
            }
          )
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found announcements, aborting seeding announcements.")
    end
  end
end

Parzival.Repo.Seeds.Tools.run()
