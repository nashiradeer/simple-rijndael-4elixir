defmodule SimpleRijndaelTest do
  use ExUnit.Case, async: true
  doctest SimpleRijndael

  test "test normal workflow" do
    key = :crypto.strong_rand_bytes(32)
    iv = :crypto.strong_rand_bytes(32)

    {:ok, cipher} = SimpleRijndael.init_cbc_mode(key, 32, :pkcs7)

    data = "Hello, World!"

    {:ok, encrypted} = SimpleRijndael.encrypt(cipher, iv, data)
    assert encrypted != data

    {:ok, decrypted} = SimpleRijndael.decrypt(cipher, iv, encrypted)
    assert decrypted == data
  end

  test "test invalid decrypt key" do
    key = :crypto.strong_rand_bytes(32)
    iv = :crypto.strong_rand_bytes(32)

    {:ok,encrypt_cipher} = SimpleRijndael.init_cbc_mode(key, 32, :pkcs7)
    data = "Hello, World!"
    {:ok, encrypted} = SimpleRijndael.encrypt(encrypt_cipher, iv, data)
    assert encrypted != data

    invalid_key = :crypto.strong_rand_bytes(32)
    {:ok, decrypt_cipher} = SimpleRijndael.init_cbc_mode(invalid_key, 32, :pkcs7)

    try do
      _ = SimpleRijndael.decrypt(decrypt_cipher, iv, encrypted)
    rescue
      e in ErlangError -> assert e.original == :nif_panicked
    end
  end

  test "test invalid decrypt iv" do
    key = :crypto.strong_rand_bytes(32)

    {:ok, cipher} = SimpleRijndael.init_cbc_mode(key, 32, :pkcs7)

    data = "Hello, World!"

    iv = :crypto.strong_rand_bytes(32)
    {:ok, encrypted} = SimpleRijndael.encrypt(cipher, iv, data)
    assert encrypted != data

    invalid_iv = :crypto.strong_rand_bytes(32)

    try do
      _ = SimpleRijndael.decrypt(cipher, invalid_iv, encrypted)
    rescue
      e in ErlangError -> assert e.original == :nif_panicked
    end
  end

  test "test invalid data size" do
    key = :crypto.strong_rand_bytes(32)
    iv = :crypto.strong_rand_bytes(32)

    {:ok, cipher} = SimpleRijndael.init_cbc_mode(key, 32, :pkcs7)

    invalid_data = :crypto.strong_rand_bytes(4)

    {:error, err} = SimpleRijndael.decrypt(cipher, iv, invalid_data)
    assert err == :invalid_data_size
  end

  test "test invalid key size" do
    invalid_key = :crypto.strong_rand_bytes(4)

    {:error, err} = SimpleRijndael.init_cbc_mode(invalid_key, 32, :pkcs7)
    assert err == :invalid_key_size
  end

  test "test invalid iv size" do
    key = :crypto.strong_rand_bytes(32)
    invalid_iv = :crypto.strong_rand_bytes(4)

    {:ok, cipher} = SimpleRijndael.init_cbc_mode(key, 32, :pkcs7)

    data = "Hello, World!"

    try do
      _ = SimpleRijndael.encrypt(cipher, invalid_iv, data)
    rescue
      e in ErlangError -> assert e.original == :nif_panicked
    end
  end

  test "test invalid block size" do
    key = :crypto.strong_rand_bytes(32)

    {:error, err} = SimpleRijndael.init_cbc_mode(key, 4, :pkcs7)
    assert err == :invalid_block_size
  end
end
