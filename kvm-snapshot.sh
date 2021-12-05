#!/bin/bash
# The script is designed to create or restore an image of a virtual machine kvm (c) 2018
# author Koshuba V.O.
# license: MIT
# version: 5.0.2
##

#<manual_parameters>
path_kvm=(	"/kvm/vm1"
	        "/kvm/vm2" );			# path kvm machines
path_bak=(	"/backup/kvm/vm1" 
		"/backup/kvm/vm2"  );		# path backup kvm machines
img_dev=(	"sda.img"
		"sda.img" );			# storage kvm
#</manual_parameters>

#<script_value>
version="4.0.10";
owner="(c) script by Koshuba V.O. 2021";
msg_dat=( '"Script to save or restore the image KVM" "Скрипт сохранения или восстановления образа KVM"'
          '"MAIN MENU" "ГЛАВНОЕ МЕНЮ"'
          '"RESTORE KVM MACHINE" "ВОССТАНОВЛЕНИЕ ГОСТЕВОЙ МАШИНЫ KVM"'
          '"SAVE KVM MACHINE" "СОХРАНЕНИЕ ГОСТЕВОЙ МАШИНЫ KVM"'
          '"EXIT" "ВЫХОД"'
          '"Today:" "Сегодня:"'
          '"Available free space from Backup:" "Доступно свободного места в"' 
          '"SAVE GUEST MACHINE KVM" "СОХРАНИТЬ ГОСТЕВУЮ МАШИНУ KVM"'
          '"RESTORE GUEST MACHINE KVM" "ВОССТАНОВИТЬ ГОСТЕВУЮ МАШИНУ KVM"'
          '"Quit the program" "Выйти из программы"' 
          '"Select kvm machine" "Выберите машину KVM"'
          '"Select kvm image" "Выберите образ KVM"'
          '"{Space} key selection" "Выбор клавиша {Пробел}"'
          '"Not found dialog package, please install." "Не найден пакет: dialog, пожалуйста установите."'
          '"Found the file kvmsnapshot.lock - work is stopped!" "Найден файл kvmsnapshot.lok - работа остановлена!"'
          '"Starting kvm-snapshot script." "Запуск скрипта kvm-snapshot."'
          '"Ending work kvm-snapshot script." "Окончание работы скрипта kvm-snapshot."'
          '"Not found save images!" "Не найдены сохраненные образы!"'
	 );
	  # msg[17]
msg=();											# set current messages
esc_title="";										# title escape menu
esc_msg="";										# message escape menu
esc_menu="";										# return menu escape
set_lang="0";                                                                           # lang messages
menu_mode="";										# type menu select kvm
set_kvm="";										# selected kvm for processing
set_img="";										# selected image for restore kvm machine
rdate=$(date +%d.%m.%y);                                                                # real data
signlok="/tmp/run-kvmsnapshot.lok;";							# sign of work 
scriptlog="/var/log/vm.log";								# log file
DIALOG=${DIALOG=dialog};								# dialog lib
#<Define the dialog exit status codes>
: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_HELP=2}
: ${DIALOG_EXTRA=3}
: ${DIALOG_ITEM_HELP=4}
: ${DIALOG_ESC=255}
#</Define>
scr_tmp=$(tempfile 2>/dev/null) || scr_tmp=/tmp/choise.tmp;				# tmp file
trap "rm -f $scr_tmp" 0 1 2 5 15;
dform="/tmp/dform.tmp";
#</script_value>

#<functions_&_operations>
operation_menu=( "clear" "getTools" "langMsg" "testproc" "sMainMenu" );
operation_savekvm=( "clear" "saveKvm" "endproc" "exit" );
operation_restorekvm=( "clear" "restoreKvm" "endproc" "exit" );
operation_exit=( "clear" "endproc" "exit" );
#</function_&_operations>


#<tools_script>
get_tools=( "pigz" "locale" "du" "gunzip" "dd" );           # tools for script
#</tools_script>


