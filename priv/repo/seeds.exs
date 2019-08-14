# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Jarmotion.Repo.insert!(%Jarmotion.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Jarmotion.Schemas.User
password = Bcrypt.hash_pwd_salt("test")

user_id_1 = Ecto.UUID.generate()
user_id_2 = Ecto.UUID.generate()

Jarmotion.Repo.UserRepo.insert(%User{
  id: user_id_1,
  email: "chakrit.lj@gmail.com",
  password: password,
  name: "chris"
})

Jarmotion.Repo.UserRepo.insert(%User{
  id: user_id_2,
  email: "awa@gmail.com",
  password: password,
  name: "awa"
})

Jarmotion.Repo.RelationshipRepo.insert(%Jarmotion.Schemas.Relationship{
  user_id_1: user_id_1,
  user_id_2: user_id_2
})
