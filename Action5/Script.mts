
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:IDEXX_Automation
'Action Name: Action1
'Function/Sub Name:
'Description:Initiate Automated Execution
'Argument List: 
'Return Value:
'Author: Vikas Joshi
'Creation Date:    15 Nov 2013     
'Calling Functions:Start_Execution
'Called Functions:
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details: IDEXX QA Order
'Comments:
'Copyrights:Marlabs Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----


'
'Start Autmated Execution
Call Start_Execution








'
'
''SystemUtil.Run "E:\Backup\8\Unified Functional Testing\LIB\MIST_GUI.jar"
'TestData_Path=Environment.Value("TestDir") & "\TestData\"
'GUI_Path=TestData_Path & "MIST_GUI.jar"
'SystemUtil.Run "cmd","/k java -jar C:\MIST_GUI.jar",""
'
''Create a hold - file check
'Config_Path=TestData_Path  &  "config.xml" ' Need to standardize this  - thi s is temp
'call ReadWriteLineXMLFile(Config_Path,0,"")