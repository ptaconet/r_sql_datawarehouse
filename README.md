# Deployment, management and exploitation of data warehouses with the R programming language

## Project

This repository gathers the scripts and documentation for a methodology to deploy, load, update and exploit a data warehouse (as a PostgreSQL database) through the R programming language. The R scripts that we have developed enable to i) deploy the physical model of the database, ii) manage the extraction - transformation - upload (ETL) process, iii) access the data in R, and iv) set-up the FAIR principles on the data stored on the DW, to improve their management (discovery, access, processing, information / visualization). The inputs of these scripts are mainly simple csv files. The data warehouse model that we propose has got the following characteristics:

- Flexibility, meaning ability for the user to adapt the facts and dimensions of the data
warehouse to his/her data ;
- Ability to store multiple reference data, including spatial reference data (managed
through the PostGIS extension of PostgreSQL) ;
- Inclusion of a table dedicated to the metadata associated to each dataset loaded in
the data warehouse.

The methodology was initially developed to implement the [global tuna atlas] (https://bluebridge.d4science.org/group/fao_tunaatlas) and the [french tropical tuna atlas] (https://bluebridge.d4science.org/web/frenchtropicaltunaatlas) data warehouses and catalogues.

## Fundings

French Research Institute for Sustanaible Development (IRD www.ird.fr)

This work has received funding from the European Union's Horizon 2020 research and innovation programme under the BlueBRIDGE project (Grant agreement No 675680).

## Repository organization

- figures : figures used in the documentation

- r_scripts_datawarehouse_management : R scripts to manage the datawarehouse, including i) scripts to deploy the physical model of the datawarehouse, ii) functions to load datasets in the DW, iii) functions to retrieve datasets stored in the DW

- sql_scripts_datawarehouse_creation : SQL queries that are used in the R scripts to deploy the physical model of the datawarehouse

- documentation_datawarehouse_SQL_R.pdf : documentation of the project