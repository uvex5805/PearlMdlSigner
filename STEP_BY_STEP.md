# Пошаговая инструкция / Step-by-step guide

## Русская версия

Эта инструкция описывает весь процесс с самого начала.

## 1. Что должно быть готово

1. У вас должен быть Windows.
2. У вас должен быть установлен и открыт Desktop Pearl Wallet.
3. В Pearl Wallet должен быть выбран именно тот кошелек, которому принадлежит ваш PRL-адрес.
4. У вас должен быть MDL-адрес, который нужно подтвердить.
5. У вас должен быть PRL-адрес из Pearl Wallet.

Важно: PRL-адрес должен принадлежать открытому Pearl Wallet. Если адрес не из этого кошелька, будет ошибка `no private key`.

## 2. Скачайте скрипт

1. Откройте страницу релиза GitHub:

```text
https://github.com/uvex5805/PearlMdlSigner/releases/tag/MDLAddressSigning
```

2. Скачайте файл:

```text
PearlMdlSigner-MDLAddressSigning.zip
```

3. Распакуйте архив в любое место, например на Рабочий стол.

После распаковки в папке должны быть файлы:

```text
README.md
RELEASE_NOTES.md
STEP_BY_STEP.md
sign-input.txt
sign-mdl.ps1
start_MDL_sign.cmd
```

## 3. Откройте Pearl Wallet

1. Запустите Desktop Pearl Wallet.
2. Откройте нужный кошелек.
3. Дождитесь, пока кошелек полностью откроется.
4. Не закрывайте Pearl Wallet до конца подписи.

Важно: если Pearl Wallet запущен от имени администратора, то `start_MDL_sign.cmd` тоже нужно запускать от имени администратора.

Лучше всего запускать и Pearl Wallet, и `start_MDL_sign.cmd` обычным способом, без администратора.

## 4. Получите правильный PRL-адрес

1. В Pearl Wallet найдите ваш PRL-адрес.
2. Скопируйте именно PRL-адрес, который начинается с:

```text
prl1...
```

3. Не используйте MDL-адрес вместо PRL-адреса.
4. Не используйте PRL-адрес из другого кошелька.

Если появляется ошибка `no private key`, почти всегда это значит, что выбранный PRL-адрес не принадлежит открытому Pearl Wallet.

## 5. Получите MDL-адрес

1. Откройте страницу, где нужно получить или подтвердить MDL-адрес:

```text
https://compute.modeloslab.xyz/wallet
```

2. Скопируйте MDL-адрес из серого блока.
3. MDL-адрес обычно начинается с:

```text
mdl1...
```

Скрипт сам подпишет правильное сообщение:

```text
I set mdl1...
```

Не нужно вручную добавлять `I set`, но если вы случайно вставите строку целиком, скрипт исправит это и не сделает двойное `I set`.

## 6. Заполните sign-input.txt

1. Откройте файл:

```text
sign-input.txt
```

2. Заполните его так:

```text
MDL=mdl1...
PRL=prl1...
```

Пример:

