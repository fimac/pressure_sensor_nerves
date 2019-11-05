defmodule Pressure do
  @moduledoc """
  Documentation for Pressure.
  """
  alias Pigpiox.Pwm
  alias Circuits.SPI

  @led_pin 20

  def start(_type, _args) do
    {:ok, ref} = SPI.open("spidev0.0")
    check_sensor(ref)
  end

  def check_sensor(ref) do
    {:ok, <<_::size(14), count::size(10)>>} = SPI.transfer(ref, <<0x01, 0x80, 0x00>>)
    
    data = scale_count(count)
    Pwm.gpio_pwm(@led_pin, data)

    check_sensor(ref)
  end

  def scale_count(count) do
    count / 10 |> round()
  end
end
