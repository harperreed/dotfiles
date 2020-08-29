#!/bin/zsh

print_usage (){
echo “USAGE:”
echo -e “\t $0 inputfile.svg [outputfile.eps]”
}

build_eps_filename(){
echo “$1″ | sed -e ‘s@.svg@.eps@g’
}

if [ “$1″ = “” ]
then
print_usage
exit
fi

if [ “$2″ = “” ]
then
OUTPUT=`build_eps_filename $1`
else
OUTPUT=$2
fi

echo “Converting $1 to $OUTPUT …”

inkscape -z -T -E $OUTPUT $1