```text
MDL=mdl1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
PRL=prl1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

3. Сохраните файл.
4. Не меняйте названия `MDL=` и `PRL=`.
5. Не добавляйте кавычки.
6. Не вставляйте seed-фразу.
7. Не вставляйте private key.

Если нужно подписать один MDL несколькими PRL-адресами, добавьте несколько строк:

```text
MDL=mdl1...
PRL=prl1...
PRL=prl1...
PRL=prl1...
```

## 7. Проверка без подписи

Перед настоящей подписью можно проверить, что файл заполнен правильно.

1. Откройте папку со скриптом.
2. Зажмите `Shift`.
3. Нажмите правой кнопкой мыши по пустому месту в папке.
4. Выберите `Open PowerShell window here` или `Открыть окно PowerShell здесь`.
5. Выполните:

```powershell
.\start_MDL_sign.cmd -CheckOnly
```

Скрипт покажет:

```text
MDL-адрес / MDL address
Сообщение для подписи / Message to sign
PRL-адресов введено / PRL addresses entered
```

Проверьте, что строка `Message to sign` выглядит так:

```text
I set mdl1...
```

## 8. Запустите подпись

1. Убедитесь, что Pearl Wallet открыт.
2. Убедитесь, что в Pearl Wallet открыт правильный кошелек.
3. Дважды нажмите:

```text
start_MDL_sign.cmd
```

4. Если Windows спросит разрешение на запуск, разрешите запуск.
5. Если скрипт попросит пароль кошелька Pearl Wallet, введите пароль кошелька.

Важно: пароль кошелька нужен только для разблокировки подписи. Скрипт не просит seed-фразу и private key.

## 9. Что подписывает скрипт

Скрипт подписывает не просто MDL-адрес.

Он подписывает сообщение:

```text
I set mdl1...
```

Это соответствует официальной команде Pearl:

```powershell
prlctl --wallet signmessage "prl1..." "I set mdl1..."
```

## 10. Где найти подпись

После успешной подписи рядом со скриптом появится файл вида:

```text
prl_последние6PRL+mdl_последние6MDL.txt
```

Например:

```text
prl_egm2ww+mdl_5vrk0m.txt
```

Откройте этот файл.

Внутри будет:

```text
Подпись / Signature:
...
```

Скопируйте только саму подпись и вставьте ее в поле `Signature` на сайте.

## 11. Частые ошибки

## Ошибка: no private key

Это не значит, что вы не ввели пароль.

Это значит, что открытый Pearl Wallet не имеет private key для указанного PRL-адреса.

Что сделать:

1. Проверьте, что PRL-адрес начинается с `prl1`.
2. Проверьте, что PRL-адрес скопирован из открытого Pearl Wallet.
3. Проверьте, что открыт правильный кошелек.
4. Если у вас несколько кошельков, откройте тот, где находится этот PRL-адрес.
5. Если адрес был взят из другого кошелька, используйте адрес из текущего кошелька.

## Ошибка: Access denied / Отказано в доступе

Это значит, что скрипт не смог прочитать параметры процесса Pearl Wallet.

Что сделать:

1. Закройте Pearl Wallet.
2. Откройте Pearl Wallet обычным способом, без администратора.
3. Запустите `start_MDL_sign.cmd` обычным двойным кликом.

Если Pearl Wallet запущен от администратора, то `start_MDL_sign.cmd` тоже нужно запускать от администратора.

Главное правило: Pearl Wallet и скрипт должны быть запущены с одинаковыми правами.

## Ошибка с паролем

Если пароль неверный, кошелек не разблокируется.

Что сделать:

1. Введите правильный пароль Pearl Wallet.
2. Проверьте раскладку клавиатуры.
3. Проверьте Caps Lock.

Пароль не является seed-фразой и не является private key.

## 12. Безопасность

Скрипт безопасен:

1. Он не отправляет транзакции.
2. Он не списывает PRL.
3. Он не просит seed-фразу.
4. Он не просит private key.
5. Он только просит открытый Pearl Wallet подписать сообщение.
6. Код открыт, его можно проверить перед запуском.

Если есть сомнения, проверьте код самостоятельно или дождитесь официальных инструкций.

---

## English Version

This guide describes the whole process from the beginning.

## 1. What must be ready

1. You need Windows.
2. Desktop Pearl Wallet must be installed and open.
3. Pearl Wallet must have the correct wallet selected.
4. You need the MDL address that must be verified.
5. You need a PRL address from Pearl Wallet.

Important: the PRL address must belong to the opened Pearl Wallet. If the address is not from this wallet, you will get `no private key`.

## 2. Download the script

1. Open the GitHub release page:

```text
https://github.com/uvex5805/PearlMdlSigner/releases/tag/MDLAddressSigning
```

2. Download:

```text
PearlMdlSigner-MDLAddressSigning.zip
```

3. Extract the archive anywhere, for example to Desktop.

After extraction, the folder should contain:

```text
README.md
RELEASE_NOTES.md
STEP_BY_STEP.md
sign-input.txt
sign-mdl.ps1
start_MDL_sign.cmd
```

## 3. Open Pearl Wallet

1. Start Desktop Pearl Wallet.
2. Open the required wallet.
3. Wait until the wallet is fully open.
4. Do not close Pearl Wallet until signing is finished.

Important: if Pearl Wallet is running as administrator, `start_MDL_sign.cmd` must also run as administrator.

Best option: run both Pearl Wallet and `start_MDL_sign.cmd` normally, without administrator rights.

## 4. Get the correct PRL address

1. Find your PRL address in Pearl Wallet.
2. Copy the PRL address that starts with:

```text
prl1...
```

3. Do not use an MDL address instead of a PRL address.
4. Do not use a PRL address from another wallet.

If you see `no private key`, it almost always means the selected PRL address does not belong to the opened Pearl Wallet.

## 5. Get the MDL address

1. Open the page where you need to get or verify your MDL address:

```text
https://compute.modeloslab.xyz/wallet
```

2. Copy the MDL address from the gray box.
3. The MDL address usually starts with:

```text
mdl1...
```

The script will sign the correct message automatically:

```text
I set mdl1...
```

You do not need to add `I set` manually. If you paste the whole `I set mdl1...` line by accident, the script will normalize it and will not create `I set I set ...`.

## 6. Fill sign-input.txt

1. Open:

```text
sign-input.txt
```

2. Fill it like this:

```text
MDL=mdl1...
PRL=prl1...
```

Example:

```text
MDL=mdl1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
PRL=prl1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

