use std::{io::Write, ops::Deref};

use rustler::{Binary, Env, NifUnitEnum, OwnedBinary, ResourceArc, Term};
use simple_rijndael::{
    impls::RijndaelCbc,
    paddings::{Pkcs7Padding, ZeroPadding},
};

#[derive(NifUnitEnum)]
enum RijndaelPadding {
    Pkcs7,
    Zero,
}

enum Rijndael {
    CbcPkcs7(RijndaelCbc<Pkcs7Padding>),
    CbcZero(RijndaelCbc<ZeroPadding>),
}

fn load(env: Env, _: Term) -> bool {
    rustler::resource!(Rijndael, env);
    true
}

#[rustler::nif]
fn init_cbc_mode(
    key: Binary,
    block_size: usize,
    padding: RijndaelPadding,
) -> ResourceArc<Rijndael> {
    let cipher = match padding {
        RijndaelPadding::Pkcs7 => {
            Rijndael::CbcPkcs7(RijndaelCbc::new(key.as_slice(), block_size).unwrap())
        }
        RijndaelPadding::Zero => {
            Rijndael::CbcZero(RijndaelCbc::new(key.as_slice(), block_size).unwrap())
        }
    };

    ResourceArc::new(cipher)
}

#[rustler::nif]
fn decrypt<'a>(
    env: Env<'a>,
    cipher: ResourceArc<Rijndael>,
    iv: Binary<'a>,
    data: Binary<'a>,
) -> Binary<'a> {
    let decypted = match cipher.deref() {
        Rijndael::CbcPkcs7(inner) => inner
            .decrypt(iv.as_slice(), Vec::from(data.as_slice()))
            .unwrap(),
        Rijndael::CbcZero(inner) => inner
            .decrypt(iv.as_slice(), Vec::from(data.as_slice()))
            .unwrap(),
    };

    let mut binary = OwnedBinary::new(decypted.len()).unwrap();
    _ = binary.as_mut_slice().write_all(&decypted);
    binary.release(env)
}

#[rustler::nif]
fn encrypt<'a>(
    env: Env<'a>,
    cipher: ResourceArc<Rijndael>,
    iv: Binary<'a>,
    data: Binary<'a>,
) -> Binary<'a> {
    let encrypted = match cipher.deref() {
        Rijndael::CbcPkcs7(inner) => inner
            .encrypt(iv.as_slice(), Vec::from(data.as_slice()))
            .unwrap(),
        Rijndael::CbcZero(inner) => inner
            .encrypt(iv.as_slice(), Vec::from(data.as_slice()))
            .unwrap(),
    };

    let mut binary = OwnedBinary::new(encrypted.len()).unwrap();
    _ = binary.as_mut_slice().write_all(&encrypted);
    binary.release(env)
}

rustler::init!(
    "Elixir.SimpleRijndael",
    [init_cbc_mode, decrypt, encrypt],
    load = load
);
