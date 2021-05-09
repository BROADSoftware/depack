# init

```
/ $ vault operator init
Unseal Key 1: PtbF6eH96VSBcltofm25fMBPnC8jYELSb7cRUFdy5Iqd
Unseal Key 2: 5AP7auhNzCxFjUnGUH4x+8MWb+Lg9PQQ2GF4THPm7EAe
Unseal Key 3: SVi/pYFZ9l6rN4MLlVtca0piIgchhdggfnNklsripDM2
Unseal Key 4: TUNsvFfTfMIZm0H2Jcg9pJgGlhfyMdcBUj/KEGmLqq3p
Unseal Key 5: 2+n99oWoVS35qq1Sx8kHumTqa7VtFQdyQ8e78l7hWDR1

Initial Root Token: s.l7M2VtZX3IHPZew5GmC2POvD

Vault initialized with 5 key shares and a key threshold of 3. Please securely
distribute the key shares printed above. When the Vault is re-sealed,
restarted, or stopped, you must supply at least 3 of these keys to unseal it
before it can start servicing requests.

Vault does not store the generated master key. Without at least 3 key to
reconstruct the master key, Vault will remain permanently sealed!

It is possible to generate new unseal keys, provided you have a quorum of
existing unseal keys shares. See "vault operator rekey" for more information.
```

```

vault status
vault operator init
vault operator unseal PtbF6eH96VSBcltofm25fMBPnC8jYELSb7cRUFdy5Iqd
vault operator unseal 5AP7auhNzCxFjUnGUH4x+8MWb+Lg9PQQ2GF4THPm7EAe
vault operator unseal SVi/pYFZ9l6rN4MLlVtca0piIgchhdggfnNklsripDM2

```

# Regenerate root token

```
$ vault operator generate-root -init
A One-Time-Password has been generated for you and is shown in the OTP field.
You will need this value to decode the resulting root token, so keep it safe.
Nonce         854bc84e-2dea-5f86-3074-86d0988adce2
Started       true
Progress      0/3
Complete      false
OTP           tn4ZJQN5aUMCPJjl5mYIof5FQA
OTP Length    26

/ $ vault operator generate-root
Operation nonce: 854bc84e-2dea-5f86-3074-86d0988adce2
Unseal Key (will be hidden):
Nonce       854bc84e-2dea-5f86-3074-86d0988adce2
Started     true
Progress    1/3
Complete    false
....

/ $ vault operator generate-root
Operation nonce: 854bc84e-2dea-5f86-3074-86d0988adce2
Unseal Key (will be hidden):
Nonce            854bc84e-2dea-5f86-3074-86d0988adce2
Started          true
Progress         3/3
Complete         true
Encoded Token    B0AEECMILHgUZQkmPTw6O3g/HDscPFsxY3M

$ vault operator generate-root -decode=B0AEECMILHgUZQkmPTw6O3g/HDscPFsxY3M -otp=tn4ZJQN5aUMCPJjl5mYIof5FQA
s.0JiYbMu0DemvPWMRErsZnw22

vault login s.0JiYbMu0DemvPWMRErsZnw22

```

# Auto unseal

https://github.com/lrstanley/vault-unseal#usage
