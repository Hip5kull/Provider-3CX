# Provider 3CX Template

## What is 3CX ?

3CX is a phone system for companies.

## What does this script do ?

This script allows you to set up a template for Yealink, Gigaset or other telephone handsets using your own trunk.
The purpose of this script is to optimize your teams' time in deploying the 3CX system and configuring templates.

Now you can deploy your VMs, modify the template according to your trunks, your name, and the name you wish to assign to the template.

## How to execute this script ?

Make sure you have the `curl` or `wget` package 

```sh
sudo apt install curl
sudo apt install wget
```

```sh
wget https://github.com/Hip5kull/Provider-3CX/blob/main/provider3cx.sh && chmod +x provider3cx.sh && sudo bash provider3cx.sh
```

```sh
curl -o curl -O http://github.com/Hip5kull/Provider-3CX/blob/main/provider3cx.sh && chmod +x provider3cx.sh && sudo bash provider3cx.sh
```
Then simply enter the file name, company name and trunk server link.

You will need to restart your 3CX's VM for the changes take effect.

