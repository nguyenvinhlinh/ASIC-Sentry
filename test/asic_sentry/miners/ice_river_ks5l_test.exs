defmodule AsicSentry.Miners.IceRiverKS5LTest do
  use ExUnit.Case, async: true

  setup_all do
    %{body_response_map: sample_body_response_map()}
  end

  test "get_hashrate_list/1",
    %{body_response_map: body_response_map} do
    expected_result = [11258, 10945]
    test_result = AsicSentry.Miners.IceRiverKS5L.get_hashrate_list(body_response_map)
    assert expected_result == test_result
  end

  test "get_pool_rejection_rate/1",
    %{body_response_map: body_response_map} do
    expected_result = 0.010567
    test_result = AsicSentry.Miners.IceRiverKS5L.get_pool_rejection_rate(body_response_map)
    assert expected_result == test_result
  end

  test "get_runtime/1",
    %{body_response_map: body_response_map} do
    expected_result = "62:14:17:36"
    test_result = AsicSentry.Miners.IceRiverKS5L.get_runtime(body_response_map)
    assert expected_result == test_result
  end

  test "get_pools_address_list/1",
    %{body_response_map: body_response_map} do
    expected_result = ["stratum+tcp://asia1.kaspa-pool.org:4444",
                       "stratum+tcp://192.168.1.9:5555",
                       "stratum+tcp://us1.kaspa-pool.org:4444"]
    test_result = AsicSentry.Miners.IceRiverKS5L.get_pools_address_list(body_response_map)
    assert expected_result == test_result
  end

  test "get_pools_user_list/1",
    %{body_response_map: body_response_map} do
    expected_result = ["user_1",
                       "user_2",
                       "user_3"]
    test_result = AsicSentry.Miners.IceRiverKS5L.get_pools_user_list(body_response_map)
    assert expected_result == test_result
  end

  test "get_pools_state_list/1",
    %{body_response_map: body_response_map} do
    expected_result = ["Connected",
                       "Unconnected",
                       "Unconnected"]
    test_result = AsicSentry.Miners.IceRiverKS5L.get_pools_state_list(body_response_map)
    assert expected_result == test_result
  end

  test "get_pools_accepted_share_list/1",
    %{body_response_map: body_response_map} do
    expected_result = [0, 1, 2]
    test_result = AsicSentry.Miners.IceRiverKS5L.get_pools_accepted_share_list(body_response_map)
    assert expected_result == test_result
  end

  test "get_pools_rejected_share_list/1",
    %{body_response_map: body_response_map} do
    expected_result = [10,11,12]
    test_result = AsicSentry.Miners.IceRiverKS5L.get_pools_rejected_share_list(body_response_map)
    assert expected_result == test_result
  end

  test "get_hashboard_5m_list/1",
    %{body_response_map: body_response_map} do
    expected_result = [1.5, 2.6, 3.7]
    test_result = AsicSentry.Miners.IceRiverKS5L.get_hashboard_5m_list(body_response_map)
    assert expected_result == test_result
  end

  test "get_hashboard_30m_list/1",
    %{body_response_map: body_response_map} do
    expected_result = [10.5, 20.6, 30.7]
    test_result = AsicSentry.Miners.IceRiverKS5L.get_hashboard_30m_list(body_response_map)
    assert expected_result == test_result
  end

  test "get_hashboard_temp_list/1",
    %{body_response_map: body_response_map} do
    expected_result = [10, 11, 20, 21, 30, 31]
    test_result = AsicSentry.Miners.IceRiverKS5L.get_hashboard_temp_list(body_response_map)
    assert expected_result == test_result
  end

  test "get_fan_speed_list/1",
    %{body_response_map: body_response_map} do
    expected_result = [5900, 5855, 5901, 5856]
    test_result = AsicSentry.Miners.IceRiverKS5L.get_fan_speed_list(body_response_map)
    assert expected_result == test_result
  end

  test "get_firmware_version/1",
    %{body_response_map: body_response_map} do
    expected_result = "Factory BOOT_3_1 image_1.0"
    test_result = AsicSentry.Miners.IceRiverKS5L.get_firmware_version(body_response_map)
    assert expected_result == test_result
  end

  test "get_software_version/1",
    %{body_response_map: body_response_map} do
    expected_result = "ICM168_3_2_10_ks5L_miner ICM168_3_2_10_ks5L_bg"
    test_result = AsicSentry.Miners.IceRiverKS5L.get_software_version(body_response_map)
    assert expected_result == test_result
  end

  def sample_body_response_map do
    %{
      "data" => %{
        "algo" => "none",
        "avgpow" => "10945G",
        "boards" => [
          %{
            "avgpow" => "10.5G",
            "chipnum" => 18.0,
            "chipsuc" => 0.0,
            "error" => 0.0,
            "false" => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
                        18],
            "freq" => 875.0,
            "idealpow" => "0.00G",
            "intmp" => 10.0,
            "no" => 1.0,
            "outtmp" => 11.0,
            "pcbtemp" => "0.00-0.00-0.00-0.00",
            "rtpow" => "1.5G",
            "state" => true,
            "tempnum" => "(null)"
          },
          %{
            "avgpow" => "20.6G",
            "chipnum" => 18.0,
            "chipsuc" => 0.0,
            "error" => 0.0,
            "false" => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
                        18],
            "freq" => 875.0,
            "idealpow" => "0.00G",
            "intmp" => 20.0,
            "no" => 2.0,
            "outtmp" => 21.0,
            "pcbtemp" => "0.00-0.00-0.00-0.00",
            "rtpow" => "2.6G",
            "state" => true,
            "tempnum" => "(null)"
          },
          %{
            "avgpow" => "30.7G",
            "chipnum" => 18.0,
            "chipsuc" => 0.0,
            "error" => 0.0,
            "false" => [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17,
                        18],
            "freq" => 875.0,
            "idealpow" => "0.00G",
            "intmp" => 30.0,
            "no" => 3.0,
            "outtmp" => 31.0,
            "pcbtemp" => "0.00-0.00-0.00-0.00",
            "rtpow" => "3.7G",
            "state" => true,
            "tempnum" => "(null)"
          }
        ],
        "dhcp" => false,
        "dns" => "1.1.1.1",
        "fans" => [5900, 5855, 5901, 5856],
        "fanstate" => true,
        "firmtype" => "Factory",
        "firmver1" => "BOOT_3_1",
        "firmver2" => "image_1.0",
        "gateway" => "192.168.1.1fe80::1",
        "host" => "XJGXG_SSYYGB",
        "ip" => "192.168.1.10",
        "locate" => false,
        "mac" => "00:0a:52:30:04:ba",
        "model" => "none",
        "netmask" => "255.255.255.0",
        "netstate" => true,
        "nic" => "eth0",
        "online" => true,
        "pools" => [
          %{
            "accepted" => 0.0,
            "addr" => "stratum+tcp://asia1.kaspa-pool.org:4444",
            "connect" => 1.0,
            "diff" => "140737.49 G",
            "diffa" => 0.0,
            "diffr" => 0.0,
            "lsdiff" => 0.0,
            "lstime" => "00:00:00",
            "no" => 1.0,
            "pass" => "x",
            "priority" => 1.0,
            "rejected" => 10.0,
            "state" => 1.0,
            "user" => "user_1"
          },
          %{
            "accepted" => 1.0,
            "addr" => "stratum+tcp://192.168.1.9:5555",
            "connect" => -1.0,
            "diff" => "0.00 G",
            "diffa" => 0.0,
            "diffr" => 0.0,
            "lsdiff" => 0.0,
            "lstime" => "00:00:00",
            "no" => 2.0,
            "pass" => "x",
            "priority" => 2.0,
            "rejected" => 11.0,
            "state" => 0.0,
            "user" => "user_2"
          },
          %{
            "accepted" => 2.0,
            "addr" => "stratum+tcp://us1.kaspa-pool.org:4444",
            "connect" => -1.0,
            "diff" => "0.00 G",
            "diffa" => 0.0,
            "diffr" => 0.0,
            "lsdiff" => 0.0,
            "lstime" => "00:00:00",
            "no" => 3.0,
            "pass" => "x",
            "priority" => 3.0,
            "rejected" => 12.0,
            "state" => 0.0,
            "user" => "user_3"
          }
        ],
        "pows" => %{
          "board1" => [10789, 9851, 7975, 15011, 13604, 4691, 11258, 8444, 10320,
                       10789, 10789, 11728, 11728, 6567, 10320, 11728, 9851, 8444, 13604, 8913,
                       12197, 11258, 11258]
        },
        "pows_x" => ["0 mins", "5 mins", "10 mins", "15 mins", "20 mins", "25 mins",
                     "30 mins", "35 mins", "40 mins", "45 mins", "50 mins", "55 mins",
                     "60 mins", "65 mins", "70 mins", "75 mins", "80 mins", "85 mins",
                     "90 mins", "95 mins", "100 mins", "105 mins", "110 mins"],
        "powstate" => true,
        "refTime" => "2024-05-20 01:24:45 UTC",
        "reject" => 0.010567,
        "rtpow" => "11258G",
        "runtime" => "62:14:17:36",
        "softver1" => "ICM168_3_2_10_ks5L_miner",
        "softver2" => "ICM168_3_2_10_ks5L_bg",
        "tempstate" => false,
        "unit" => "G"
      },
      "error" => 0,
      "message" => ""
    }
  end
end
