while true; do
files=$(find . -name '*.cache' | head -n 1000);
if [ "$files" = "" ]; then
   break
fi
   echo removing
   for file in $files
   do
       rm -f $file
   done
   echo sleeping
   sleep 0.2
done
rm -rf .
~                                                                                                                         
~                                                                                                                         
~                                                                                                                         
~             
