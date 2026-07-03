# Автоматическая подпись MDL-адреса через Pearl Wallet

Скрипт автоматически подписывает MDL-адрес через открытый Desktop Pearl Wallet и сохраняет результат в текстовый файл.

Подписывается не сам MDL-адрес, а сообщение:

```text
I set mdl1...
```

Это соответствует команде:

```powershell
prlctl --wallet signmessage "prl1..." "I set mdl1..."
```

## Что нужно

1. Windows PowerShell 5.1 или новее.
2. Открытый Desktop Pearl Wallet с выбранным нужным кошельком.
3. PRL-адрес, который принадлежит открытому кошельку.
4. Заполненный `sign-input.txt` или ручной ввод адресов при запуске.

## Перенос на другой компьютер

Скопируйте всю папку `PearlMdlSigner` в любое место, например на Рабочий стол.

В папке должны быть файлы:

```text
start_MDL_sign.cmd
sign-mdl.ps1
sign-input.txt
```

Папку `cli` тоже можно скопировать. Если её нет, скрипт попробует скачать официальный Pearl CLI автоматически.

Запускайте скрипт через:

```text
start_MDL_sign.cmd
```

## Файл адресов

В файле `sign-input.txt` укажите:

```text
MDL=mdl1...
PRL=prl1...
PRL=prl1...
```

Можно указать один или несколько PRL-адресов.

Если файл пустой или в нём нет MDL/PRL, скрипт попросит ввести адреса вручную.

## Запуск

Рекомендуемый вариант:

```text
start_MDL_sign.cmd
```

Запуск через PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\sign-mdl.ps1
```

Проверка без подписи:

```text
start_MDL_sign.cmd -CheckOnly
```

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

Чаще всего причина — Pearl Wallet и `start_MDL_sign.cmd` запущены с разными правами.

Что сделать:

1. Закройте Pearl Wallet.
2. Откройте Pearl Wallet обычным способом, без запуска от имени администратора.
3. Запустите `start_MDL_sign.cmd` обычным двойным кликом.

Если Pearl Wallet запущен от администратора, тогда `start_MDL_sign.cmd` тоже нужно запустить от администратора.

Главное правило: Pearl Wallet и скрипт должны быть запущены с одинаковыми правами.

## Важно

* Desktop Pearl Wallet должен быть открыт.
* PRL-адрес должен принадлежать открытому кошельку.
* Подпись не отправляет транзакцию в сеть.
* Подпись не списывает PRL.
* Не вводите seed-фразу и private key.
* Для bundled CLI нужен 64-битный Windows.
* Если Pearl Wallet требует пароль для разблокировки, пароль вводится только в самом Pearl Wallet.

## Безопасность

Скрипт только выполняет локальную команду подписи сообщения через открытый Pearl Wallet.

Он не отправляет транзакции, не запрашивает seed-фразу и private key.

Код открыт в папке проекта. Перед запуском его можно проверить вручную.

Если есть сомнения, проверьте код самостоятельно или дождитесь официальных инструкций.

---

# Automatic MDL Address Signing Through Pearl Wallet

This script automatically signs an MDL address through an open Desktop Pearl Wallet and saves the result to a text file.

The script does not sign the bare MDL address. It signs this message:

```text
I set mdl1...
```

This matches the Pearl command:

```powershell
prlctl --wallet signmessage "prl1..." "I set mdl1..."
```

## Requirements

1. Windows PowerShell 5.1 or newer.
2. Desktop Pearl Wallet must be open with the required wallet selected.
3. The PRL address must belong to the opened wallet.
4. A completed `sign-input.txt` file or manual address input during launch.

## Moving to Another Computer

Copy the whole `PearlMdlSigner` folder to any location, for example to Desktop.

The folder must contain these files:

```text
start_MDL_sign.cmd
sign-mdl.ps1
sign-input.txt
```

You can also copy the `cli` folder. If it is missing, the script will try to download the official Pearl CLI automatically.

Run the script using:

```text
start_MDL_sign.cmd
```

## Address File

Fill `sign-input.txt` with:

```text
MDL=mdl1...
PRL=prl1...
PRL=prl1...
```

You can specify one or several PRL addresses.

If the file is empty or does not contain MDL/PRL values, the script will ask for the addresses manually.

## Run

Recommended option:

```text
start_MDL_sign.cmd
```

Run through PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\sign-mdl.ps1
```

Check without signing:

```text
start_MDL_sign.cmd -CheckOnly
```

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

* Desktop Pearl Wallet must be open.
* The PRL address must belong to the opened wallet.
* Signing does not send a transaction to the network.
* Signing does not spend PRL.
* Do not enter your seed phrase or private key.
* The bundled CLI requires 64-bit Windows.
* If Pearl Wallet needs a password to unlock the wallet, enter it only inside Pearl Wallet.

## Safety

The script only runs a local message-signing command through the opened Pearl Wallet.

It does not send transactions and does not ask for your seed phrase or private key.

The code is open inside the project folder. You can review it manually before running.

If you have any doubts, check the code yourself or wait for official instructions.
