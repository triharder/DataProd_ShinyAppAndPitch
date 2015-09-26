library(Lahman)
library(dplyr)
library(sqldf)

#Working Data - gather batting statistics of interest
stats <- select(Batting,c(1,2,4,6:14,16:21))
stats[is.na(stats)] <- 0    #must convert NA for further computation

#Reference Data
## Gather all player names
IDnames <- as.data.frame(cbind(Master$playerID,paste(Master$nameFirst,Master$nameLast)))
colnames(IDnames) <- cbind("playerID","Player")

## Gather all team names
IDteams <- as.data.frame(cbind(as.character(Teams$teamID),Teams$name))
colnames(IDteams) <- c("teamID","Team")
teamNames <- distinct(IDteams)

## Combine player and team data; must use batting dataset for correlation of playerID and teamID
### Rollup by teams
playerTeams <- left_join(stats,teamNames,by="teamID")
playerTeams <- distinct(select(playerTeams,playerID,Team,teamID))
playerTeams <- sqldf("select playerID, group_concat(Team,',') as Teams, count(distinct teamID) as TeamCnt from playerTeams group by playerID")

# Prepare data for app
statsApp <- summarize(group_by(stats,playerID),HR=sum(HR),RBI=sum(RBI),R=sum(R),BA=round((sum(H)/sum(AB)),3),H=sum(H),'2B'=sum(X2B),'3B'=sum(X3B),XBH=sum(X2B)+sum(X3B)+HR,BB=sum(BB),BBadj=BB+sum(IBB)+sum(HBP),SB=sum(SB),SO=sum(SO),SAC=sum(SH+SF),SH=sum(SH),SF=sum(SF),G=sum(G),PA=sum(AB+BB+HBP+SH+SF),Debut=min(yearID),Retire=max(yearID),Yrs=Retire-Debut,PAperYR=round(PA/Yrs))
playerStats <- inner_join(IDnames,statsApp,by="playerID")
playerStats <- left_join(playerStats,playerTeams,by="playerID")

#Reduce data to reasonable size based on plate appearances: min 300 and remove Inf values
playerStats <- filter(playerStats,PAperYR >= 300)
is.na(playerStats) <- sapply(playerStats,is.infinite)
playerStats <- na.omit(playerStats)

# Final data table
playerStats <- playerStats[,c(2:15,18:22,24:25)]
