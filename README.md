# Pearl MDL Signer

Автоматическая подпись MDL-адреса через открытый Desktop Pearl Wallet.

[Пошаговая инструкция с самого начала](STEP_BY_STEP.md)

[English version](#english-version)

## Русская версия

Скрипт подписывает MDL-адрес через открытый Desktop Pearl Wallet и сохраняет результат в текстовый файл.

Подписывается не сам MDL-адрес, а сообщение:

```text
I set mdl1...
```

Это соответствует официальной команде Pearl:

```powershell
prlctl --wallet signmessage "prl1..." "I set mdl1..."
```

## Что нужно

1. Windows PowerShell 5.1 или новее.
2. Открытый Desktop Pearl Wallet с выбранным нужным кошельком.
3. Desktop Pearl Wallet должен быть полностью синхронизирован.
4. PRL-адрес, который принадлежит открытому кошельку.
5. MDL-адрес со страницы `https://compute.modeloslab.xyz/wallet`.

## Перенос на другой компьютер

Скопируйте всю папку `PearlMdlSigner` в любое место, например на Рабочий стол.

В папке должны быть файлы:

```text
README.md
RELEASE_NOTES.md
STEP_BY_STEP.md
start_MDL_sign.cmd
sign-mdl.ps1
```

Папку `cli` тоже можно скопировать. Если её нет, скрипт попробует скачать официальный Pearl CLI автоматически.

Запускайте скрипт через:

```text
start_MDL_sign.cmd
```

## Запуск

Рекомендуемый вариант:

```text
start_MDL_sign.cmd
```

Скрипт спросит MDL-адрес и PRL-адрес прямо в окне.

PRL-адресов можно ввести несколько: один адрес на строку. Пустая строка завершает ввод PRL-адресов.

## Результат

Готовый файл появится рядом со скриптом.

Имя файла для одного PRL-адреса:

```text
prl_6последнихPRL+mdl_6последнихMDL.txt
```

Пример:

```text
prl_jn4krk+mdl_5vrk0m.txt
```

Если PRL-адресов несколько:

```text
prl_multi_2+mdl_5vrk0m.txt
```

После записи скрипт покажет содержимое файла в окне.

Окно не закроется само. После проверки результата нажмите `Enter`.

## Если появляется ошибка «Отказано в доступе»

Ошибка означает, что скрипт не смог прочитать параметры процесса Pearl Wallet.

Чаще всего причина: Pearl Wallet и `start_MDL_sign.cmd` запущены с разными правами.

Что сделать:

1. Закройте Pearl Wallet.
2. Откройте Pearl Wallet обычным способом, без запуска от имени администратора.
3. Запустите `start_MDL_sign.cmd` обычным двойным кликом.

Если Pearl Wallet запущен от администратора, тогда `start_MDL_sign.cmd` тоже нужно запустить от администратора.

Главное правило: Pearl Wallet и скрипт должны быть запущены с одинаковыми правами.

## Важно

- Desktop Pearl Wallet должен быть открыт.
- Desktop Pearl Wallet должен быть полностью синхронизирован.
- PRL-адрес должен принадлежать открытому кошельку.
- Если вы получили новый PRL-адрес, сначала запустите майнинг с этим новым адресом, чтобы он появился на pool.
- MDL-адрес нужно подписывать тем PRL-аккаунтом, который есть на pool.
- Подпись не отправляет транзакцию в сеть.
- Подпись не списывает PRL.
- Не вводите seed-фразу и private key.
- Для bundled CLI нужен 64-битный Windows.
- Если Pearl Wallet требует пароль для разблокировки, пароль вводится только в самом Pearl Wallet.

## Безопасность

Скрипт только выполняет локальную команду подписи сообщения через открытый Pearl Wallet.

Он не отправляет транзакции, не запрашивает seed-фразу и private key.

Код открыт в репозитории. Перед запуском его можно проверить вручную.

Если есть сомнения, проверьте код самостоятельно или дождитесь официальных инструкций.

---

## English Version

Automatic MDL address signing through an open Desktop Pearl Wallet.

[Full step-by-step guide from the beginning](STEP_BY_STEP.md)

This script signs an MDL address through an open Desktop Pearl Wallet and saves the result to a text file.

The script does not sign the bare MDL address. It signs this message:

```text
I set mdl1...
```

This matches the official Pearl command:

```powershell
prlctl --wallet signmessage "prl1..." "I set mdl1..."
```

## Requirements

1. Windows PowerShell 5.1 or newer.
2. Desktop Pearl Wallet must be open with the required wallet selected.
3. Desktop Pearl Wallet must be fully synchronized.
4. The PRL address must belong to the opened wallet.
5. The MDL address from `https://compute.modeloslab.xyz/wallet`.

## Moving to Another Computer

Copy the whole `PearlMdlSigner` folder to any location, for example to Desktop.

The folder must contain these files:

```text
README.md
RELEASE_NOTES.md
STEP_BY_STEP.md
start_MDL_sign.cmd
sign-mdl.ps1
```

You can also copy the `cli` folder. If it is missing, the script will try to download the official Pearl CLI automatically.

Run the script using:

```text
start_MDL_sign.cmd
```

## Run

Recommended option:

```text
start_MDL_sign.cmd
```

The script will ask for the MDL address and PRL address directly in the window.

You can enter several PRL addresses: one address per line. An empty line finishes PRL address input.

## Result

The output file will be created next to the script.

File name for one PRL address:

```text
prl_last6PRL+mdl_last6MDL.txt
```

Example:

```text
prl_jn4krk+mdl_5vrk0m.txt
```

If several PRL addresses are used:

```text
prl_multi_2+mdl_5vrk0m.txt
```

After writing the file, the script will show its contents in the window.

The window will not close automatically. Press `Enter` after checking the result.

## If You See “Access Denied”

This error means the script could not read the Pearl Wallet process parameters.

Most often, Pearl Wallet and `start_MDL_sign.cmd` are running with different permissions.

What to do:

1. Close Pearl Wallet.
2. Open Pearl Wallet normally, without “Run as administrator”.
3. Start `start_MDL_sign.cmd` with a normal double-click.

If Pearl Wallet is running as administrator, then `start_MDL_sign.cmd` must also be run as administrator.

Main rule: Pearl Wallet and the script must run with the same permissions.

## Important

- Desktop Pearl Wallet must be open.
- Desktop Pearl Wallet must be fully synchronized.
- The PRL address must belong to the opened wallet.
- When you receive a new PRL address, start mining with that new address first so it appears on the pool.
- The MDL address must be signed from the PRL account that is on the pool.
- Signing does not send a transaction to the network.
- Signing does not spend PRL.
- Do not enter your seed phrase or private key.
- The bundled CLI requires 64-bit Windows.
- If Pearl Wallet needs a password to unlock the wallet, enter it only inside Pearl Wallet.

## Safety

The script only runs a local message-signing command through the opened Pearl Wallet.

It does not send transactions and does not ask for your seed phrase or private key.

The code is open in this repository. You can review it manually before running.

If you have any doubts, check the code yourself or wait for official instructions.

## About Scam Warnings

Be careful with scams. If you are not sure what a script does, you should always wait for official instructions or review the code first.

This script follows the official Pearl signing instruction exactly. It runs the same operation as:

```powershell
prlctl --wallet signmessage "prl1..." "I set mdl1..."
```

The script only automates this local wallet command. It signs the required message with your open Pearl Wallet, saves the signature to a text file, and does not send any transaction.

The script never asks for your seed phrase or private key. It only asks for the wallet password when Pearl Wallet needs to be unlocked for signing.

The code is open in this repository, so anyone can inspect it before running. If you have any doubts, please check the code yourself or wait for official guidance.
