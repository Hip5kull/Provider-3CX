#!/bin/bash
############################################
#
# Automate 3CX Provider 
# You have to execute this script as root
#
# Execute the commands bellow:
#
# chmod u+x provider3cx.sh 
# sudo bash provider3cx.sh
#
#
############################################

if [[ $EUID -ne 0 ]]; then

   echo "You have to execute this script as root." 

   exit 1

fi

echo "Please enter the name of the file (without extension): "
read filename

echo "Please enter your company name: "
read companyname

echo "Please enter your trunk link: "
read trunklink

function copying(){
    cp GenericVoIPProvider.pv.xml GenericVoIPProvider.pv.xml.old
}

function rename(){
    mv GenericVoIPProvider.pv.xml ${filename}.pv.xml
}

function provider(){
   echo '<doc>
<header>
<name>'${companyname}'</name>
<time>2023-06-19T12:19:55.9110258Z</time>
<template>GenericVoIPProvider.pv.xml</template>
<type>gateway-template</type>
</header>
<data>
<device>
<field name="Name">'${companyname}'</field>
<type>provider</type>
<manufacturer/>
<model>provider</model>
<field name="RegistrarHost">'${trunklink}'</field>
<field name="RegistrarPort">5060</field>
<field name="ProxyHost">'${trunklink}'</field>
<field name="ProxyPort">5060</field>
<field name="SecondaryRegistrar"/>
<field name="IPRestriction">ANY</field>
<field name="TransportRestriction">ANY</field>
<field name="RequireAuthFor">4</field>
<field name="IpInContactReg">2</field>
<field name="IpInContactRegValue"/>
<field name="TimeBetweenRegistration">60</field>
<field name="RegistrarInvite">0</field>
<field name="IsSupportReinvite">0</field>
<field name="IsSupportReplaces">0</field>
<field name="DisableVideo">1</field>
<field name="SRTPMode">0</field>
<field name="IsBindToMS">1</field>
<codecs>
<codec rfcname="pcma"/>
<codec rfcname="g729"/>
</codecs>
<field name="Source" custom="" parameter="ContactHost">$GWHostPort</field>
<field name="ParameterIn" custom="" parameter="FromUserPart">$CallerNum</field>
<field name="ParameterIn" custom="" parameter="FromDisplayName">$CallerName</field>
<field name="ParameterIn" custom="" parameter="ToUserPart">$CalledNum</field>
<field name="ParameterOut" custom="" parameter="RequestLineURIUser">$CalledNum</field>
<field name="ParameterOut" custom="" parameter="RequestLineURIHost">$GWHostPort</field>
<field name="ParameterOut" custom="PUT YOUR TUNK PHONE NUMBER HERE" parameter="ContactUser">$CustomField</field>
<field name="ParameterOut" custom="" parameter="ContactHost">$ContactUri</field>
<field name="ParameterOut" custom="" parameter="ToDisplayName">$CalledName</field>
<field name="ParameterOut" custom="" parameter="ToUserPart">$CalledNum</field>
<field name="ParameterOut" custom="" parameter="ToHostPart">$GWHostPort</field>
<field name="ParameterOut" custom="" parameter="FromDisplayName">$OriginatorCallerId</field>
<field name="ParameterOut" custom="" parameter="FromUserPart">$OriginatorCallerId</field>
<field name="ParameterOut" custom="" parameter="FromHostPart">$GWHostPort</field>
<field name="ParameterOut" custom="3CX" parameter="UserAgentTextString">$CustomField</field>
<field name="ParameterOut" custom="" parameter="RemotePartyIDCallingPartyDisplayName">$OriginatorCallerId</field>
<field name="ParameterOut" custom="" parameter="RemotePartyIDCallingPartyUserPart">$OriginatorCallerId</field>
<field name="ParameterOut" custom="" parameter="RemotePartyIDCallingPartyHostPart">$GWHostPort</field>
</device>
<sms>
<variable name="MESSAGING_API_KEY">
<option/>
</variable>
<variable name="PROVIDER_URL">
<option/>
</variable>
<field name="Enabled">0</field>
<field name="OptionalProvider">1</field>
<field name="ProviderType">generic</field>
<field name="OutboundRouting">1</field>
<field name="ProviderName">Generic</field>
</sms>
</data>
</doc>' > ${filename}.pv.xml
}

function main(){
    while true;
    do
        cd /var/lib/3cxpbx/Instance1/Data/Http/Interface/provisioning/
        echo " ---- Provider Execution ---- "        
        echo ""

        local state=0
        echo "[+] Backup GenericVoIPProvider....done "
        copying
        state=$((state + $?))

        echo "[+] Renaming to ${filename}.pv.xml....done "; rename
        state=$((state + $?))

        echo "[+] Replacing XML provider....done "; provider
        state=$((state + $?))
    
        if [ $state -eq 0 ]; then
            echo ""
            echo "All successful operations"
            break
        else
            echo ""
            echo "One or more operations have failed, status: $state "
            break
        fi
    done
}

main;

while true; do
    echo ""
    read -p "Do you want to restart 3CX ? (Y/n)" reponse
    case $reponse in
        [Yy]* ) echo "[+] Reboot in progress...."
                shutdown -r now
                ;;
        [Nn]* ) exit 0;;
        * ) echo "Please input Y ou N.";;
    esac
done
