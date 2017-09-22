#[macro_use]
extern crate error_chain;
extern crate schannel;
extern crate base64;

use schannel::cert_store::CertStore;
use schannel::cert_context::ValidUses;

mod errors {
    error_chain!{}
}

use errors::*;

fn run() -> Result<()> {
    let mut store = CertStore::open_current_user("ROOT")
        .chain_err(|| "could not open Windows Certificate Store")?;

    for cert in store.certs() {
        let friendly_name = cert.friendly_name().unwrap_or_default();
        let valid_uses = cert.valid_uses()
            .chain_err(|| {
                format!("failed checking valid uses for cert {}", friendly_name)
            })?;

        // check the extended key usage for the "Server Authentication" OID
        // pub const szOID_PKIX_KP_SERVER_AUTH: &'static str = "1.3.6.1.5.5.7.3.1"
        let is_server_auth = match valid_uses {
            ValidUses::All => true,
            ValidUses::Oids(ref oids) => oids.contains(&"1.3.6.1.5.5.7.3.1".to_owned()),
        };

        if !is_server_auth {
            continue;
        }

        println!(
            "{}\n{}\n{}\n",
            friendly_name,
            "=".repeat(friendly_name.len()),
            cert.to_pem().chain_err(|| "could not format cert as pem")?
        );

    }
    Ok(())
}

quick_main!(run);
