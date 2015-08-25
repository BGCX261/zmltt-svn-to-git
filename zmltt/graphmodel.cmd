PATH d:\soft\graphviz\bin;c:\ruby\bin
rem rake db:migrate VERSION=0
rem rake db:migrate VERSION
railroad -M -a -m -t -p | neato -Tpng > model.png