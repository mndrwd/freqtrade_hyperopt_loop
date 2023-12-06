#$1 =  strategyname $2 = epochs
#--spaces buy sell roi stoploss trailing
# --disable-param-export
#                        ShortTradeDurHyperOptLoss, OnlyProfitHyperOptLoss,
#                        SharpeHyperOptLoss, SharpeHyperOptLossDaily,
#                        SortinoHyperOptLoss, SortinoHyperOptLossDaily,
#                        CalmarHyperOptLoss, MaxDrawDownHyperOptLoss,
#                        MaxDrawDownRelativeHyperOptLoss,
#                        ProfitDrawDownHyperOptLoss
# ShortTradeDurHyperOptLoss \
# OnlyProfitHyperOptLoss \
# SharpeHyperOptLoss \
# SharpeHyperOptLossDaily \
# SortinoHyperOptLoss \
# SortinoHyperOptLossDaily \
# CalmarHyperOptLoss \
# MaxDrawDownHyperOptLoss \
# MaxDrawDownRelativeHyperOptLoss \
# ProfitDrawDownHyperOptLoss \

if [ -z "$5" ]
 then
tfrs=""
else
 tfrs=" -i $5 "
fi

freqtrade hyperopt \
 --min-trades 1 \
 --hyperopt-loss $3 \
 --spaces buy sell ${4//0/ } \
 --disable-param-export \
 --timerange 20220601-20230101 \
 --ignore-missing-spaces \
 --strategy $1 \
 -e $2 \
  $tfrs \
 --analyze-per-epoch \
 -p BTC/USDT ETH/USDT DOGE/USDT SHIB/USDT XRP/USDT ADA/USDT MATIC/USDT SOL/USDT TRX/USDT LTC/USDT DOT/USDT AVAX/USDT UNI/USDT ATOM/USDT HBAR/USDT ETC/USDT XLM/USDT QNT/USDT \
 -j 60
