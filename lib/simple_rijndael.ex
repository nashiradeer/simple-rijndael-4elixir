defmodule SimpleRijndael do
  @moduledoc """
  Wrapper module to interact with the Rust NIF for the `simple_rijndael` Rust crate.
  """

  @typedoc """
  The error types that can be returned by the NIF.
  """
  @type error :: :invalid_data_size | :invalid_block_size | :invalid_key_size

  @typedoc """
  The padding types that can be used for the Rijndael cipher.
  """
  @type padding :: :pkcs7 | :zero

  use Rustler,
    otp_app: :simple_rijndael,
    crate: :simple_rijndael_nif

  @doc """
  Initializes the low-level Rijndael struct in CBC mode with the given key, block size (in bytes), and padding.
  """
  @spec init_cbc_mode(binary(), non_neg_integer(), padding()) :: {:ok, reference()} | {:error, error()}
  def init_cbc_mode(_key, _block_size, _padding), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Decrypts the given data using the Rijndael cipher and the given initialization vector.
  """
  @spec decrypt(reference(), binary(), binary()) :: {:ok, binary()} | {:error, error()}
  def decrypt(_cipher, _iv, _data), do: :erlang.nif_error(:nif_not_loaded)

  @doc """
  Encrypts the given data using the Rijndael cipher and the given initialization vector.
  """
  @spec encrypt(reference(), binary(), binary()) :: {:ok, binary()} | {:error, error()}
  def encrypt(_cipher, _iv, _data), do: :erlang.nif_error(:nif_not_loaded)
end
