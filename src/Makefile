all: eg1

define hi
  echo "\n### $@ ######################\n"
endef

some=cut -d, -f 4,5,8,9 | sort -t, -n -k 4  | sed 's/,/,	/g'

Auto=$(Test)/data/auto.csv

ok:; @bash $(Etc)/lua2bin

eg1: ok; @$(hi); cat $(Test)/data/weather.csv | dom
eg2: ok; @$(hi); cat $(Auto) | dom | $(some); head -1 $(Auto) | $(some)
eg3: ok; @$(hi); cat $(Auto) | dom | label
eg4: ok; @$(hi); cat $(Auto) | dom | label | super
eg5: ok; @$(hi); cat $(Auto) | dom | label | super | best

