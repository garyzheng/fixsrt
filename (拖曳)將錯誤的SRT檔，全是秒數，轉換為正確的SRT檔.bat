:: REM 字串比較IF判斷 變數及內容前後都要加""
:: REM #chcp 65001 用>>建文檔 為utf8
:: REM #ECHO. 等於換行
:: REM 取代s為0
:: REM 取代" --> "為",-->,"


chcp 65001
@echo off & cd/d "%~dp0"
setLocal ENABLEDELAYEDEXPANSION
:: 分出 1,2,3,4,5以後

:Loop
if "%~1"=="" goto :End_


:: 建立暫存檔 xxx.temp.srt 將字串"-->"前後" "(空白)改為","
For /F "tokens=1 delims=" %%i in ( %~nx1 ) do (
   SET STR=%%i
   SET STR=!STR: --^> =,--^>,!
   echo !STR!>>%~n1.temp.srt
)


:: 主程式，將暫存檔作處理，最終轉換為 xxx.new.srt
set C1=0
For /F "tokens=1,2,3,4,5 delims=," %%i in (%~n1.temp.srt) do (
   REM pause
   set /A C1+=1
   if "%%k" == "-->" (
      set A_ss=%%i
      set B_ss=%%l
    
      REM echo ### A_hh = !A_hh! ### A_mm = !A_mm!  ### A_ss = !A_ss! 
      
      set /A A_mm=!A_ss!/60
      set /A A_ss=!A_ss!%%60
      REM echo ### A_hh = !A_hh! ### A_mm = !A_mm!  ### A_ss = !A_ss! 

      IF !A_mm! GEQ 60 ( SET /A A_hh=!A_mm!/60 & SET /A A_mm=!A_mm!%%60 ) ELSE (SET A_hh=00)

      REM echo ### A_hh = !A_hh! ### A_mm = !A_mm!  ### A_ss = !A_ss! 
      
      :: # 若 ss 小於 10 則補 0
            IF !A_ss! LSS 10 SET A_ss=0!A_ss!
      IF !A_mm! LSS 10 SET A_mm=0!A_mm!

      SET A=!A_hh!:!A_mm!:!A_ss!
      echo A = !A!


      set /A B_mm=!B_ss!/60
      set /A B_ss=!B_ss!%%60
      echo ### B_mm = !B_mm!  ### B_ss = !B_ss!

      IF !B_mm! GEQ 60 ( SET /A B_hh=!B_mm!/60 & SET /A B_mm=!B_mm!%%60 ) ELSE (SET B_hh=00)
      
      :: 若 ss 小於 10 則補 0
      IF !B_ss! LSS 10 SET B_ss=0!B_ss!
      IF !B_mm! LSS 10 SET B_mm=0!B_mm!

      SET B=!B_hh!:!B_mm!:!B_ss!
      echo ### B = !B!

      set A_ms=%%j
      set B_ms=%%j

      :: REM 本來刪除 ms 的尾碼 s
      :: REM 但有 2s 或 01s，最後決定偷懶將 s 置換 0
      set A_ms=!A_ms:s=0!
      set B_ms=!B_ms:s=0!

      echo !A!,!A_ms! --^> !B!,!B_ms!>> %~n1.new.srt

   ) ELSE ( 
         echo %%%i = %%i
         if "%%i" NEQ "" (echo %%i>> %~n1.new.srt) else ( echo.>> %~n1.new.srt)
         if !C1! == 3 ( 
         echo.>>%~n1.new.srt
         set /A C1=0
      )
      
   )

)
del %~n1.temp.srt
shift /1
if not "%~1"=="" goto :Loop

pause
chcp 950
endlocal

:End_