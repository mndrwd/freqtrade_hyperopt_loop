#/!bin/bash

# 1st parameter: strategy class name
# 2nd parameter: how many hours testing
# 3rd parameter: hyperopt-loss method ("all" cycles all)
# 4rd parameter: spaces, min 0 max 7 for fixed or -1 for random
# 5th parameter: timeframe or empty (all random)

mintrades=50
minprofit=50
outputfolder="/home/babo/freqtrade_review"
freqtradefolder="/mnt/3-8tb-ssd-ml/freqtrade"
#make ramfs
#mkdir -p user_data/hyperopt_results
#mount -t tmpfs -o size=4096M tmpfs user_data/hyperopt_results

#3rd parameters:
# ShortTradeDurHyperOptLoss \
# OnlyProfitHyperOptLoss \
# SharpeHyperOptLoss \
# SharpeHyperOptLossDaily \
# SortinoHyperOptLoss \
# SortinoHyperOptLossDaily \
# CalmarHyperOptLoss \
# MaxDrawDownHyperOptLoss \ #probably best
# MaxDrawDownRelativeHyperOptLoss \ #or this one
# ProfitDrawDownHyperOptLoss \ ## BROKEN @ 2023.10



###############################################
# actual code below

mkdir -p ${outputfolder}
cd ${freqtradefolder}
if [ -z "$2" ]
  then
   HRS=12
  else
  HRS=$2
fi

AATIME=$((HRS*60*60))


end=$((SECONDS+$AATIME))


#pick hyperopt-loss method
# ShortTradeDurHyperOptLoss \
# OnlyProfitHyperOptLoss \
# SharpeHyperOptLoss \
# SharpeHyperOptLossDaily \
# SortinoHyperOptLoss \
# SortinoHyperOptLossDaily \
# CalmarHyperOptLoss \
# MaxDrawDownHyperOptLoss \
# MaxDrawDownRelativeHyperOptLoss \
# ProfitDrawDownHyperOptLoss \ ## BROKEN @ 2023.10

tmpnr=0

if [ -z "$5" ]
 then
  tfr=""
 else
  tfr=$5
fi



while [ $SECONDS -lt $end ]; do
 rm user_data/hyperopt_results/*

if [ -z "$5" ]
 then
  tfint=`python -S -c "import random; print(random.randrange(0,6))"`
# rng8 includes all listed; test timeframe eq 7
  if [[ $tfint -eq 0 ]]
  then
  tfr="3m"
  elif [[ $tfint -eq 1 ]]
  then
  tfr="5m"
  elif [[ $tfint -eq 2 ]]
  then
  tfr="15m"
  elif [[ $tfint -eq 3 ]]
  then
  tfr="30m"
  elif [[ $tfint -eq 4 ]]
  then
  tfr="1h"
  elif [[ $tfint -eq 5 ]]
  then
  tfr="4h"
  elif [[ $tfint -eq 6 ]]
  then
  tfr="1d"
  elif [[ $tfint -eq 7 ]]
  then
  tfr="1w"
 fi
fi
tfrfn=$tfr

spcsint=$4
if [ "$4" = "all" ]
 then
  spcsint=`python -S -c "import random; print(random.randrange(0,8))"`
fi
  if [[ $spcsint -eq 0 ]]
  then
  spcs="0"
  elif [[ $spcsint -eq 1 ]]
  then
  spcs="roi"
  elif [[ $spcsint -eq 2 ]]
  then
  spcs="stoploss"
  elif [[ $spcsint -eq 3 ]]
  then
  spcs="trailing"
  elif [[ $spcsint -eq 4 ]]
  then
  spcs="trailing0stoploss"
  elif [[ $spcsint -eq 5 ]]
  then
  spcs="roi0stoploss"
  elif [[ $spcsint -eq 6 ]]
  then
  spcs="trailing0roi"
  elif [[ $spcsint -eq 7 ]]
  then
  spcs="trailing0stoploss0roi"
 fi



 if [ "$3" = "all" ]
  then
   if [[ $tmpnr -eq 0 ]]
   then
    loss="ShortTradeDurHyperOptLoss"
   elif [[ $tmpnr -eq 1 ]]
   then
    loss="OnlyProfitHyperOptLoss"
   elif [[ $tmpnr -eq 2 ]]
   then
    loss="SharpeHyperOptLoss"
   elif [[ $tmpnr -eq 3 ]]
   then
    loss="SharpeHyperOptLossDaily"
   elif [[ $tmpnr -eq 4 ]]
   then
    loss="SortinoHyperOptLoss"
   elif [[ $tmpnr -eq 5 ]]
   then
    loss="CalmarHyperOptLoss"
   elif [[ $tmpnr -eq 6 ]]
   then
    loss="MaxDrawDownHyperOptLoss"
   elif [[ $tmpnr -eq 7 ]]
   then
    loss="MaxDrawDownRelativeHyperOptLoss"
  elif [[ $tmpnr -eq 8 ]]
   then
    loss="BGB_MaxDrawDownRelativeHyperOptLoss"
   elif [[ $tmpnr -eq 9 ]]
   then
    loss="ProfitDrawDownHyperOptLoss"
   fi
  tmpnr=$((tmpnr+1))
  if [ $tmpnr -eq 7 ]
  then
   tmpnr=0
  fi
  else
 loss=$3
 fi

    ../ft_hyperopt.sh $1 480 $loss $spcs $tfr
    touch user_data/hyperopt_results/${1}tmp.log
    freqtrade hyperopt-list --min-objective -50 --profitable --min-trades ${mintrades} --min-total-profit ${minprofit} --print-json >>user_data/hyperopt_results/${1}tmp.log
    #if cat user_data/hyperopt_results/${1}tmp.log | grep -q "INFO - 0 best profitable epochs found"; then
     if [ $(stat -c %s user_data/hyperopt_results/${1}tmp.log) -lt 4 ]; then
     rm user_data/hyperopt_results/*
     else
     touch ${outputfolder}/list-${1}-${tfrfn}-${spcs}.log
     cat user_data/hyperopt_results/${1}tmp.log >> ${outputfolder}/list-${1}-${tfrfn}-${spcs}.log
     #rm user_data/hyperopt_results/${1}tmp.log
     touch ${outputfolder}/${1}-${tfrfn}.log
     freqtrade hyperopt-show --best --profitable >>user_data/hyperopt_results/${1}-${tfrfn}.log
     sleep 10
     cat  user_data/hyperopt_results/${1}-${tfrfn}.log >> ${outputfolder}/${1}-${tfrfn}.log
     cat user_data/strategies/${1}.json >> ${outputfolder}/${1}-${tfrfn}.log
     echo "END-------------------" >> ${outputfolder}/${1}-${tfrfn}.log
     #rm user_data/hyperopt_results/*
    fi
    :
done
