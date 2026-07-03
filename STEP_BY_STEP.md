# Пошаговая инструкция / Step-by-step guide

## Русская версия

Эта инструкция описывает процесс с самого начала. Из инструкции ничего копировать не нужно. Копируйте только свои реальные адреса из Pearl Wallet и со страницы MDL.

## 1. Подготовьте Pearl Wallet

1. Откройте Desktop Pearl Wallet.
2. Выберите нужный кошелек.
3. Дождитесь, пока кошелек полностью откроется.
4. Дождитесь полной синхронизации Desktop Pearl Wallet.
5. Не закрывайте Pearl Wallet до конца подписи.

PRL-адрес должен принадлежать открытому кошельку. Если адрес не из этого кошелька, будет ошибка `no private key`.

Если вы используете PRL и MDL Windows wallets, они не могут работать одновременно, потому что используют один и тот же порт.

## 2. Скачайте и распакуйте скрипт

1. Откройте страницу релиза GitHub.
2. Скачайте архив `PearlMdlSigner-MDLAddressSigning.zip`.
3. Распакуйте архив в любое удобное место, например на Рабочий стол.
4. Откройте распакованную папку.

В папке должен быть файл `start_MDL_sign.cmd`. Именно его нужно запускать.

## 3. Получите MDL-адрес

1. Откройте страницу `https://compute.modeloslab.xyz/wallet`.
2. Найдите MDL-адрес на странице.
3. Скопируйте свой MDL-адрес.

Скрипт сам добавит нужный текст `I set` перед MDL-адресом. Вручную добавлять `I set` не нужно.

## 4. Получите PRL-адрес

1. Вернитесь в Desktop Pearl Wallet.
2. Найдите PRL-адрес в открытом кошельке.
3. Скопируйте свой PRL-адрес.

Важно: копируйте именно PRL-адрес из открытого Pearl Wallet. Не используйте MDL-адрес вместо PRL-адреса.

Если вы получили новый PRL-адрес, сначала запустите майнинг с этим новым адресом, чтобы он появился на pool.

MDL-адрес нужно подписывать тем PRL-аккаунтом, который есть на pool.

## 5. Запустите скрипт

1. В распакованной папке дважды нажмите `start_MDL_sign.cmd`.
2. Если Windows спросит разрешение на запуск, разрешите запуск.
3. Откроется окно скрипта.

## 6. Введите MDL-адрес

1. Когда скрипт попросит MDL-адрес, вставьте свой MDL-адрес.
2. Нажмите `Enter`.

Не копируйте MDL из этой инструкции. Вставляйте только свой адрес со страницы MDL.

## 7. Введите PRL-адрес

1. Когда скрипт попросит PRL-адрес, вставьте свой PRL-адрес из Pearl Wallet.
2. Нажмите `Enter`.
3. Если нужен только один PRL-адрес, на следующем запросе PRL-адреса нажмите `Enter` на пустой строке.
4. Если нужно подписать несколькими PRL-адресами, вводите их по одному. После последнего адреса нажмите `Enter` на пустой строке.

Не вводите seed-фразу. Не вводите private key.

## 8. Введите пароль кошелька, если потребуется

Если Pearl Wallet заблокирован, скрипт попросит пароль кошелька.

Введите пароль от Pearl Wallet и нажмите `Enter`.

Пароль нужен только для разблокировки подписи. Это не seed-фраза и не private key.

## 9. Заберите подпись

После успешной подписи рядом со скриптом появится новый текстовый файл.

1. Откройте созданный файл.
2. Найдите строку `Подпись / Signature`.
3. Скопируйте саму подпись.
4. Вставьте подпись в поле `Signature` на сайте.

## 10. Ошибка no private key

`no private key` не означает, что вы не ввели пароль.

Эта ошибка значит, что открытый Pearl Wallet не содержит private key для указанного PRL-адреса.

Что сделать:

1. Проверьте, что PRL-адрес скопирован из открытого Pearl Wallet.
2. Проверьте, что открыт правильный кошелек.
3. Если у вас несколько кошельков, откройте тот кошелек, где находится этот PRL-адрес.
4. Снова запустите скрипт и вставьте PRL-адрес из правильного кошелька.

## 11. Ошибка Access denied / Отказано в доступе

Эта ошибка значит, что скрипт не смог прочитать параметры процесса Pearl Wallet.

Что сделать:

1. Закройте Pearl Wallet.
2. Откройте Pearl Wallet обычным способом, без запуска от имени администратора.
3. Запустите `start_MDL_sign.cmd` обычным двойным кликом.

