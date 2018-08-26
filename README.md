**RU:** Скрипт снятия образа данных через утилиту **[ntfsclone](https://linux.die.net/man/8/ntfsclone)** с носителей XEN\KVM с максимальным сжатием данных (для HVM OS Windows)<br>
Параметры использования скрипта задаются в секции **manual_parameters**<br>
для скрипта необходим пакет **dialog**.

для получения необходимых параметров скрипта - пример:
```
losetup /dev/loop1 /kvm/win7x64/disk_c.img
losetup -a
dev/loop0: [2055]:2103175 (/kvm/win7x64/disk_c.img)
```

`fdisk -l /dev/loop0`

```
Disk /dev/loop0: 80 GiB, 85899345920 bytes, 167772160 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x677d5646
```

```
Device        Boot  Start       End   Sectors  Size Id Type
/dev/loop0p1 *      2048    206847    204800  100M  7 HPFS/NTFS/exFAT
/dev/loop0p2      206848 167770111 167563264 79,9G  7 HPFS/NTFS/exFAT
```

у нас на образе 2 раздела.<br>
каждый раздел это: **sda1** и **sda2**<br>
смещение для каждого раздела получаем вычислением:<br> 

**sda1 offset:( 512 х 2048 = 1048576 )**<br> 
**sda2 offset:( 512 x 206848 = 105906176 )**<br> 

результат вносим в раздел скрипта **manual_parameters**<br>
теперь скрипт сможет сам как сохранять так и восстанавливать данные с образа виртуальной машины.<br>

Пожалуйста обратите внимание, параметры скрипта это массивы, вносите изменения так же как в исходном коде,<br>
скрипт всегда опрашивает значения как массив, независисмо одно значение или более.<br>

**Внимание!!**<br> 
**До начала использования скрипта рекомендую предварительно сделать копию файла образа (пример : /kvm/win7x64/disk_c.img)**<br>
и только если все прошло успешно, копию можно удалить.<br>
Диалог скрипта поддерживает 2 языка: RU и EN<br>

<hr>
**EN:** A script to extract a data image via the  **[ntfsclone](https://linux.die.net/man/8/ntfsclone)** utility from XEN \ KVM with maximum data compression (for HVM OS Windows)<br>
Parameters for using the script are specified in section **manual_parameters**<br>
for the script you need the package **dialog**.

to get the necessary parameters of the script - an example:<br>
```
losetup /dev/loop1 /kvm/win7x64/disk_c.img
losetup -a
dev/loop0: [2055]:2103175 (/kvm/win7x64/disk_c.img)
```

`fdisk -l /dev/loop0`

```
Disk /dev/loop0: 80 GiB, 85899345920 bytes, 167772160 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x677d5646
```

```
Device        Boot  Start       End   Sectors  Size Id Type
/dev/loop0p1 *      2048    206847    204800  100M  7 HPFS/NTFS/exFAT
/dev/loop0p2      206848 167770111 167563264 79,9G  7 HPFS/NTFS/exFAT
```


at us on an image of 2 sections.<br>
each partition is: **sda1** and **sda2**<br>
the offset for each section is obtained by computing:<br>

**sda1 offset :( 512 x 2048 = 1048576)**<br>
**sda2 offset :( 512 x 206848 = 105906176)**<br>

the result is added to the section of the script **manual_parameters**<br>
Now the script itself can both save and restore data from the virtual machine image.<br>

Please note, the script settings are arrays, make the changes as well as in the source code, <br>
The script always interrogates values as an array, independently one value or more.<br>

**Attention!!**<br>
**Before using the script, I recommend that you first make a copy of the image file (example: /kvm/win7x64/disk_c.img)**<br>
and only if everything went well, a copy can be deleted.<br>
The script dialog supports 2 languages: RU and EN<br>