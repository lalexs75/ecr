#!/bin/bash
#надо скопировать rx.inc в текущий каталог, иначе не соберём (глюк fpdoc)
#cp ../rx.inc rx.inc 
fpdoc --package=atol_ecr --format=html --index-colcount=4 --hide-protected \
  --input=../kkm_atolpropsunit.pas --descr=ecr.xml \
  --input=../kkm_atol.pas --descr=ecr.xml
