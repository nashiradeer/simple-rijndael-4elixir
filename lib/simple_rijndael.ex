defmodule SimpleRijndael do
  use Rustler,
    otp_app: :simple_rijndael,
    crate: :simple_rijndael_nif

  def add(_arg1, _arg2), do: :erlang.nif_error(:nif_not_loaded)
end
