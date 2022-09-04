@echo off
@REM 设置循环列表，递归取命令行的参数
setlocal enabledelayedexpansion
echo "Start the patch installation"
set a=%*
@REM 获取第一个参数
set patchdir=%1
@REM 将剩下的参数作为一个变量
set package=!a:%patchdir%=!
set package=%package:~1%
set remain=%package%
:loop
@REM 以逗号分隔，进行循环数组
for /f "tokens=1* delims=," %%a in ("%remain%") do (
    echo %patchdir%\%%a
    @REM 安装windows Server补丁包，wusa仅支持安装.msu后缀的补丁包
    start /wait wusa.exe %patchdir%\%%a /quiet /norestart
    echo %%a
    rem
    set remain=%%b
)
if defined remain goto :loop