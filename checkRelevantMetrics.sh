#!/bin/bash

if [ -z "${1}" ]
then
    echo "Please define liferay portal repo user."
    echo "e.g. ./checkRelevantMetrics liferay-core-infra"
    exit
fi

#Set URL
urlPrefix="https://api.github.com/search/issues?q=repo:${1}/liferay-portal%20is:pr%20+created%3A>%3D"

##Get dates for PR date range to be use in curl
now=$(date +'%Y-%m-%d')
lastWeek=$(date +%Y-%m-%d -d "${now} -7 days")
lastMonth=$(date +%Y-%m-%d -d "${now} -1 months")

#Calculate the relevant pass rate for the past week rounded to two decimal places
WeekTotal=$(curl -s "${urlPrefix}${lastWeek}+label%3A\"ci%3Atest%3Arelevant++-+success\"%2C\"ci%3Atest%3Arelevant++-+failure\"" | jq '.total_count')
WeekTotalPass=$(curl -s "${urlPrefix}${lastWeek}+label%3A\"ci%3Atest%3Arelevant++-+success\"" | jq '.total_count')
WeekPassRate=$(printf %.2f $(echo "(${WeekTotalPass}/${WeekTotal}) * 100" | bc -l));

#Calculate the relevant pass rate for the past month rounded to two decimal places
MonthTotal=$(curl -s "${urlPrefix}${lastMonth}+label%3A\"ci%3Atest%3Arelevant++-+success\"%2C\"ci%3Atest%3Arelevant++-+failure\"" | jq '.total_count')
MonthTotalPass=$(curl -s "${urlPrefix}${lastMonth}+label%3A\"ci%3Atest%3Arelevant++-+success\"" | jq '.total_count')
MonthPassRate=$(printf %.2f $(echo "(${MonthTotalPass}/${MonthTotal}) * 100" | bc -l));

#Echo the pass rate for the past week
echo "Weekly Relevant Pass Rate: ${WeekPassRate}%"

#Echo the pass rate for the past year
echo "Monthly Relevant Pass Rate: ${MonthPassRate}%"