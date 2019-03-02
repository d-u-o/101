all: eg1

define hi
  echo "\n### $@ ######################\n"
endef

some=cut -d, -f 4,5,8,9 | sort -t, -n -k 4  | sed 's/,/,	/g'

Auto=cat $(Test)/data/auto.csv
Auto10=cat $(Test)/data/auto10000.csv
Auto1M=cat $(Test)/data/auto1M.csv
DSL= dsl/monte_carlo -n 3000 -s 1729| dsl/brooks2

egA:  ; @$(Auto) | dom | $(some) #| bestrest | super | rank
egB:  ; @$(Auto) | dom | bestrest #$(some) #| bestrest | super | rank
egC:  ; @$(Auto) | dom | bestrest | super #$(some) #| bestrest | super | rank
egD:  ; @$(Auto) | dom | bestrest | super | rank #$(some) #| bestrest | super | rank

eg0:  ; @$(hi); $(DSL) | dom | bestrest | super | rank
eg0a: ; @$(hi); $(DSL) | dom | bestrest 
eg0b: ; @$(hi); $(DSL) | dom | bestrest |super
eg1:  ; @$(hi); cat $(Test)/data/weather.csv | dom
eg2:  ; @$(hi); $(Auto) | dom | $(some); $(Auto) | head -1 | $(some)
eg3:  ; @$(hi); $(Auto) | dom | bestrest
eg4:  ; @$(hi); $(Auto) | dom | bestrest | super
eg5:  ; @$(hi); $(Auto) | dom | bestrest | super | rank
eg6:  ; @$(hi); $(Auto10) | dom | bestrest | super | rank
eg7:  ; @$(hi); $(Auto1M) | dom | bestrest | super | rank

