# ACME Ansible F5 XC

F5 XC natively supports ACMEv2 DNS-01, but if DNS is not in your direct control, HTTP-01 can be a good alternative to managing certificates, but it is not natively supported in XC today.

This playbook demonstrates that it is possible to use ACMEv2 HTTP-01 challenge to manage certificates in F5 XC.  This playbook deploys LBs that have a direct response configured, to fake a backend application.  In a real deployment, the LB configurations should be adapted for your requirements.

## Warning

This is intended for demonstration purposes.  The process of creating, signing and deploying certificates may not comply with your organisation security policies, so please take care to review the configuration parameters and workflow, and update as necessary.

## Prerequisites

- You must have access to an F5 XC Account with permissions to create LB and Certificates within an application/user namespace.
- This playbook uses the `inventory` to manage and iterate over the certificates to be managed.
  - `inventory.example` can be renamed to `inventory` and used as a starting point.
  - `inventory` contains two main sections `[manage_certs]` and `[revoke_certs]`:
    - `[manage_certs]` should contain a list of certificate CNs that you want to manage (create and auto-renew, plus XC deployment of LBs and certs).
    - `[revoke_certs]` should contain a list of certificate CNs that you want to revoke (Let's Encrypt will add cert to OSCP list, and the playbook will decomission the LBs and certs).
- You need to update the vars in the `/vars/vars.yaml.example`, and rename to `/vars/vars.yaml`.
  - Make sure you start with the ACME staging servers while testing/demoing.
- Generate an F5 XC API Token (https://my.f5.com/manage/s/article/K000147972).
- Create a DNS record for the LB (this playbook does not manage DNS for you).  Alternatively you could use a wildcard DNS service, matching the HTTP public VIP e.g. my.name.18.130.10.18.nip.io.

## Useage

To run the playbook, use `ansible-playbook main.yaml -i inventory`.

Running the playbook will perform the following tasks:

`[manage_certs]`

- Re/deploy a basic HTTP LB that provides HTTP access
  - `GET http://<CN>/` returns a static page using a direct response route configured on the LB.
- If debug is enabled, pause and wait for you to check that your DNS resolves and that HTTP works (and HTTPS does not).  Hit enter to continue.
- Generate a new RSA private key to create an account with Let's Encrypt.
- Create an account with Let's Encrypt, using your private key and accept the Terms & Conditions.
- Generate an ECC private key for your application.
- Generates a CSR matching your CN from the ECC private key for your application.
- Creates a Let's Encrypt ACME challenge for your CN using the CSR.
- Re/deploy an XC LB that includes a 'route' that will respond to the Let's Encrypt ACME challenge to your domain LB.
  - `GET http://<CN>/` returns a static page using a direct response route configured on the LB
  - `GET http://<CN>/.well-known/acme-challenge/<resource>` returns a static page containing Let's Encrypt challenge `resource_value` using a direct response route configured on the LB.
- Send ACME request to Let's Encrypt to request validation of the challenge, and if successful, get the signed certificate in response.
- Re/deploy certificate and key (including the validation chain) to XC that should provide HTTPS access using a valid (or staging) Let's Encrypt signed certificate.
- Update HTTP LB to replace ACME challenge route with redirect to HTTP.
  - `GET http://<CN>/` returns a 302 redirect to `https://<CN>/`.
  - `GET https://<CN>/` returns a static page using a direct response route configured on the LB.

`[revoke_certs]`

- Check that the private key exists.
- Revoke the certiificate using the Account Private Key.
  - Alternatively, you can uncomment the `REVOKE CERTIFICATE WITH CERTS PRIVATE KEY` task and use the cert private key instead.
- Delete the F5XC HTTP LB, F5XC HTTPS LB and the certificate and key that was uploaded to F5XC.
- Delete the local copies of the certificates and keys.