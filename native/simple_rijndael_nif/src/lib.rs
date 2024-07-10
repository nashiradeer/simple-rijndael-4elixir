//! A NIF library for [simple_rijndael] crate.

use std::{io::Write, ops::Deref};

use rustler::{types::atom, Atom, Binary, Env, Error, NifUnitEnum, OwnedBinary, ResourceArc, Term};
use simple_rijndael::{
    impls::RijndaelCbc,
    paddings::{Pkcs7Padding, ZeroPadding},
    Errors,
};

mod atoms {
    //! Atoms for the NIF library.

    rustler::atoms! {
        invalid_data_size,
        invalid_block_size,
        invalid_key_size,
    }
}

/// Padding for [Rijndael] cipher.
#[derive(NifUnitEnum)]
enum RijndaelPadding {
    /// PKCS7 padding.
    Pkcs7,
    /// Zero padding.
    Zero,
}

/// A enum wrapping [RijndaelCbc], because the padding is set by generics and [rustler] doesn't support generics.
enum Rijndael {
    /// Rijndael with PKCS7 padding, wraps [RijndaelCbc] with [Pkcs7Padding].
    CbcPkcs7(RijndaelCbc<Pkcs7Padding>),
    /// Rijndael with Zero padding, wraps [RijndaelCbc] with [ZeroPadding].
    CbcZero(RijndaelCbc<ZeroPadding>),
}

/// Executes when the NIF library is loaded.
fn load(env: Env, _: Term) -> bool {
    _ = rustler::resource!(Rijndael, env);
    true
}

/// Converts an [Errors] to an [Atom].
fn error_to_atom(error: Errors) -> Atom {
    match error {
        Errors::InvalidDataSize => atoms::invalid_data_size(),
        Errors::InvalidBlockSize => atoms::invalid_block_size(),
        Errors::InvalidKeySize => atoms::invalid_key_size(),
    }
}

/// Wraps an [Errors] from [simple_rijndael] into a [Error] from [rustler].
fn wrap_error(error: Errors) -> Error {
    Error::Term(Box::new(error_to_atom(error)))
}

/// Initializes a [Rijndael] cipher with CBC mode.
#[rustler::nif]
fn init_cbc_mode(
    key: Binary,
    block_size: usize,
    padding: RijndaelPadding,
) -> Result<(Atom, ResourceArc<Rijndael>), Error> {
    let cipher = match padding {
        RijndaelPadding::Pkcs7 => {
            Rijndael::CbcPkcs7(RijndaelCbc::new(key.as_slice(), block_size).map_err(wrap_error)?)
        }
        RijndaelPadding::Zero => {
            Rijndael::CbcZero(RijndaelCbc::new(key.as_slice(), block_size).map_err(wrap_error)?)
        }
    };

    Ok((atom::ok(), ResourceArc::new(cipher)))
}

/// Decrypts data with a [Rijndael] cipher.
#[rustler::nif]
fn decrypt<'a>(
    env: Env<'a>,
    cipher: ResourceArc<Rijndael>,
    iv: Binary<'a>,
    data: Binary<'a>,
) -> Result<(Atom, Binary<'a>), Error> {
    let decypted = match cipher.deref() {
        Rijndael::CbcPkcs7(inner) => inner
            .decrypt(iv.as_slice(), Vec::from(data.as_slice()))
            .map_err(wrap_error)?,
        Rijndael::CbcZero(inner) => inner
            .decrypt(iv.as_slice(), Vec::from(data.as_slice()))
            .map_err(wrap_error)?,
    };

    let mut binary = OwnedBinary::new(decypted.len()).unwrap();
    _ = binary.as_mut_slice().write_all(&decypted);

    Ok((atom::ok(), binary.release(env)))
}

/// Encrypts data with a [Rijndael] cipher.
#[rustler::nif]
fn encrypt<'a>(
    env: Env<'a>,
    cipher: ResourceArc<Rijndael>,
    iv: Binary<'a>,
    data: Binary<'a>,
) -> Result<(Atom, Binary<'a>), Error> {
    let encrypted = match cipher.deref() {
        Rijndael::CbcPkcs7(inner) => inner
            .encrypt(iv.as_slice(), Vec::from(data.as_slice()))
            .map_err(wrap_error)?,
        Rijndael::CbcZero(inner) => inner
            .encrypt(iv.as_slice(), Vec::from(data.as_slice()))
            .map_err(wrap_error)?,
    };

    let mut binary = OwnedBinary::new(encrypted.len()).unwrap();
    _ = binary.as_mut_slice().write_all(&encrypted);

    Ok((atom::ok(), binary.release(env)))
}

rustler::init!("Elixir.SimpleRijndael", load = load);
