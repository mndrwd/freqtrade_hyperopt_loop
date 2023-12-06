# freqtrade_hyperopt_loop
re-run freqtrade hyperopt indefinitely with this bash shell script

Usage:
Put both shell scripts in parent folder of freqtrade.
goto freqtrade parent folder in your virtual environment
Modify folder variables in the shell scripts

Optional: setup temp filesystem in ram using ft_hyperopt_hours.sh shell script instructions, mount to hyperopt_results folder
To avoid trashing your drives (needs alot of ram)
Modify ft_hyperopt_hours to set your desired amount of epochs (default 480)
Modify ft_hyperopt.sh to reflect your amount of cpu threads (itś the -j arg)

run example:
./ft_hyperopt_hours.sh strategy_class hours hours hyperoptlossmethod spaces timeframe(optional)
./ft_hyperopt_hours.sh mystrategy 9600 all all

hours: 9600 for 4 days, 96000 40 days

hyperoptlossmethod: all (cycles all methods permuted) or for example default: ShortTradeDurHyperOptLoss

spaces: "all" or list using 0 as seperator, like: 
roi0stoploss0trailing
roi0trailing
"all" will cycle randomly using python random method
note that "all" will include testing only ¨buy sell". forcing only testing buy+sell spaces will be accomplished by using 0 as arg
example: ./ft_hyperopt_hours.sh mystrategy 9600 ShortTradeDurHyperOptLoss 0 1h

timeframe optional, example: 1h

Script will create a "freqtrade_review folder in your home folder where the best testresults are written to.