#<dialogs>
function sMainMenu() {
local check_dialog=$(apt-cache policy dialog | grep status|wc -m );
if [[ $check_dialog = 0 ]];
    then
    echo -e "${msg[13]}";
    sleep 2
    exit 0
fi

#<esc_value>
esc_title="${msg[4]}";
esc_msg="${msg[9]}";
esc_menu="sMainMenu";
#</esc_value>

$DIALOG --clear --backtitle "                ${msg[0]} | $owner | version: $version" \
        --title "${msg[1]}" "$@" \
        --menu " ${msg[5]} $(date +%c) \n
==============================================\n
                                              \n" 20 51 5 \
        "1." "${msg[3]}" \
        "2." "${msg[2]}" \
        "3." "${msg[4]}" 2>$scr_tmp;
input=$(cat $scr_tmp && rm -f $scr_tmp);

case "$input" in

"1." | "1." )
 menu_mode="${msg[7]}";
 menuSaveKVM;
;;

"2." | "2." )
 menu_mode="${msg[8]}";
 menuRestoreKVM;
;;

"3." | "3." )
 escScript 
;;

* )
# default select
 escScript;
;;
esac
}

function escScript() {
$DIALOG --clear --backtitle "                ${msg[0]} | $owner | version: $version"\
        --title "$esc_title"\
        --yesno "\n
\n
        $esc_msg?" 10 50

case $? in
    0)
        clear;
	execute_func=( ${operation_exit[@]} );
	executor;
        exit 0;
        ;;
    1)
        $esc_menu;
        ;;
    255)
        $esc_menu;
        ;;
esac
}


function menuSaveKVM() {
formSetKVM;
source $dform;
slc="$?";
set_kvm=$( echo $(($(cat $scr_tmp && rm -f $scr_tmp && rm -f $dform)-1)));

case $slc in
    "0" | "0")
    clear;
    execute_func=( ${operation_savekvm[@]} );
    executor;
    ;;
    "1" | "1")
        sMainMenu;
    ;;
    "255" | "255")
        sMainMenu;
    ;;
esac
}

function menuRestoreKVM() {
formSetKVM;
source $dform;
slc="$?";
set_kvm=$( echo $(($(cat $scr_tmp && rm -f $scr_tmp && rm -f $dform)-1)));

case $slc in
    "0" | "0")
    clear;
	menuImg;
    ;;
    "1" | "1")
        sMainMenu;
    ;;
    "255" | "255")
        sMainMenu;
    ;;
esac

}

function menuImg() {
formSetImg;

source $dform;
slc="$?";
set_img=$(cat $scr_tmp && rm -f $scr_tmp && rm -f $dform);
case $slc in
    "0" | "0")
    clear;
    execute_func=( ${operation_restorekvm[@]} );
    executor;
    ;;
    "1" | "1")
        menuRestoreKVM;
    ;;
    "255" | "255")
        menuRestoreKVM;
    ;;
esac

}

#</dialogs>

#<functions>
#<Fn test lock file>
testproc(){
if [ -f $scriptlog ];
 then
    echo > $scriptlog;
fi

if [ -f "$signlok" ];
 then
  echo "$(date) -- ${msg[14]}">>$scriptlog;
  exit 0;
 else
  echo '1'>$signlok; 						# up trigger
  echo "$(date) -- ${msg[15]}" >>$scriptlog;
fi
}

endproc(){
if [ -f $signlok ];
 then
rm -f $signlok;
fi
echo "$(date) -- ${msg[16]}" >> $scriptlog;
}

