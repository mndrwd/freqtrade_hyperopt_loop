# freqtrade_bruteforce_bash
re-run freqtrade hyperopt indefinitely with this bash shell script

Usage:
Put both shell scripts in parent folder of freqtrade.
goto freqtrade parent folder in your virtual environment
Modify folder variables in the shell scripts

Optional: setup temp filesystem in ram using ft_hyperopt_hours.sh shell script instructions, mount to hyperopt_results folder
To avoid trashing your drives (needs alot of ram)

run example:
./ft_hyperopt_strategy_class hours hours hyperoptlossmethod spaces timeframe(optional)
./ft_hyperopt mystrategy 9600 all all

hours: 9600 for 4 days, 96000 40 days

hyperoptlossmethod: all (cycles all methods) or for example default: ShortTradeDurHyperOptLoss

spaces: "all" or list using 0 as seperator, like: 
roi0stoploss0trailing
roi0trailing

timeframe optional, example: 1h

Script will create a "freqtrade_review folder in your home folder where the best testresults are written to.
