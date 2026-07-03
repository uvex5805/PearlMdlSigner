# Automatic MDL Address Signing Through Pearl Wallet

This release contains a portable Windows script for signing an MDL address through an open Desktop Pearl Wallet.

Get or verify the MDL address here:

```text
https://compute.modeloslab.xyz/wallet
```

## What it does

- Signs the official Pearl message format:

```text
I set mdl1...
```

- Runs the same local wallet operation as:

```powershell
prlctl --wallet signmessage "prl1..." "I set mdl1..."
```

- Saves the signature to a text file.
- Supports one or multiple PRL addresses.
- Can be copied to another Windows computer and run from any folder.

## Files

- `start_MDL_sign.cmd` - launcher for double-click start.
- `sign-mdl.ps1` - main PowerShell script.
- `README.md` - Russian and English instructions.
- `STEP_BY_STEP.md` - full Russian and English guide from the beginning.

## Safety

The script only asks Pearl Wallet to sign a message locally.

It does not send transactions, does not spend PRL, and does not ask for your seed phrase or private key.

The code is open. If you have any doubts, review the files before running or wait for official instructions.

## Access denied note

If you see `Access denied`, run Pearl Wallet and `start_MDL_sign.cmd` with the same permissions.

If Pearl Wallet is running as administrator, run `start_MDL_sign.cmd` as administrator too.
