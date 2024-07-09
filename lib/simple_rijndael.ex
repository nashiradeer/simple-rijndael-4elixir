defmodule SimpleRijndael do
  use Rustler,
    otp_app: :simple_rijndael,
    crate: :simple_rijndael_nif

  def init_cbc_mode(_key, _block_size, _padding), do: :erlang.nif_error(:nif_not_loaded)

  def decrypt(_cipher, _iv, _data), do: :erlang.nif_error(:nif_not_loaded)

  def encrypt(_cipher, _iv, _data), do: :erlang.nif_error(:nif_not_loaded)
end
