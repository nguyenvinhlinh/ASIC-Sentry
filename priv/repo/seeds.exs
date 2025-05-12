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
alias AsicSentry.Configs.Config
alias AsicSentry.Repo


Repo.delete_all(AsicMiner)
%AsicMiner{ip: "192.168.1.2", api_code: "9df4228e-107c3a26-008d920a-d03e01a3",
           asic_model: "Ice River - KS5L", asic_expected_status: "on",
           light_expected_status: "off"} |> Repo.insert!
%AsicMiner{ip: "192.168.1.3", api_code: "070bfdda-68b76e37-898c2f8e-4e86cb25",
           asic_model: "Ice River - KS5L", asic_expected_status: "off",
           light_expected_status: "on"} |> Repo.insert!

Repo.delete_all(Config)
%Config{key: "mininig_rig_commander_api_url", value: "http://mining-rig-monitor.xyz/api/v1"} |> Repo.insert!