3. Save the file.
4. Do not rename `MDL=` and `PRL=`.
5. Do not add quotes.
6. Do not paste your seed phrase.
7. Do not paste your private key.

If you need to sign one MDL with several PRL addresses, add several PRL lines:

```text
MDL=mdl1...
PRL=prl1...
PRL=prl1...
PRL=prl1...
```

## 7. Check without signing

Before real signing, you can check that the input file is correct.

1. Open the script folder.
2. Hold `Shift`.
3. Right-click an empty place in the folder.
4. Select `Open PowerShell window here`.
5. Run:

```powershell
.\start_MDL_sign.cmd -CheckOnly
```

The script will show:

```text
MDL-адрес / MDL address
Сообщение для подписи / Message to sign
PRL-адресов введено / PRL addresses entered
```

Check that `Message to sign` looks like this:

```text
I set mdl1...
```

## 8. Run signing

1. Make sure Pearl Wallet is open.
2. Make sure the correct wallet is open in Pearl Wallet.
3. Double-click:

```text
start_MDL_sign.cmd
```

4. If Windows asks for permission to run, allow it.
5. If the script asks for your Pearl Wallet password, enter the wallet password.

Important: the wallet password is only used to unlock signing. The script does not ask for your seed phrase or private key.

## 9. What the script signs

The script does not sign only the MDL address.

It signs this message:

```text
I set mdl1...
```

This matches the official Pearl command:

```powershell
prlctl --wallet signmessage "prl1..." "I set mdl1..."
```

## 10. Where to find the signature

After successful signing, a file will appear next to the script:

```text
prl_last6PRL+mdl_last6MDL.txt
```

Example:

```text
prl_egm2ww+mdl_5vrk0m.txt
```

Open this file.

Inside you will see:

```text
Подпись / Signature:
...
```

Copy only the signature itself and paste it into the `Signature` field on the website.

## 11. Common errors

## Error: no private key

This does not mean you did not enter the password.

It means the opened Pearl Wallet does not have the private key for the specified PRL address.

What to do:

1. Check that the PRL address starts with `prl1`.
2. Check that the PRL address was copied from the opened Pearl Wallet.
3. Check that the correct wallet is open.
4. If you have several wallets, open the wallet that contains this PRL address.
5. If the address was taken from another wallet, use an address from the current wallet.

## Error: Access denied / Отказано в доступе

This means the script could not read the Pearl Wallet process parameters.

What to do:

1. Close Pearl Wallet.
2. Open Pearl Wallet normally, without administrator rights.
3. Start `start_MDL_sign.cmd` with a normal double-click.

If Pearl Wallet is running as administrator, `start_MDL_sign.cmd` must also run as administrator.

Main rule: Pearl Wallet and the script must run with the same permissions.

## Password error

If the password is wrong, the wallet will not unlock.

What to do:

1. Enter the correct Pearl Wallet password.
2. Check your keyboard layout.
3. Check Caps Lock.

The password is not your seed phrase and is not your private key.

## 12. Safety

The script is safe:

1. It does not send transactions.
2. It does not spend PRL.
3. It does not ask for your seed phrase.
4. It does not ask for your private key.
5. It only asks the opened Pearl Wallet to sign a message.
6. The code is open and can be reviewed before running.

If you have any doubts, check the code yourself or wait for official instructions.
