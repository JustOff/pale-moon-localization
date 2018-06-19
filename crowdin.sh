#!/bin/sh
# To run under Windows use MozillaBuild package - https://forum.palemoon.org/viewtopic.php?f=19&t=13556
LANG=en_US.utf8

if [ ! -f .crowdin.key ]; then
  printf "\n.crowdin.key not found\n" && exit
else
  key=`cat .crowdin.key`
fi

for lang in ar bg cs da de el en-GB es-AR es-ES es-MX eo fi fr gl hr hu id is it ja kn ko nl pl pt-BR pt-PT ro ru sk sl sr sv-SE tl tr uk vi zh-CN zh-TW
do
  printf "\n  downloading $lang locale from CrowdIn:\n\n"
  wget -q --show-progress https://api.crowdin.com/api/project/pale-moon/download/$lang.zip?key=$key -O $lang.zip
  if [ $? -ne 0 ]; then
   exit
  fi
  sh ./crowdin-fix.sh $lang
  if [ $? -ne 0 ]; then
   exit
  fi
  printf "\n  applying updates for $lang locale ... "
  unzip -oq $lang-fix.zip -d $lang
  if [ $? -eq 0 ]; then
   printf "done\n\n"
   rm $lang.zip $lang-fix.zip
  else
   exit
  fi
done
