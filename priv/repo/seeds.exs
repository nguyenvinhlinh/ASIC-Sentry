# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     AsicSentry.Repo.insert!(%AsicSentry.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias AsicSentry.AsicMiners.AsicMiner
alias AsicSentry.Repo

Repo.delete_all(AsicMiner)
%AsicMiner{ip: "192.168.1.2", api_code: "9df4228e107c3a26008d920ad03e01a3", asic_model: "Ice River - KS5L"} |> Repo.insert!
%AsicMiner{ip: "192.168.1.3", api_code: "070bfdda68b76e37898c2f8e4e86cb25", asic_model: "Ice River - KS5L"} |> Repo.insert!
