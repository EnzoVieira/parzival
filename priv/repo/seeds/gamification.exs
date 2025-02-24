defmodule Parzival.Repo.Seeds.Gamification do
  import Ecto.Query

  alias Parzival.Repo
  alias Parzival.Accounts.User
  alias Parzival.Gamification.Curriculum
  alias Parzival.Gamification.Mission
  alias Parzival.Gamification.Mission.Dificulty
  alias Parzival.Gamification.Mission.MissionUser
  alias Parzival.Gamification.Mission.Task
  alias Parzival.Gamification.Mission.TaskUser

  @education_titles File.read!("priv/fake/uminho_courses.txt") |> String.split("\n")
  @languages File.read!("priv/fake/languages.txt") |> String.split("\n")
  @universities File.read!("priv/fake/universities.txt") |> String.split("\n")

  def run do
    seed_curriculums()
    seed_dificulties()
    seed_missions()
    seed_tasks()
    seed_missions_users()
    seed_tasks_users()
  end

  def seed_curriculums do
    case Repo.all(Curriculum) do
      [] ->
        attendees =
          User
          |> where(role: :attendee)
          |> Repo.all()

        education_titles = Enum.shuffle(@education_titles)
        laguanges = Enum.shuffle(@languages)
        universities = Enum.shuffle(@universities)

        for attendee <- attendees do
          Curriculum.changeset(%Curriculum{}, %{
            summary: Faker.Lorem.sentence(20..40),
            user_id: attendee.id,
            experience:
              Enum.reduce(
                List.duplicate(:experience, Enum.random(1..3)),
                [],
                fn _n, acc ->
                  [
                    %{
                      organization: Faker.Company.name(),
                      positions:
                        Enum.reduce(
                          List.duplicate(:position, Enum.random(1..4)),
                          [],
                          fn _next, acc ->
                            [
                              %{
                                title: Faker.Person.title(),
                                start: Faker.DateTime.between(~D[2018-04-11], ~D[2021-04-11]),
                                finish:
                                  Faker.DateTime.between(
                                    ~D[2021-04-11],
                                    Date.utc_today()
                                  ),
                                current: Enum.random([true, false, false, false])
                              }
                              | acc
                            ]
                          end
                        )
                    }
                    | acc
                  ]
                end
              ),
            education:
              Enum.reduce(
                List.duplicate(:education, Enum.random(1..2)),
                [],
                fn _n, acc ->
                  [
                    %{
                      institution: Enum.random(universities),
                      course: Enum.random(education_titles),
                      start: Faker.DateTime.between(~D[2018-04-11], ~D[2021-04-11]),
                      finish:
                        Faker.DateTime.between(
                          ~D[2021-04-11],
                          Date.utc_today()
                        )
                    }
                    | acc
                  ]
                end
              ),
            volunteering:
              Enum.reduce(
                List.duplicate(:voluntary, Enum.random(1..2)),
                [],
                fn _n, acc ->
                  [
                    %{
                      institution: Faker.Company.name(),
                      position: Faker.Person.title(),
                      start: Faker.DateTime.between(~D[2018-04-11], ~D[2021-04-11]),
                      finish:
                        Faker.DateTime.between(
                          ~D[2021-04-11],
                          Date.utc_today()
                        )
                    }
                    | acc
                  ]
                end
              ),
            skills:
              Enum.reduce(
                List.duplicate(:skill, Enum.random(6..12)),
                [],
                fn _n, acc ->
                  [
                    %{
                      name: Faker.Beer.En.brand()
                    }
                    | acc
                  ]
                end
              ),
            languages:
              Enum.reduce(
                List.duplicate(:skill, Enum.random(2..4)),
                [],
                fn _n, acc ->
                  [
                    %{
                      idiom: Enum.random(laguanges),
                      proficiency: Enum.random([:Native, :Fluent, :Intermediary, :Basic])
                    }
                    | acc
                  ]
                end
              )
          })
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found Curriculums, aborting seeding curriculums.")
    end
  end

  def seed_dificulties do
    case Repo.all(Dificulty) do
      [] ->
        [
          %{
            name: "Easy",
            color: "green"
          },
          %{
            name: "Medium",
            color: "orange"
          },
          %{
            name: "Hard",
            color: "red"
          },
          %{
            name: "Exclusive",
            color: "purple"
          }
        ]
        |> Enum.each(&insert_dificulty/1)

      _ ->
        Mix.shell().error("Found Dificulties, aborting seeding dificulties.")
    end
  end

  def insert_dificulty(data) do
    %Dificulty{}
    |> Dificulty.changeset(data)
    |> Repo.insert!()
  end

  def seed_missions do
    case Repo.all(Mission) do
      [] ->
        dificulties =
          Dificulty
          |> Repo.all()

        for _n <- 1..Enum.random(10..30) do
          Mission.changeset(%Mission{}, %{
            title: Faker.Lorem.sentence(5..10),
            description: Faker.Lorem.sentence(20..40),
            tokens: Enum.random(400..600),
            exp: Enum.random(100..800),
            level: Enum.random(1..10),
            dificulty_id: Enum.random(dificulties).id,
            start:
              Faker.NaiveDateTime.between(
                ~N[2022-06-28 09:30:00.000000],
                ~N[2022-06-28 14:00:00.000000]
              ),
            finish:
              Faker.DateTime.between(
                ~N[2022-06-28 14:00:00.000000],
                ~N[2022-06-28 23:59:00.000000]
              )
          })
          |> Repo.insert!()
        end

      _ ->
        Mix.shell().error("Found Missions, aborting seeding missions.")
    end
  end

  def seed_tasks do
    case Repo.all(Task) do
      [] ->
        missions =
          Mission
          |> Repo.all()

        for mission <- missions do
          for _n <- 1..Enum.random(1..5) do
            Task.changeset(%Task{}, %{
              title: Faker.Lorem.sentence(5..10),
              description: Faker.Lorem.sentence(20..40),
              tokens: Enum.random(400..600),
              exp: Enum.random(500..1000),
              mission_id: mission.id
            })
            |> Repo.insert!()
          end
        end

      _ ->
        Mix.shell().error("Found Tasks, aborting seeding tasks")
    end
  end

  def seed_missions_users do
    case Repo.all(MissionUser) do
      [] ->
        missions =
          Mission
          |> Repo.all()

        attendees =
          User
          |> where(role: :attendee)
          |> Repo.all()

        for mission <- missions do
          for attendee <- Enum.take_random(attendees, Enum.random(1..Enum.count(attendees))) do
            MissionUser.changeset(%MissionUser{}, %{
              user_id: attendee.id,
              mission_id: mission.id
            })
            |> Repo.insert!()
          end
        end

      _ ->
        Mix.shell().error("Found MissionsUser, aborting seeding missions_users")
    end
  end

  def seed_tasks_users do
    case Repo.all(TaskUser) do
      [] ->
        tasks =
          Task
          |> Repo.all()

        attendees =
          User
          |> where(role: :attendee)
          |> Repo.all()

        staffs =
          User
          |> where(role: :staff)
          |> Repo.all()

        for task <- Enum.take_random(tasks, Enum.random(1..Enum.count(tasks))) do
          for attendee <- Enum.take_random(attendees, Enum.random(1..Enum.count(attendees))) do
            TaskUser.changeset(%TaskUser{}, %{
              user_id: attendee.id,
              staff_id: Enum.random(staffs).id,
              task_id: task.id
            })
            |> Repo.insert!()
          end
        end

      _ ->
        Mix.shell().error("Found TasksUser, aborting seeding tasks_users")
    end
  end
end

Parzival.Repo.Seeds.Gamification.run()
