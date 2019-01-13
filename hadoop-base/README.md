# hadoop base
Base hadoop docker image base on ubuntu

## Versions
Hadoop: 3.1.1  
OpenJdk: 1.8.0_202

## Prepare  
- Download `hadoop` and `openjdk-8` and put into folder `achives`:
```
achives
  - hadoop-3.1.1.tar.gz
  - jdk-8u202-ea-bin-b03-linux-x64-07_nov_2018.tar.gz
```
> Use offline mode here, due to slow network :(

## Build
```
docker build -t idata-lab/hadoop-base:latest .
```