# Azure-Synapse-Terraform

This Repository contains a summary of terraform scripts for the setup proof of concept (PoC) setup a of 
self serve data platform (SSDP) based on Azure with the focus on Azure Synapse.

- [Azure-Synapse-Terraform](#azure-synapse-terraform)
  - [Overview](#overview)
  - [Setup](#setup)
  - [Run](#run)
  - [Contributer](#contributer)

## Overview

In the overview chart below you can see the used Azure componentes for the 
SSDP:

## Setup 

Before you can apply the scripts u need to preaper the following things:

1. Azure Account
2. Storage Account (For the cloudshell)
3. your `object-ID`

Your `object-ID` can be found with the following command:

```bash
# this command will show all account information in your directory
az group show list 
```

## Run
To run the Terraform templates:
    ```console
    $ terraform init
    $ terraform plan
    $ terraform apply
    ```

## Contributer
+ Rafael Lazenhofer
