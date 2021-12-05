**Shell (BASH)**

-----

**RU:** Скрипт снятия образа данных через утилиту **[dd](https://linux.die.net/man/1/dd)** с носителей XEN\KVM <br>
- с максимальным сжатием данных<br>
**(для любых систем HVM)**<br>
Параметры использования скрипта задаются в секции **manual_parameters**<br>
для скрипта необходимы пакеты: **dialog**, **dd**, **pigz**, **gunzip** .

настройки вносим в раздел скрипта **manual_parameters**<br>
теперь скрипт сможет сам как сохранять так и восстанавливать данные с образа виртуальной машины.<br>

Пожалуйста обратите внимание, параметры скрипта это массивы, вносите изменения так же как в исходном коде,<br>
скрипт всегда опрашивает значения как массив, независимо одно значение или более.<br>

**Внимание!!**<br> 
**До начала использования скрипта рекомендую предварительно сделать копию файла образа (пример : /kvm/vm1/sda.img)**<br>
и только если все прошло успешно, копию можно удалить.<br>
Диалог скрипта поддерживает 2 языка: RU и EN<br>

**Если возникает ошибка: "Peer's Certificate issuer is not recognized"**<br>
используейте параметр: git -c http.sslVerify=false clone ...


<hr>
**EN:** This script to safe and extract a data image via the  **[dd](https://linux.die.net/man/1/dd)** utility from XEN \ KVM <br>
- with maximum data compression<br>
**(for HVM all OS)**<br>
Parameters for using the script are specified in section **manual_parameters**<br>
for the script you need the packages: **dialog**, **dd**, **pigz**, **gunzip** .

the start parameters is added to the section of the script **manual_parameters**<br>
Now the script itself can both save and restore data from the virtual machine image.<br>

Please note, the script settings are arrays, make the changes as well as in the source code, <br>
The script always interrogates values as an array, independently one value or more.<br>

**Attention!!**<br>
**Before using the script, I recommend that you first make a copy of the image file (example: /kvm/vm1/sda.img)**<br>
and only if everything went well, a copy can be deleted.<br>
The script dialog supports 2 languages: RU and EN<br>

**If an error occurs: "Peer's Certificate issuer is not recognized"**<br>
use example: git -c http.sslVerify=false clone ...
