#!/bin/sh

# Takin に必要な初期テーブルを作成するスクリプト．最初に一回実行して試行錯誤するのに利用した．

rails=./bin/rails

$rails generate scaffold course year:integer term:string number:string name:string instructor:string time_budget:integer description:string --force
$rails generate scaffold teaching_assistant year:integer number:string name:string grade:string labo:string description:string --force
$rails generate scaffold assignment course:references teaching_assistant:references description:string --force
$rails generate scaffold work_hour dtstart:datetime dtend:datetime actual_working_minutes:integer assignment:references --force
