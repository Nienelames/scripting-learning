ipInFile="$1"
ipOutFile="$2"

# Validating args
if [ -z "$ipInFile" ] || [ -z "$ipOutFile" ];
then
   echo "Invlaid agruments."
   echo "Usage: pinger.sh <Input File> <Output File>"
   exit 1
fi

if [ ! -f "$ipInFile" ];
then
   echo "Specified directory does not exist: $ipInFile"
   exit 1
fi

echo "Checking IPs..."
ipStatusList=""
NL=$'\n'

# Pinging IPs
# Regular expression taken from stackoverflow.com
for ip in $(grep -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' $ipInFile)
do
   if ping -c 1 $ip &>/dev/null;
   then
      ipStatusList+="${ip} is up${NL}"
   else
      ipStatusList+="${ip} is down${NL}"
   fi
done

# Printing Results
if [ -z "$ipStatusList" ];
then
   echo "No IPs were found in $ipInFile"
   exit 1
fi

echo "$ipStatusList"
echo "$ipStatusList" > $ipOutFile  
echo "Results saved successfully!"
