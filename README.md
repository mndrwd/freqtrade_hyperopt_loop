# freqtrade_hyperopt_loop
re-run freqtrade hyperopt indefinitely with this bash shell script

--------------

Usage:
Put both shell scripts in parent folder of freqtrade.

goto freqtrade parent folder in your virtual environment.

Modify folder variables in the shell scripts.

Modify ft_hyperopt.sh to reflect your amount of cpu threads (itś the -j arg, default 60).)

--------------

Optional: 

Setup temp filesystem in ram using ft_hyperopt_hours.sh shell script instructions, mount to hyperopt_results folder, 
to avoid trashing your drives (needs alot of ram)

Modify ft_hyperopt_hours to set your desired amount of epochs (default 480)

--------------

run example:
./ft_hyperopt_hours.sh strategy_class hours hyperoptlossmethod spaces timeframe(optional)
./ft_hyperopt_hours.sh mystrategy 9600 all all
./ft_hyperopt_hours.sh mystrategy 9600 all stoploss0roi0trailing 1h

hours: 960 loop for 40 days, 9600 400 days

hyperoptlossmethod: all (cycles all methods permuted) or for example default: ShortTradeDurHyperOptLoss

spaces: "all" (random) or list using 0 as seperator, like: 
roi0stoploss0trailing
roi0trailing

Note that "all" will include testing (only) ¨buy sell". forcing only testing buy+sell spaces will be accomplished by using 0 as arg

example: ./ft_hyperopt_hours.sh mystrategy 9600 ShortTradeDurHyperOptLoss 0 1h

timeframe optional, example: 1h

Script will create a "freqtrade_review folder in the output folder, where the best testresults are written to.
