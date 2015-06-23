#!/bin/bash

noir='\e[0;30m'
gris='\e[1;30m'
rougefonce='\e[0;31m'
rose='\e[1;31m'
vertfonce='\e[0;32m'
vertclair='\e[1;32m'
orange='\e[0;33m'
jaune='\e[1;33m'
bleufonce='\e[0;34m'
bleuclair='\e[1;34m'
violetfonce='\e[0;35m'
violetclair='\e[1;35m'
cyanfonce='\e[0;36m'
cyanclair='\e[1;36m'
grisclair='\e[0;37m'
blanc='\e[1;37m'
neutre='\e[0;m'

BACKUP=""
if [[ ! -f /usr/bin/youtube-dl ]]; then
    xterm -e "echo 'Installation de Youtube-DL'; sudo apt-get install youtube-dl python-pip;echo '\n\nMise à jour de Youtube-DL'; sudo youtube-dl -U; sudo pip install --upgrade youtube_dl"
fi

function refreshForms() {
    if [[ "$1" != "" ]]; then
        BACKUP="$1|${BACKUP}"
    fi
    out=`zenity --forms --title="ZYoutubeDL" \
        --text="Ajouter les liens Youtube à votre liste d'attente <i>(Valider le formulaire sans ajouter de lien pour lancer le téléchargement)</i>" \
        --separator="" \
        --add-entry="Ajouter un lien:"\
        --add-list="Liste d'attente:"\
        --list-values=${BACKUP}`
    if [[ "$out" != "" ]]; then
        refreshForms "$out"
    else
        if [[ "$BACKUP" != "" ]]; then
            zenity --question --title="ZYoutubeDL" --text="Souhaitez vous lancer le téléchargement maintenant?"
            if [[ $? -eq 0 ]]; then
                dir=$HOME
                dir=`zenity --file-selection --directory --title="ZYoutubeDL" --text="Selectionnez le répertoire où les vidéos seront sauvegardés."`
                if [[ $? != 0 ]]; then
                    dir=$HOME
                fi
                olddir=$PWD
                cd $dir
                echo $BACKUP | sed 's/|/\n/g' | while read link; do
                    if [[ "$link" != "" ]]; then
                        
                        xterm -e youtube-dl "$link"
                    fi
                done
                cd $olddir
                BACKUP="";
                refreshForms
                exit 0
            else
                zenity --question --title="ZYoutubeDL" --text="Souhaitez vous quitter ZYoutubeDL maintenant?"
                if [[ $? != 0 ]]; then
                    BACKUP="";
                    refreshForms
                else 
                    exit 0
                fi
            fi
        else 
            zenity --question --title="ZYoutubeDL" --text="Souhaitez vous quitter ZYoutubeDL maintenant?"
            if [[ $? != 0 ]]; then
                BACKUP="";
                refreshForms
            else 
                exit 0
            fi
        fi
    fi
}

#Initialisation
out=`zenity --forms --title="ZYoutubeDL" \
        --text="Ajouter les liens Youtube à votre liste d'attente <i>(Valider le formulaire sans ajouter de lien pour lancer le téléchargement)</i>" \
        --separator="" \
        --add-entry="Ajouter un lien:"\
        --add-list="Liste d'attente:"\
        --list-values=${BACKUP}`
if [[ "$out" != "" ]]; then
    refreshForms "$out"
else
    zenity --question --title="ZYoutubeDL" --text="Souhaitez vous quitter ZYoutubeDL maintenant?"
    if [[ $? != 0 ]]; then
        refreshForms
    else 
        exit 0
    fi
fi

exit 0