#<Fn_executor>
function executor() {
if [[ ${#execute_func[@]} -eq 0 ]] 
    then echo "exit";
         exit 0; 
fi
for ((ex_index=0; ex_index != ${#execute_func[@]}; ex_index++))
 do
    ## !! debug operation...
    ##echo "execution: function ${execute_func[ex_index]}"
 ${execute_func[ex_index]};
done
}

#<Fn_get-tools>
function getTools() {
for ((itools=0; itools != ${#get_tools[@]}; itools++))
 do
eval get_${get_tools[$itools]}=$(whereis -b ${get_tools[$itools]}|awk '/^'${get_tools[$itools]}':/{print $2}');
list_tools[${#list_tools[@]}]="$(whereis -b ${get_tools[$itools]}|awk '/^'${get_tools[$itools]}':/{print $2}')";
done
}

#<Fn_get-lang>
function langMsg() {
if [[ ! $($get_locale|grep 'LANG='|sed 's/\LANG=//g'|grep 'ru_RU.UTF-8'|wc -m) -eq 0 ]];
    then
        set_lang="1";
    else
        set_lang="0";
fi

for ((ilang=0; ilang != ${#msg_dat[@]}; ilang++))
 do
    eval tmsg="(" $(echo -e ${msg_dat[$ilang]}) ")"; 
    msg[$ilang]=${tmsg[$set_lang]};
done
}

function formSetKVM() {
echo>$dform;
echo '$DIALOG --backtitle "                '${msg[0]}' | '$owner'" \'>>$dform
echo '  --title "'$menu_mode'" --clear \' >>$dform
echo '  --radiolist "\n              '${msg[10]}'"' '20 60 '${#path_kvm[@]}' \' >>$dform
#<input_list>
if [[ ${#path_kvm[@]} = 0 ]];
    then
    echo " don't find KVM!"
    sleep 1;
    rm -f $dform;
    exit 0;
fi

for ((ilist=0; ilist != ${#path_kvm[@]}; ilist++))
 do

    local fmark='';
    local dmark='';
    if [[ $ilist = 0 ]];
        then
        fmark='ON';
        else
        fmark='off';
    fi
    if [[ ! $ilist = $(echo $((${#path_kvm[@]} -1))) ]];
        then
        dmark='\';
        else
        dmark='2> $scr_tmp';
    fi
echo -e '"'"$(echo $(($ilist+1)))"'"' '"'"${path_kvm[$ilist]}"'"' $fmark $dmark >>$dform;
done

}

function formSetImg() {
local get_path_bak=${path_bak[$set_kvm]};
eval local get_imgs="(" $(find "$get_path_bak"/* -maxdepth 0 -type d -printf '%f\n') ")";
echo>$dform;
echo '$DIALOG --backtitle "                '${msg[0]}' | '$owner'" \'>>$dform
echo '  --title "'$menu_mode'" --clear \' >>$dform
echo '  --radiolist " '${msg[11]}': '$get_path_bak'\n '${msg[12]}'"' '20 60 '${#get_imgs[@]}' \' >>$dform
#<input_list>
if [[ ${#get_imgs[@]} = 0 ]];
    then
    rm -f $dform;
#<esc_value>
esc_title="${msg[4]}";
esc_msg="${msg[17]} \n           ${msg[9]}";
esc_menu="menuRestoreKVM";
#</esc_value>
    escScript;
fi

for ((iget=0; iget != ${#get_imgs[@]}; iget++))
 do

    local fmark='';
    local dmark='';
    if [[ $iget = 0 ]];
        then
        fmark='ON';
        else
        fmark='off';
    fi
    if [[ ! $iget = $(echo $((${#get_imgs[@]} -1))) ]];
        then
        dmark='\';
        else
        dmark='2> $scr_tmp';
    fi
echo -e '"'"${get_imgs[$iget]}"'"' '""' $fmark $dmark >>$dform;
done
}

function saveKvm() {
local save_kvm="${path_kvm[$set_kvm]}";
local save_bak="${path_bak[$set_kvm]}/$rdate";
local save_img=$(echo "${img_dev[$set_kvm]}"|sed 's/\./ /g'|awk '{print$1}');
local set_loop_main="$(losetup -f|grep -v loop-control|sed 's/\/\dev\///g')";
losetup /dev/$set_loop_main $save_kvm/$save_img.img;

if [[ ! -d $save_bak ]];
    then
    mkdir -p $save_bak;
fi

sfdisk -d /dev/$set_loop_main >$save_bak/info_sfdisk.txt;
sfdisk -l /dev/$set_loop_main >$save_bak/info_disk.txt;
dd if=/dev/$set_loop_main status=progress |pigz -p4 -M -c9>$save_bak/$save_img-dd.img.gz;
losetup -d /dev/$set_loop_main;
}

function restoreKvm() {
local rest_kvm="${path_kvm[$set_kvm]}";
local rest_bak="${path_bak[$set_kvm]}/$set_img";
local rest_img=$(echo "${img_dev[$set_kvm]}"|sed 's/\./ /g'|awk '{print$1}');
local set_loop_rmain="$(losetup -f|grep -v loop-control|sed 's/\/\dev\///g')";
losetup /dev/$set_loop_rmain $rest_kvm/$rest_img.img;
pigz -p4 -c -d -M $rest_bak/$rest_img-dd.img.gz|dd of=/dev/$set_loop_rmain status=progress;
losetup -d /dev/$set_loop_rmain;
}

#</functions>

execute_func=( ${operation_menu[@]} );
executor;
