#!/bin/bash

cd /Applications/FlightGear.app/Contents/Resources 
#cd ~/Desktop/FlightGear.app/Contents/Resources 

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH/:/Applications/FlightGear.app/Contents/Resources/plugins/
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH/:/Users/aholtzma/Desktop/FlightGear.app/Contents/Resources/plugins/

#./fgfs --aircraft=C172p --fdm=network,localhost,5501,5502,5503 --fog-fastest --disable-clouds --start-date-lat=2004:06:01:09:00:00 --disable-sound --in-air --enable-freeze --altitude=3000 --heading=113 --offset-distance=4.72 --offset-azimuth=0  --log-level=info # --help --verbose
./fgfs --aircraft=ufo --fdm=network,localhost,5501,5502,5503 --fog-fastest --disable-clouds --disable-sound --in-air --enable-freeze --altitude=3000 --heading=113 --offset-distance=4.72 --offset-azimuth=0 --log-level=info # --verbose #--show-aircraft 