Если Pearl Wallet запущен от администратора, то `start_MDL_sign.cmd` тоже нужно запускать от администратора.

Главное правило: Pearl Wallet и скрипт должны быть запущены с одинаковыми правами.

## 12. Безопасность

Скрипт только просит открытый Pearl Wallet подписать сообщение.

Скрипт не отправляет транзакции, не списывает PRL, не просит seed-фразу и не просит private key.

Код открыт. Если есть сомнения, проверьте код самостоятельно или дождитесь официальных инструкций.

---

## English Version

This guide describes the whole process from the beginning. You do not need to copy anything from this guide. Copy only your real addresses from Pearl Wallet and from the MDL page.

## 1. Prepare Pearl Wallet

1. Open Desktop Pearl Wallet.
2. Select the required wallet.
3. Wait until the wallet is fully open.
4. Wait until Desktop Pearl Wallet is fully synchronized.
5. Do not close Pearl Wallet until signing is finished.

The PRL address must belong to the opened wallet. If the address is not from this wallet, you will get `no private key`.

Please note that the PRL and MDL Windows wallets cannot connect at the same time because they use the same port.

## 2. Download and extract the script

1. Open the GitHub release page.
2. Download the `PearlMdlSigner-MDLAddressSigning.zip` archive.
3. Extract the archive anywhere, for example to Desktop.
4. Open the extracted folder.

The folder must contain `start_MDL_sign.cmd`. This is the file you need to run.

## 3. Get the MDL address

1. Open `https://compute.modeloslab.xyz/wallet`.
2. Find the MDL address on the page.
3. Copy your MDL address.

The script will add the required `I set` text before the MDL address automatically. You do not need to add `I set` manually.

## 4. Get the PRL address

1. Go back to Desktop Pearl Wallet.
2. Find the PRL address in the opened wallet.
3. Copy your PRL address.

Important: copy the PRL address from the opened Pearl Wallet. Do not use the MDL address instead of the PRL address.

When you receive a new PRL address, start mining with that new address first so it appears on the pool.

The MDL address must be signed from the PRL account that is on the pool.

## 5. Run the script

1. In the extracted folder, double-click `start_MDL_sign.cmd`.
2. If Windows asks for permission to run, allow it.
3. The script window will open.

## 6. Enter the MDL address

1. When the script asks for the MDL address, paste your MDL address.
2. Press `Enter`.

Do not copy an MDL address from this guide. Paste only your own address from the MDL page.

## 7. Enter the PRL address

1. When the script asks for the PRL address, paste your PRL address from Pearl Wallet.
2. Press `Enter`.
3. If you need only one PRL address, press `Enter` on the next empty PRL address prompt.
4. If you need to sign with several PRL addresses, enter them one by one. After the last address, press `Enter` on an empty line.

Do not enter your seed phrase. Do not enter your private key.

## 8. Enter the wallet password if needed

If Pearl Wallet is locked, the script will ask for the wallet password.

Enter your Pearl Wallet password and press `Enter`.

The password is only used to unlock signing. It is not your seed phrase and it is not your private key.

## 9. Copy the signature

After successful signing, a new text file will appear next to the script.

1. Open the created file.
2. Find `Подпись / Signature`.
3. Copy the signature itself.
4. Paste the signature into the `Signature` field on the website.

## 10. Error: no private key

`no private key` does not mean you did not enter the password.

This error means the opened Pearl Wallet does not contain the private key for the specified PRL address.

What to do:

1. Check that the PRL address was copied from the opened Pearl Wallet.
2. Check that the correct wallet is open.
3. If you have several wallets, open the wallet that contains this PRL address.
4. Run the script again and paste the PRL address from the correct wallet.

## 11. Error: Access denied / Отказано в доступе

This error means the script could not read the Pearl Wallet process parameters.

What to do:

1. Close Pearl Wallet.
2. Open Pearl Wallet normally, without administrator rights.
3. Start `start_MDL_sign.cmd` with a normal double-click.

If Pearl Wallet is running as administrator, `start_MDL_sign.cmd` must also run as administrator.

Main rule: Pearl Wallet and the script must run with the same permissions.

## 12. Safety

The script only asks the opened Pearl Wallet to sign a message.

It does not send transactions, does not spend PRL, does not ask for your seed phrase, and does not ask for your private key.

The code is open. If you have any doubts, check the code yourself or wait for official instructions.
