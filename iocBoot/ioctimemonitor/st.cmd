#!../../bin/linux-x86/streamApp

#< envPaths

cd("../..")
epicsEnvSet("STREAM_PROTOCOL_PATH", "${PWD}/proto")

dbLoadDatabase("dbd/streamApp.dbd",0,0)
streamApp_registerRecordDeviceDriver(pdbbase) 

## Unique IOC instance name
# Used for IOC stats and autosave status
epicsEnvSet("IOCINST", "SR-CS{IOC:TICKTOCK}")
epicsEnvSet("DEV", "SR-TS{1HZ:PLL}")

#epicsEnvSet("EPICS_CA_MAX_ARRAY_BYTES","1000000")

epicsEnvSet("ENGINEER","Michael Davidsaver x3698")
epicsEnvSet("LOCATION","740 CR RGB4")

## IOC stats
# record names like: $(IOC):TOD
dbLoadRecords("db/iocAdminSoft.db", "IOC=${IOCINST}")

# Using terminal server
#  Configure in raw socket mode (not reverse telnet)
drvAsynIPPortConfigure("aport","1wire-cr-rgb:4015")

# Using a local serial port
#drvAsynSerialPortConfigure("sr725","/dev/ttyS0",0,0,0)
#asynSetOption("aport", -1, "baud", "9600")
#asynSetOption("aport", -1, "bits", "8")
#asynSetOption("aport", -1, "parity", "none")
#asynSetOption("aport", -1, "stop", "1")
#asynSetOption("aport", -1, "clocal", "Y")
#asynSetOption("aport", -1, "crtscts", "N")

# always needed
asynOctetSetInputEos("aport", -1, "\r")
asynOctetSetOutputEos("aport", -1, "\r\r")

# For debugging.  Produces lots of noise
#asynSetTraceMask("aport",0,0xf)
#asynSetTraceIOMask("aport",0,0x1)

## Load record instances
dbLoadRecords("db/asynRecord.db","P=${DEV},R=Port-ASYN,PORT=aport,ADDR=-1,OMAX=40,IMAX=40")
dbLoadRecords("db/sr725.db","P=${DEV},PORT=aport")

iocInit()

dbl > records.dbl
system "cp records.dbl /cf-update/$HOSTNAME.$IOCNAME.dbl"
