# simple-rijndael for Elixir

A binding to the PurePeace's simple-rijndael Rust crate for Elixir.

[![PayPal](https://img.shields.io/badge/Paypal-003087?style=for-the-badge&logo=paypal&logoColor=%23fff)
](https://www.paypal.com/donate/?business=QQGMTC3FQAJF6&no_recurring=0&item_name=Thanks+for+donating+for+me%2C+this+helps+me+a+lot+to+continue+developing+and+maintaining+my+projects.&currency_code=USD)
[![GitHub Sponsor](https://img.shields.io/badge/GitHub%20Sponsor-181717?style=for-the-badge&logo=github&logoColor=%23fff)
](https://github.com/sponsors/nashiradeer)
[![Hex.pm](https://img.shields.io/hexpm/v/simple-rijndael?style=for-the-badge&logo=elixir&logoColor=%23fff&label=Hex.pm&labelColor=%234B275F&color=%234B275F)](https://hex.pm/packages/simple_rijndael)
[![HexDocs.pm](https://img.shields.io/badge/HexDocs.pm-4B275F?style=for-the-badge&logo=elixir&logoColor=%23fff)
](https://hexdocs.pm/simple_rijndael/)

## Motivation

AES has removed the block size of 256 bits from the standard and if a old system is using it AES willn't work (my case) and there's no Rijndael implementations in Erlang or Elixir.

## Installation

**Warning:** You will need the [Rust compiler](https://www.rust-lang.org/tools/install) to compile this package.

This package has been published in [Hex.pm](https://hex.pm/packages/simple_rinjdael) and you can use it with:

```elixir
def deps do
  [
    {:simple_rijndael, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
key = :crypto.strong_rand_bytes(32)
iv = :crypto.strong_rand_bytes(32)

# Padding options:
#   :pkcs7
#   :zero
{:ok, cipher} = SimpleRijndael.init_cbc_mode(key, 32, :pkcs7)

data = "Hello, World!"

{:ok, encrypted} = SimpleRijndael.encrypt(cipher, iv, data)

{:ok, decrypted} = SimpleRijndael.decrypt(cipher, iv, encrypted)

# If an error occour, will be one of the following returns:
#   {:error, :invalid_data_size}
#   {:error, :invalid_key_size}
#   {:error, :invalid_block_size}
#
# Or an exception of ErlangError with reason == nil and original == :nif_panicked
```
## Credits

**Simple Rijndael for Elixir** is a project by [Nashira Deer](https://github.com/nashiradeer), licensed under [MIT License](https://github.com/nashiradeer/simple-rijndael-4elixir/blob/main/LICENSE.txt).
