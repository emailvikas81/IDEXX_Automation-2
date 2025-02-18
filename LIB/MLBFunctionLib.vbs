'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:Start_Execution
'Description:To Start the execution
'Argument List: 
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'Option Explicit
Dim ChildrenList(),bjectIndex,ObjectCount'global variable for GetChildren2() function
Dim ChildrenList2(),ObjectIndex2,ObjectCount2'global variable for FindChildren()
Dim ErrorCode
Const MaxWaitTime=300
Dim Operation,SeqNo,TaskResponse,excelPath,TDexcelPath
Dim OutputCells,OutputRowNo,OutputColNo
Dim Parameters(),Values(),oDescription(),ResumeExecution  
Dim ExcelObject
Function Start_Execution
	SystemUtil.CloseProcessByName "Excel.EXE" 
	If DataTable.Value ("ResumeExecution", "Global")="Completed" And ResumeExecution =1 Then
		Reporter.ReportEvent micDone,"Previous execution was completed","Try executing freshly"
		ExitAction
	ElseIf ResumeExecution= 1 Then	'Initialize DataTable if ResumeExecution Global variable is set to 1 
		DataTable.Value ("ResumeExecution", "Global") =ResumeExecution	
	ElseIf DataTable.Value ("ResumeExecution", "Global") <> "" Then	'Initialize Global Variable , if ResumeExecution field in Global DT is set to 1
		ResumeExecution=DataTable.Value ("ResumeExecution", "Global") 
	End If

	'Declare Variables
	Dim ColSheets,usedColumnsCount2,InputCells,usedColumnsCount3,ODRowCount,TCName,ExcnStatus,OnFail,DependOn,Comments,SeqNo2,Temp
	'Dim ExcelObject,WBObject,OSSheet,OSColCount,OSRowCount,IDSheet,IDColCount,IDRowCount,ODSheet,ODColCount,ODRowCount
	Dim WBObject,OSLoop,ExecutionStatus,Execut,n,IDRowNum,IDColNum,Flag,iRowCount,IDRowCount,Operation2
	Dim TestDir,TestDataExcelPath,LogPath,Status,WriteStatus
	Dim DateFolder,TimeFolder,FolderPath
	Dim ObjFSO
	Dim StartTime, EndTime,TimeIt
	'Dim excelPath  ' the path to the excel file
'	Dim ExcelObject ' the Excel Application
	Dim worksheetCount ' how many worksheets are in the current excel file
	Dim counter, j,TaskStatus
	Dim currentWorkSheet ' the worksheet we are currently getting data from
	Dim usedColumnsCount ' the number of columns in the current worksheet that have data in them
	Dim usedRowsCount ' the number of rows in the current worksheet that have data in them
	Dim row
	Dim top ' the topmost row in the current worksheet that has data in it
	Dim Cells
	Dim curCol,curRow ' the current row and column of the current worksheet we are reading
	Dim word ' the value of the current row and column of the current worksheet we are reading
	Dim TestDataPathFile ' Stores TestData xls file path
	Dim TestCaseName'Stores The Testcase name
	Dim chk_path 'To check whether the input test name is a path <------------------------------------------------
	Dim sDll_path,oPreventSystemLock
 
                                                                                                  
                                                                                 
	'Initialize Variables


	' where is the Excel file located?
	
    TestDir=Environment.Value("TestDir")    ' TestData folder Path;For QC execution Uncomment   (TestData folder Path)
	'LogPath=TestDir&"\TestData\Excelpath.txt"
	'TestDataExcelPath=ReadWriteLineTextFile(LogPath,0,"")
	
 	TestCaseName=Environment.Value ("TestName")
	LogPath=TestDir & "\TestData\Log.txt" 'Log file path		'LogPath=TestDataPathFile ' why this? 
	
	If ResumeExecution="1" Then                   'If execution is resuming from the previous point of execution
		TDExcelPath= ReadWriteLineTextFile(LogPath,0,"")    'Get Previous test data excel  file name
		Reporter.ReportEvent micDone,"Resuming Execution...","Referred Test Data File:" & TDExcelPath 
		Set objFSO = CreateObject("Scripting.FileSystemObject")
		If ObjFSO.FileExists(TDExcelPath)<> True Then      'If file not found
			Reporter.ReportEvent micFail,"File not found.",TDExcelPath & "," & err.description
			ExitTest
		End If
	Else

		ExcelPath =  TestDir&"\TestData\TestData.xlsx"'                                                                                                       
		ExcelPath=InputBox("Please enter testdata file path","Test data path",ExcelPath)
   
		If ExcelPath="" Then
			Reporter.ReportEvent micWarning,"User pressed Cancel button. Ending execution",""
			ExitTest
		End If
		Status=CheckFile(ExcelPath)
		If Status=0 Then
			Reporter.ReportEvent micWarning, "File path: " & ExcelPath & " doesn't exist, ending execution",""
			ExitTest
		End If
		
			DateFolder=GenerateDateStamp ' Generate unique date & time stamp    ''-----Generating time and date when ever the folder is opened to execute
			TimeFolder=GenerateTimeStamp    
			FolderPath=TestDir & "\TestData"
			Status=FolderCreate(FolderPath) 'Create folder if doesn't exist
			
			If Status<>58 And Status <> "" Then ' 58=>Folder exists And "" => Folder created successfully
                Reporter.ReportEvent micFail, "Folder couldn't be created " & FolderPath & " .Ending execution",""
				ExitTest
			End If
			
			FolderPath=FolderPath & "\" &  DateFolder       'Create a folder with date-stamp           
			
			
			Status=FolderCreate(FolderPath) 'Create folder if doesn't exist
			
			If Status<>58 And Status <> "" Then ' 58=>Folder exists And "" => Folder created successfully
                Reporter.ReportEvent micFail, "Folder couldn't be created " & FolderPath & " .Ending execution",""
				ExitTest
			End If
			
			'Create a folder with date-stamp
			FolderPath=TestDir & "\TestData\" &  DateFolder & "\" & TimeFolder   
			Status=FolderCreate(FolderPath) 'Create folder if doesn't exist
			If Status<>58 And Status <> "" Then ' 58=>Folder exists And "" => Folder created successfully
                Reporter.ReportEvent micFail, "Folder couldn't be created " & FolderPath & " .Ending execution",""
				ExitTest
			End If
			
			TDExcelPath=FolderPath&"\TestData.xls"'ReadWriteLineTextFile(TestDataPathFile,0,"")'FolderPath & "\TestData.xls" ' Either the file needs to be written in log.txt & read
			Set objFSO = CreateObject("Scripting.FileSystemObject")
			objFSO.CopyFile ExcelPath , TDExcelPath               ' Create a copy of testdata.xls file
			If ObjFSO.FileExists(TDExcelPath)<> True Then
				Reporter.ReportEvent micFail,"File copy failed",TDExcelPath & "," & err.description
				ExitTest
			End If
			'LogPath=TestDir & "\TestData\Log.txt"
			WriteStatus= ReadWriteLineTextFile(LogPath,1,TDExcelPath)        'write in log file
			If WriteStatus=0 Then
				Reporter.ReportEvent micFail, "Write to file failed " & LogPath & " .Ending execution",""
							ExitTest
			End If
	End If


	'ExcelPath="E:\QTP_Automation_v\Tests\AutomationFW\StartExecution\TestData\TestData.xls"
	'Start Reading Excel file
	Reporter.ReportEvent micDone, "Reading Data from " & TDExcelPath,""  
	Set ExcelObject = CreateObject("Excel.Application")
	ExcelObject.DisplayAlerts = 0 ' don't display any messages about documents needing to be converted ' from  old Excel file formats
	Set WBObject = ExcelObject.WorkBooks.Open (TDExcelPath) '' open the excel document as read-only  ' open (path, confirmconversions, readonly)
	Set colSheets = WBObject.Sheets          'For Each Sheet In colSheets Msgbox Sheet.Name   '      Next
	ExcelObject.Visible=True
   
	Set OSSheet = ExcelObject.ActiveWorkbook.Worksheets("OperationSequence")  '------Opening up the sheet named operationsequence
	OSColCount = OSSheet.UsedRange.Columns.Count ' how many columns are used in the current worksheet
	OSRowCount = OSSheet.UsedRange.Rows.Count ' how many rows are used in the current worksheet
	Set Cells = OSSheet.Cells
   
	Set IDSheet = ExcelObject.ActiveWorkbook.Worksheets("Input")  'Search for Operation & SeqNo in Input Sheet
	IDColCount = IDSheet.UsedRange.Columns.Count ' how many columns are used in the current worksheet
	IDRowCount = IDSheet.UsedRange.Rows.Count ' how many rows are used in the current worksheet
	Set InputCells = IDSheet.Cells  

	Set ODSheet = ExcelObject.ActiveWorkbook.Worksheets("Output")  'Output sheet
	ODColCount = ODSheet.UsedRange.Columns.Count   ' how many columns are used in the current worksheet
	ODRowCount = ODSheet.UsedRange.Rows.Count ' how many rows are used in the current worksheet
	Set OutputCells = ODSheet.Cells
                               
	For OSLoop = 2 to OSRowCount 
			StartTime = Timer 'This is to time the execution

			TCName=Cells(OSLoop,3).Value
			ExcnStatus=Cells(OSLoop,4).Value
			Execut=Cells(OSLoop,8).Value

							   
			If ResumeExecution="" OR ResumeExecution="1" And  ExcnStatus<>"Completed" Then ' if the operation is already completed, then no need to execute during resume execution
				If Trim(TCName)=TestCaseName OR Lcase(Trim(Execut))="yes"  Then   

					Operation = Cells(OSLoop,1).Value
					SeqNo=Cells(OSLoop,2).Value
'				 TCName=Cells(OSLoop,3).Value
'				 ExcnStatus=Cells(OSLoop,4).Value
'				 OnFail=Cells(OSLoop,5).Value	
'				 DependOn=Cells(OSLoop,6).Value
'				 Comments=Cells(OSLoop,7).Value

'				 Initialize/Clear old data
'					Call CloseChildWindows ' close any child window if open, due to previous operation
					Call ClearDataTable("Global","Field") '-------------Clearing if any previous data is present in the global sheet (Field and Value)
					Call ClearDataTable("Global","Value")
				    Erase Parameters
					Erase Values
					Erase oDescription
					iRowCount = 1'Datatable.getSheet("Sheet1").getRowCount
					IDRowNum=0
					IDColNum=3
					Flag=0
					n=0
					
					For IDRowNum = 2 to IDRowCount
							Operation2 = InputCells(IDRowNum,1).Value
							SeqNo2=InputCells(IDRowNum,2).Value
							If Operation2=Operation And SeqNo2=SeqNo Then
								Flag=1
								Exit For
							End If
					Next

					If Flag <> 1 Then
						Reporter.ReportEvent micFail,Operation & " # " & SeqNo & " not found in Input sheet.",ExcelPath
						ErrorCode=Operation & " # " & SeqNo & " not found in Input sheet."  & ExcelPath                'continue or exit?
						Cells(OSLoop,4).Value ="Data Missing in Input sheet"'ExcnStatus
					ElseIf Flag=1 Then                                                                                                                                                                                                                                                                                                                                                          
						Reporter.ReportEvent micPass,Operation & " # " & SeqNo & "  executing.",ExcelPath   'Found
						Cells(OSLoop,4).Value ="Started..."'ExcnStatus
		'---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                       OutputRowNo=InputCells(IDRowNum+2,3).Value
						OutputColNo=InputCells(IDRowNum+2,4).Value
								   
						Do Until LCase(InputCells(IDRowNum,IDColNum).Value) = "end"                'Read all the values
								ReDim Preserve Parameters(n)
								ReDim Preserve oDescription(n)
								ReDim Preserve Values(n)
									   
								If  InputCells(IDRowNum+2,IDColNum).Value <> ""Then             'this condition can;t  be Instr(1,InputCells(IDRowNum+1,IDColNum).Value,"<") and Instr(1,InputCells(IDRowNum+1,IDColNum).Value,"<") , as <> are used as data at times
									Temp= ProcessData(InputCells(IDRowNum+2,IDColNum).Value)          ''The read data is processed
									If Temp <> InputCells(IDRowNum+2,IDColNum).Value Then      ' if the data is processed
										If OutputRowNo<>"" And OutputColNo <> "" And Instr(1,InputCells(IDRowNum+2,IDColNum).Value,"output(")=0 Then
											OutputCells(OutputRowNo,OutputColNo).Value=Temp              'put the processed value in Output sheet
										End If
									End If
									Values(n)=Temp
								Else
									Values(n)=""
								End If

								Parameters(n) = InputCells(IDRowNum,IDColNum).Value 'Parameters
								oDescription(n) = InputCells(IDRowNum+1,IDColNum).Value 'Object String
							   
								DataTable.Value ("Field", "Global")=InputCells(IDRowNum,IDColNum).Value
								DataTable.Value ("Value", "Global")=Values(n)
								DataTable.Value ("Description", "Global")=oDescription(n)
								Datatable.getSheet("Global").setCurrentRow(iRowCount+1)
								iRowCount=iRowCount+1
								n=n+1
								IDColNum=IDColNum+1
						Loop
								   
						Select Case Operation
						  Case "Execute_Powershell"
									RunAction "Execute_Powershell", oneiteration
   						  
   						  Case "Launch_Application"
									'Initialize Action specific variables & Datatable
									'GlobalVar="Value"
									'DataTable.Value ("GlobalVar", "Global")="Value"  - To be passed as parameter to called action
									RunAction "Launch_Application", oneiteration', Parameters,Values                                                                               
													   
							Case "Test"
									RunAction "Test", oneiteration
									
							Case "Intermediate_Page"
									RunAction "Intermediate_Page", oneiteration									
									
							Case "Login"
									RunAction "Login", oneiteration
									
							Case "New_Order"
									RunAction "New_Order", oneiteration
									
							Case "Search_Order"
									RunAction "Search_Order", oneiteration
									
							Case Else      Reporter.ReportEvent micWarning,"No Action associated to operation: " & Operation,""
						End Select

						If  TaskResponse ="Completed" Then
							Cells(OSLoop,4).Value =TaskResponse'ExcnStatus
							Reporter.ReportEvent micPass,TCName & " Passed",""
						  ElseIf  TaskResponse ="Fail" Then
							Cells(OSLoop,4).Value =TaskResponse'ExcnStatus
							Reporter.ReportEvent micFail,TCName & " Failed",""
						ElseIf TaskResponse="" Then
							Cells(OSLoop,4).Value ="Blank"'ExcnStatus
							Reporter.ReportEvent micWarning,TCName & " Update the TaskResponse.Currently Blank!!",TaskResponse
						Else
							Cells(OSLoop,4).Value =TaskResponse'ExcnStatus
							Reporter.ReportEvent micWarning,TCName & " Issue!!",TaskResponse
						End If
					   TaskResponse=""
						EndTime = Timer
						TimeIt = EndTime - StartTime
						Cells(OSLoop,11).Value =TimeIt
					End If
				  End If  
			End If 
		WBObject.Save
'		ExcelObject.Save
	Next
 
	' We are done with the Excel object, release it from memory
'	ExcelObject.Save
	WBObject.Save
	htmlTestReportPath=FolderPath & "\TestReport.mht" ' can send excel itself
	WBObject.SaveAs htmlTestReportPath, FileFormat=xlWebArchive '44 for html
	ExcelObject.Quit
	Set OSSheet = Nothing
	Set ExcelObject = Nothing
	DataTable.Value ("ResumeExecution", "Global")="Completed"  
'   StartExecution=1
	Operation=""
	Reporter.ReportEvent micDone,"Execution End",""
	'Close Browsers
	SystemUtil.CloseProcessByName "IEXPLORE.EXE"
 	SystemUtil.CloseProcessByName "Firefox.EXE" 
	
	Text1 ="Please find the attached automation execution report" 
    
 
Text2= "The information contained in this message " _
    & "constitutes privileged and confidential information " _
    & "and is intended only for the use of and review by " _
    & "the recipient designated above."
 
'Multiline body
Body= Text1 & vbCrLf & Text2
 
'path of the file sample.txt  to be attached
'path=htmlTestReportPath
 
'Usage of Function  "Send_Testresults"
'Multiple email Id can be used  with  semicolon as Seperator
Send_Testresults"vikassjoshi@gmail.com","vikas.joshi@marlabs.com",,"Mail from MUST",Body,htmlTestReportPath '"vikas.joshi@marlabs.com;vikassjoshi@gmail.com"
	'Description :Sytem lockout
'	If isobject(oPreventSystemLock)=true  Then
'		oPreventSystemLock.PreventLockout = False                                                                                                                     ' 'Allow system to get locked
'		Set oPreventSystemLock = Nothing
'	End If
	ExitTest 
End Function


 
'Function  to send email
Function  Send_Testresults(sTo,sCC,sBCC,sSubject,sBody,sAttachment)
 
'Open outlook if Outlook is not open
   'systemUtil.Run "OUTLOOK.EXE"
   wait (10)
 'Create Outlook Object
Set oMail = CreateObject("Outlook.Application")
' oMail. how to displayalerts = 0 ? 
set  Sendmail=oMail.CreateItem(0)
      Sendmail.To=sTo
      Sendmail.CC=sCC
      Sendmail.BCC=sBCC
      Sendmail.Subject=sSubject
      Sendmail.Body=sBody
          If (sAttachment <> "") Then
         Sendmail.Attachments.Add(sAttachment)
         End If 
 
       Sendmail.Send
 
oMail.quit
 
set  Sendmail=Nothing
set oMail=Nothing
 
End Function


Function ClickCheckBox(ObjectNameString,Value)
	
	Dim webTab,oWebEdit,objList,objIndex
	Set webPage=Browser("title:=IDEXX.*").page("title:=IDEXX.*")
	Set oWebEdit=Description.Create
	oWebEdit("micclass").value="WebCheckBox"	
	set objList=webPage.ChildObjects(oWebEdit) 	
	For objIndex=0 to objlist.count-1
		If objlist(objIndex).GetROProperty("name")=ObjectNameString Then	'Searches objects by name
			objlist(objIndex).Set Value
			Exit For
		End If		 
	Next
End Function
	

Function GetText(ObjectNameString)
	On Error Resume Next
	Dim webTab,oWebEdit,objList,objIndex
	Set webPage=Browser("title:=IDEXX.*").page("title:=IDEXX.*")
	Set oWebEdit=Description.Create
	oWebEdit("micclass").value="WebElement"	
	set objList=webPage.ChildObjects(oWebEdit) 	
	For objIndex=0 to objlist.count-1
		If objlist(objIndex).GetROProperty("class")=ObjectNameString Then	'Searches objects by class
			GetText=objlist(objIndex).GetROProperty("innertext")
'			Exit For
		End If		 
	Next
End Function
	
Function SetText(ObjectNameString,Value,ObjectType)
	
	Dim webTab,oWebEdit,objList,objIndex
	Set webPage=Browser("title:=IDEXX.*").page("title:=IDEXX.*")
	Set oWebEdit=Description.Create
	If ObjectType="" Then
		oWebEdit("micclass").value="WebEdit"	
	Else
		oWebEdit("micclass").value=ObjectType
	End If
	
	set objList=webPage.ChildObjects(oWebEdit) 
	
	For objIndex=0 to objlist.count-1
		If objlist(objIndex).GetROProperty("name")=ObjectNameString Then	'Searches objects by name
			objlist(objIndex).Set Value
			Exit For
		End If		 
	Next
End Function

Function ClickLink(ObjectNameString)
	
	Dim webTab,oWebEdit,objList,objIndex	
	Set webPage=Browser("title:=IDEXX.*").page("title:=IDEXX.*") 'Parent Object
	Set oWebLink=Description.Create
	oWebLink("micclass").value="Link"
	set objList=webPage.ChildObjects(oWebLink)	
	For objIndex=0 to objlist.count-1
		If objlist(objIndex).GetROProperty("name")=ObjectNameString Then	'Searches objects by name
			objlist(objIndex).Click
			Exit For
		End If		 
	Next
End Function


Function ClickButton(ObjectNameString)
	
	Dim webTab,oWebEdit,objList,objIndex
	Set webPage=Browser("title:=IDEXX.*").page("title:=IDEXX.*")'Parent Object
	Set oWebButton=Description.Create
	oWebButton("micclass").value="WebButton"
	set objList=webPage.ChildObjects(oWebButton) 
	
	For objIndex=0 to objlist.count-1
		If objlist(objIndex).GetROProperty("name")=ObjectNameString Then	'Searches objects by name
			objlist(objIndex).Click
			Exit For
		End If		 
	Next
End Function

 Class FWReport
    Public Function LogReport (Status,Message,Describe)
        Reporter.ReportEvent Status,Message,Describe
	 	Set LogSheet = ExcelObject.ActiveWorkbook.Worksheets("Log")  '------Opening up the sheet named operationsequence
		LogColCount = LogSheet.UsedRange.Columns.Count ' how many columns are used in the current worksheet
		LogRowCount = LogSheet.UsedRange.Rows.Count ' how many rows are used in the current worksheet
		Set LogCells = LogSheet.Cells
		If Status="0" Then
			Status="Pass"
		ElseIf Status="1" Then
			Status="Fail"
		ElseIf Status="2" Then
			Status="Done"
		ElseIf Status="3" Then
			Status="Warning"
		End If
		LogCells(LogRowCount+1,1).Value=Status
		LogCells(LogRowCount+1,2).Value=Message
		LogCells(LogRowCount+1,3).Value=Describe
    End Function 
End Class
 Set Report = New FWReport
 
'public function Report (Status,Message,Describe)
'    set Report = new LogReport
'end function
' Function LogReport (Status,Message,Describe)
' 	Reporter.ReportEvent Status,Message,Describe
' 	Set LogSheet = ExcelObject.ActiveWorkbook.Worksheets("Log")  '------Opening up the sheet named operationsequence
'	LogColCount = LogSheet.UsedRange.Columns.Count ' how many columns are used in the current worksheet
'	LogRowCount = LogSheet.UsedRange.Rows.Count ' how many rows are used in the current worksheet
'	Set LogCells = LogSheet.Cells
'	LogCells(LogRowCount+1,1).Value=Status
'	LogCells(LogRowCount+1,2).Value=Message
'	LogCells(LogRowCount+1,3).Value=Describe
' End Function
 
Function ProcessData(DataValue)
 
Dim ExtractCoordinates,coordinates,objExcel1,objWkBook1,colSheets1,currentWorkSheet4,Cells4,CellContents,Order,RowValue,ColValue,CellValues,ReplaceWith,InstrVal,InstrVal1,ExtractedString,FinalString
If Instr(1,DataValue,"<random>") Then
   ReplaceWith=GenerateDateTimeStamp' & "_" & RandomString(5)
   DataValue= Replace(DataValue,"<random>",ReplaceWith)
End If
If Instr(1,DataValue,"output(") Then'text="output(3,2,1)"
    'ExtractCoordinates=Mid(DataValue,Instr(1,DataValue,"output(")+8,Instr(1,DataValue,")"))
    InstrVal=Instr(1,DataValue,"output(")+7
    InstrVal1=Instr(1,DataValue,"output(")
    ExtractCoordinates=Mid(DataValue,InstrVal,instr(1,DataValue,")")-InstrVal)
    ExtractedString=Mid(DataValue,InstrVal1,instr(1,DataValue,")")-InstrVal1+1)
    coordinates=Split(ExtractCoordinates,",")
    RowValue=CInt(coordinates(0))
    ColValue=CInt(coordinates(1))
    Order=coordinates(2)
   
    Set objExcel1 = CreateObject("Excel.Application")
    Set objWkBook1 = objExcel1.WorkBooks.Open (TDexcelPath)
    Set colSheets1 = objWkBook1.Sheets 
     Set currentWorkSheet4 = objExcel1.ActiveWorkbook.Worksheets("Output") 'Output sheet
    Set Cells4 = currentWorkSheet4.Cells
    'pull out data corresponding to RowValue,ColValue from Output sheet
    CellContents=Cells4(RowValue,ColValue).Value
    objExcel1.Quit
    REM We are done with the Excel object, release it from memory
    Set objExcel1 = Nothing
    CellValues=Split(CellContents,",")
	FinalString=Replace(DataValue,ExtractedString,CellContents)
    'then select the value
    If Order>1 Then
        If Order>Ubound(CellValues) Then
                        Reporter.ReportEvent micFail,DataValue & " points to invalid value","There are only " & Ubound(CellValues) & " values in " & RowValue & "," & ColValue & " cell in Output sheet"
        End If
        x=0
        For x=0 to Ubound(CellValues)
                        If x=order-1 Then
                                        DataValue=CellValues(x)
                        End If
        Next
    ElseIf Order=1 And Ubound(CellValues)>1 Then
        Reporter.ReportEvent micFail,DataValue & " points to invalid value","There are only " & Ubound(CellValues) & " values in " & RowValue & "," & ColValue & " cell in Output sheet"
    Else ' only one value
   
        ProcessData=FinalString
                    'ProcessData=CellContents
                   
    End If
Else        'if no data is to be processed just return the string as it is
        ProcessData=DataValue
End If
 
End Function


'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:NorthShoreLibrary.qfl/MLBFunctionLib.vbs
'Action Name: Execute_Powershell
'Function/Sub Name:ExecutePowerShellScript
'Description:To execute PS script
'Argument List: 
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:CheckFile
'Called Functions:
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:Marlabs Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----

Function ExecutePowerShellScript(AppPath,AppFileName,OutPath,OutFileName,SearchString,WaitTime)

BG_STATUS = "New"
BG_PROJECT= "Testing"
BG_SUBJECT = "Automation Testing"
BG_SUMMARY = "Automation Testing"
'BG_DESCRIPTION = "QTP create the Defect Log for Automation Testing"
BG_ASSIGNEDTO="svanapalli"
BG_SEVERITY = "Severity 4"
BG_PRIORITY = "Low"
BG_DETECTED_BY = "VIKAS" 
BG_ARCHITECTURE = "Physical" 'ARCHITECTURE
BG_SYSTEM = "1. Citrix" 'SYSTEM
BG_PROJECTNUMBER = "13" 'PROJECT NUMBER
BG_CHANGEORDER = "14" 'CHANGE ORDER

qcServer="https://northshoremc.saas.hp.com/qcbin"
qcUser="svanapalli"
qcPassword="NSLIJQC"
qcDomain="INFRASTRUCTURE_TESTING"
qcProject="INFRASTRUCTURE_PLAYGROUND"

'Ensure clear start
'Check for null values
'Check for invalid values

Status=CheckFile(AppPath & "\" & AppFileName)
If Status=0 Then
	Reporter.ReportEvent micFail, "App File : " & AppPath & "\" & AppFileName & " doesn't exist, ending execution",""
	BG_DESCRIPTION = "App File : " & AppPath & "\" & AppFileName & " doesn't exist, ending execution"
	Call RaiseQCDefect (QCserver, QCdomain, QCproject, QCuser, QCpassword,BG_STATUS,BG_PROJECT,BG_SUBJECT,BG_SUMMARY,BG_DESCRIPTION,BG_ASSIGNEDTO,BG_SEVERITY,BG_PRIORITY,BG_DETECTED_BY,BG_ARCHITECTURE,BG_SYSTEM,BG_PROJECTNUMBER,BG_CHANGEORDER)
'	TaskResponse="Fail"
	ExitTest
End If
SystemUtil.Run AppPath & "\" & AppFileName,"",AppPath,"open"
Wait WaitTime 'can be incremental
Status=CheckFile(OutPath & "\" & OutFileName)
If Status=0 Then
	Reporter.ReportEvent micFail, "Out File : " & OutPath & "\" & OutFileName & " doesn't exist, ending execution",""
	BG_DESCRIPTION= "Out File : " & OutPath & "\" & OutFileName & " doesn't exist, ending execution"
	Call RaiseQCDefect (QCserver, QCdomain, QCproject, QCuser, QCpassword,BG_STATUS,BG_PROJECT,BG_SUBJECT,BG_SUMMARY,BG_DESCRIPTION,BG_ASSIGNEDTO,BG_SEVERITY,BG_PRIORITY,BG_DETECTED_BY,BG_ARCHITECTURE,BG_SYSTEM,BG_PROJECTNUMBER,BG_CHANGEORDER)
'	TaskResponse="Fail"
	ExitTest
End If


Const ForReading = 1

Set objRegEx = CreateObject("VBScript.RegExp")
objRegEx.Pattern = SearchString'"^[1-9]...GRP"

Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.OpenTextFile(OutPath & "\" & OutFileName, ForReading)

Do Until objFile.AtEndOfStream
    strSearchString = objFile.ReadLine
    Set colMatches = objRegEx.Execute(strSearchString)  
    If colMatches.Count > 0 Then
        For Each strMatch in colMatches   
'            Wscript.Echo strSearchString 
            StringFound=1
        Next
    End If
Loop

objFile.Close

If StringFound=1 Then
	Reporter.ReportEvent micPass,"String: " & SearchString & " found ", "File: " & OutPath & "\" & OutFileName
	TaskResponse="Completed"
Else
	Reporter.ReportEvent micFail,"String: " & SearchString & " not found ", "File: " & OutPath & "\" & OutFileName
	BG_DESCRIPTION= "String: " & SearchString & " not found "& ",File: " & OutPath & "\" & OutFileName
	Call RaiseQCDefect (QCserver, QCdomain, QCproject, QCuser, QCpassword,BG_STATUS,BG_PROJECT,BG_SUBJECT,BG_SUMMARY,BG_DESCRIPTION,BG_ASSIGNEDTO,BG_SEVERITY,BG_PRIORITY,BG_DETECTED_BY,BG_ARCHITECTURE,BG_SYSTEM,BG_PROJECTNUMBER,BG_CHANGEORDER)
	TaskResponse="Fail"
End If
End Function

''' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
''Test Suite Name: MLB Automation Suite
''Test Script Name:
''Function/Sub Name:CheckFile
''Description:Check the specified file exist or not
''Argument List: FilePath
''Return Value:
''Author: Vikas Joshi
''Creation Date:        
''Calling Functions:
''Called Functions:MinimizeQTPWindow,Start_Execution
''Modified By:
''Modification Date:
''Modification Reason:
''Application Under Test Details:
''Comments:
''Copyrights:VJ, Inc.
''' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
''Returns 1 if file exists, 0 if file doesn't exist
'Function CheckFile(FilePath)
'   Set objFSO = CreateObject("Scripting.FileSystemObject")
'		If ObjFSO.FileExists(FilePath)<> True Then	'If file not found
'			Reporter.ReportEvent micFail,"File not found.",excelPath & "," & err.description
'			CheckFile=0
'			Exit Function
'		End If
'	CheckFile=1
'End Function




'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:NorthShoreLibrary.qfl/MLBFunctionLib.vbs
'Action Name: Execute_Powershell
'Function/Sub Name:ExecutePowerShellScript
'Description:To execute PS script
'Argument List: QCserver, QCdomain, QCproject, QCuser, QCpassword,BG_STATUS,BG_PROJECT,BG_SUBJECT,BG_SUMMARY,BG_DESCRIPTION,BG_ASSIGNEDTO,BG_SEVERITY,BG_PRIORITY,BG_DETECTED_BY,BG_ARCHITECTURE,BG_SYSTEM,BG_PROJECTNUMBER,BG_CHANGEORDER
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:CheckFile
'Called Functions:
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:Marlabs Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----


'Call RaiseQCDefect (QCserver, QCdomain, QCproject, QCuser, QCpassword,BG_STATUS,BG_PROJECT,BG_SUBJECT,BG_SUMMARY,BG_DESCRIPTION,BG_ASSIGNEDTO,BG_SEVERITY,BG_PRIORITY,BG_DETECTED_BY,BG_ARCHITECTURE,BG_SYSTEM,BG_PROJECTNUMBER,BG_CHANGEORDER)
Function RaiseQCDefect (QCserver, QCdomain, QCproject, QCuser, QCpassword,BG_STATUS,BG_PROJECT,BG_SUBJECT,BG_SUMMARY,BG_DESCRIPTION,BG_ASSIGNEDTO,BG_SEVERITY,BG_PRIORITY,BG_DETECTED_BY,BG_ARCHITECTURE,BG_SYSTEM,BG_PROJECTNUMBER,BG_CHANGEORDER)
	'connect to QC
	Set qtApp = CreateObject("QuickTest.Application") 'Create QTP Object

'	qtApp.TDConnection.Disconnect 'Disconnect  TDConnection
	qtApp.TDConnection.Connect QCserver, QCdomain, QCproject, QCuser, QCpassword, False 'Connect  TDConnection
	If qtApp.TDConnection.IsConnected Then

		MsgBox("Connected to " + chr (13) + "Server " + qtApp.TDConnection.ServerName + chr (13) +"Project " + qtApp.TDConnection.ProjectName )
		Set tdc = qtApp.TDConnection.TDOTA 'Set TDC Connection
		set BugFactory = tdc.BugFactory
		'Add a new defect
		
		Set Bug = BugFactory.AddItem(Nothing)
		Bug.field ("BG_STATUS") 	=	BG_STATUS 	
		Bug.field ("BG_PROJECT") 	=	BG_PROJECT	
		Bug.field ("BG_SUBJECT") 	=	BG_SUBJECT 	
		Bug.field ("BG_SUMMARY")	=	BG_SUMMARY 	
		Bug.field ("BG_DESCRIPTION")=	BG_DESCRIPTION 	
		Bug.AssignedTo				=	BG_ASSIGNEDTO	
		Bug.field ("BG_SEVERITY") 	=	BG_SEVERITY 	
		Bug.field ("BG_PRIORITY") 	=	BG_PRIORITY 	
		Bug.field ("BG_DETECTED_BY")=	BG_DETECTED_BY 	
		Bug.field ("BG_USER_08") 	=	BG_ARCHITECTURE 	
		Bug.field ("BG_USER_01")	=	BG_SYSTEM 	
		Bug.field ("BG_USER_13")	=	BG_PROJECTNUMBER 	
		Bug.field ("BG_USER_14")	=	BG_CHANGEORDER 	
		Bug.Post
		qtApp.TDConnection.Disconnect
		
	Else
		Reporter.ReportEvent micFail,"Connection to Quality Center failed","QC Server=" & QCServer	
	End If
	
	'Other optional fields
	'Bug.field ("BG_STATUS") = "New"
		'Bug.field ("BG_PROJECT") = "Testing"
		'Bug.field ("BG_SUBJECT") = "Automation Testing"
		'Bug.field ("BG_SUMMARY") = "Automation Testing"
		'Bug.field ("BG_DESCRIPTION") = "QTP create the Defect Log for Automation Testing"
		'Bug.AssignedTo="svanapalli"
		'Bug.field ("BG_SEVERITY") = "Severity 4"
		'Bug.field ("BG_PRIORITY") = "Low"
		'Bug.field ("BG_DETECTED_BY") = "VIKAS" 
		'Bug.field ("BG_USER_08") = "Physical" 'ARCHITECTURE
		'Bug.field ("BG_USER_01") = "1. Citrix" 'SYSTEM
		'Bug.field ("BG_USER_13") = "13" 'PROJECT NUMBER
		'Bug.field ("BG_USER_14") = "14" 'CHANGE ORDER
		
		''DETECTED ON DATE & REPRODUCIBLE : FIELDS NOT FOUND
		'Bug.field ("BG_RESPONSIBLE") = "RESPONSIBLE"
		'Bug.field ("BG_DEV_COMMENTS") = "COMMENTS"
		'Bug.field ("BG_USER_02") = "3. Test" ' DETECTED IN PHASE
		'Bug.field ("BG_USER_03") = "Application" 'FUNCTIONAL UNIT
		'Bug.field ("BG_USER_04") = "4/10/2013" 'TARGET FIX DATE
		'Bug.field ("BG_USER_05") = "1. Code" 'ROOT CAUSE'
		'Bug.field ("BG_USER_06") = "6/10/2013" 'ACTUAL FIX DATE
		'Bug.field ("BG_USER_07") = "Code - Inadequate Error Detection and Recovery" 'ROOT CAUSE DETAIL
		'Bug.field ("BG_USER_09") = "1. Defect" 'DEFECT TYPE
		'Bug.field ("BG_USER_10") = "31" 'VENDOR DEFECT ID
		'Bug.field ("BG_USER_11") = "3M" 'RESPONSIBLE VENDOR'
		'Bug.field ("BG_USER_12") = "12/10/2013" 'TARGET RETEST DATE
		'Bug.field ("BG_USER_18") = "3. Low" ' DEFECT COMPLEXITY
		'Bug.field ("BG_USER_20") = "112233" 'DUPLICATE OF
		'Bug.field ("BG_USER_21") = "1.Duplicate" 'CANCELLED REASON
		'Bug.field ("BG_USER_22") = "22" 'DETECTED IN BUILD
		'Bug.field ("BG_USER_23") = "21" 'CLOSED IN BUILD
		'Bug.field ("BG_USER_25") = "RESOLUTION" 'RESOLUTION	
		'BG_STATUS = "New"
		'BG_PROJECT= "Testing"
		'BG_SUBJECT = "Automation Testing"
		'BG_SUMMARY = "Automation Testing"
		'BG_DESCRIPTION = "QTP create the Defect Log for Automation Testing"
		'BG_ASSIGNEDTO="svanapalli"
		'BG_SEVERITY = "Severity 4"
		'BG_PRIORITY = "Low"
		'BG_DETECTED_BY = "VIKAS" 
		'BG_ARCHITECTURE = "Physical" 'ARCHITECTURE
		'BG_SYSTEM = "1. Citrix" 'SYSTEM
		'BG_PROJECTNUMBER = "13" 'PROJECT NUMBER
		'BG_CHANGEORDER = "14" 'CHANGE ORDER
		'
		'qcServer="https://northshoremc.saas.hp.com/qcbin"
		'qcUser="svanapalli"
		'qcPassword="NSLIJQC"
		'qcDomain="INFRASTRUCTURE_TESTING"
		'qcProject="INFRASTRUCTURE_PLAYGROUND"	
End Function






'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:ClickButton
'Description:To Click the specified Button
'Argument List: ObjectString
'Return Value:Array3
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----

Function ClickButton(ObjectString) 
   Status=WaitForObject(ObjectString)
   If Status=1 Then
	   ObjectString.Click
   Elseif Status=0 Then
	   Reporter.ReportEvent micFail,"Button was not clicked since button is either not enabled or not visible",""
	   Exit Function
   End If
End Function
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:WriteToOutputSheet
'Description:Write the values to outputsheet of the excel
'Argument List: ValueToWrite
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'This function writes the value to Output sheet in the testdata.xls, provided, row & column values are specified in the test data Input sheet
Function WriteToOutputSheet(ValueToWrite)
	If IsEmpty(OutputRowNo) or IsEmpty(OutputColNo) Then
		Reporter.ReportEvent micFail,"Output sheet: Row or Column value not specified",OutputRowNo & "," & OutputColNo
		WriteToOutputSheet=0
		Exit Function
	End If
	If IsEmpty(ValueToWrite) Then
		Reporter.ReportEvent micFail,"Output sheet: value not specified",OutputRowNo & "," & OutputColNo
		WriteToOutputSheet=0
		Exit Function
	End If
   OutputRowNo= CInt(OutputRowNo)
   OutputColNo=CInt(OutputColNo)
   OutputCells(OutputRowNo,OutputColNo).Value=ValueToWrite  
   WriteToOutputSheet=0
End Function
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:CheckFile
'Description:Check the specified file exist or not
'Argument List: FilePath
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'Returns 1 if file exists, 0 if file doesn't exist
Function CheckFile(FilePath)
   Set objFSO = CreateObject("Scripting.FileSystemObject")
		If ObjFSO.FileExists(FilePath)<> True Then	'If file not found
			Reporter.ReportEvent micFail,"File not found.",excelPath & "," & err.description
			CheckFile=0
			Exit Function
		End If
	CheckFile=1
End Function
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:FolderCreate
'Description:Check if a folder exists, if not creates one
'Argument List: FolderPath
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'Check if a folder exists, if not creates one
Function FolderCreate (strPath)
   Set objFSO = CreateObject("Scripting.FileSystemObject")
	On Error Resume Next ' Incase folder already exist
	' Create a Folder, using strPath
	Set objFolder = objFSO.CreateFolder(strPath)
	If err.Number = 58 then      'VB Script Run Time Error 58 -File Already exists
	   Reporter.ReportEvent micDone, "Folder  already exist  at" & strPath,""
	   FolderCreate=58
	ElseIf err.number <>0 then 
		reporter.ReportEvent micFail,err.number	,err.Description
		FolderCreate=err.Number
	End If
End Function

'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:ReadDataTable
'Description:Compare and validate the Grid Values in CM and Database Values
'Argument List: DataTableName
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'This function is core to the framework as it reads the DataTable for input data pulled in from TestData file
Function ReadDataTable(DataTableName)
	Set oTable = DataTable.GetSheet(DataTableName) 
	iRowCount = Datatable.getSheet(DataTableName).getRowCount
	For i = 1 to iRowCount+1
		ReDim Preserve Parameters(i)
		ReDim Preserve oDescription(i)
		ReDim Preserve Values(i)
		Parameters(i)=DataTable.Value ("Field", DataTableName)	'Get Parameter Name
		 oDescription(i)=DataTable.Value ("Description", DataTableName)	'Get Description 
		Values(i)=DataTable.Value ("Value", DataTableName)	'Get Parameter Value
		Datatable.getSheet(DataTableName).setCurrentRow(i)
	Next
End Function

'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:WriteToExcel
'Description:Writes a value to specified excel file
'Argument List: ExcelPath,SheetName,RowNo,ColNo,ValueToStore
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'Writes a value to specified excel file
Function WriteToExcel(ExcelPath,SheetName,RowNo,ColNo,ValueToStore)
  
   		Set objExcel = CreateObject("Excel.Application")
		objExcel.DisplayAlerts = 0 REM don't display any messages about documents needing to be converted REM from  old Excel file formats

		Set objWkBook = objExcel.WorkBooks.Open (excelPath) REM open the excel document as read-only  REM open (path, confirmconversions, readonly)
		Set colSheets = objWkBook.Sheets  	 'For Each Sheet In colSheets      '		 'Msgbox Sheet.Name   '	Next
		 objExcel.Visible=True

		 If SheetName="" Then
			 Set currentWorkSheet = objExcel.ActiveWorkbook.Worksheets(1)
		Else
			Set currentWorkSheet = objExcel.ActiveWorkbook.Worksheets(SheetName)
		End If
'		usedColumnsCount = currentWorkSheet.UsedRange.Columns.Count REM how many columns are used in the current worksheet
'		usedRowsCount = currentWorkSheet.UsedRange.Rows.Count REM how many rows are used in the current worksheet
		Set Cells = currentWorksheet.Cells
		Cells(RowNo,ColNo).Value =ValueToStore
		objExcel.Save
		objExcel.Quit
		Set currentWorkSheet = Nothing
		Set objExcel = Nothing
		
End Function
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:QueryDB
'Description:returns multi-dimensional array containing results, 1st row is field names, 2nd row onwards are field values
'Argument List: DBServer,DBName,Query
'Return Value:Array
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----

'Function Name:QueryDB(DBServer,DBName,Query) '
'Description: returns multi-dimensional array containing results, 1st row is field names, 2nd row onwards are field values
'Sample Call:
'DBName="Racer00222"
'DBServer="AIMDBQA03"
'Query="SELECT TOP 10 claim_no ,amt_allowed,amt_billed,amt_copay FROM dbo.CLAIM_STATUS with (nolock) INNER JOIN dbo.CLAIM with (nolock)ON (CLAIM.PROJECT_ID = CLAIM_STATUS.PROJECT_ID AND CLAIM_STATUS.CLAIM_ID = CLAIM.CLAIM_ID AND CLAIM_STATUS.CURRENT_STATUS = 1)     INNER JOIN dbo.PROJECT with (nolock)ON CLAIM.PROJECT_ID = PROJECT.PROJECT_ID    WHERE CLAIM.PROJECT_ID in (212,222,684) and CLAIM_STATUS.CURRENT_STATUS = 1 AND CLAIM_STATUS.STATUS_CODE in (8,9) and PROJECT.AppActive = 1 order by claim_no"
'Results= QueryDB(DBServer,DBName,Query)
'If Results<>0 Then
'	For i = 0 to Ubound(Results,1)
'		For j=0 to Ubound(Results,2)
'			Reporter.ReportEvent micDone,Results(i,j),""
'		Next
'	Next
'End If

Function QueryDB(DBServer,DBName,Query) ' returns multi-dimensional array containing results, 1st row is field names, 2nd row onwards are field values

	Set objDB = CreateObject("ADODB.Connection")
	strDSN = "DRIVER=SQL Server; DATABASE=" & DBName & ";APP=QuickTest Professional;SERVER=" & DBServer &";Description=Testconnection"
	On Error Resume Next
    objDB.Open(strDSN)
	If err.number<>0 Then
		Reporter.ReportEvent micFail,"DB connectivity issue",err.description & ",DBServer=" & DBServer & ",DBName=" & DBName
		QueryDB=0
		Exit Function
	End If
	Set rs=createobject("adodb.recordset")
	rs.open Query,objDB
	
	' get the no of records
	Dim loopCounter:loopCounter=0
	While not rs.EOF
		 loopCounter=loopCounter+1
		 rs.MoveNext
	Wend
	
	'exit if the query has not returned any result
	If loopCounter =0 Then
		  Reporter.ReportEvent micWarning,"Empty Result Set","Query is: " & StringQ
		  Func_GetQueryResult=False
		  Exit Function
	End If
	
	'move the recordset object to first row again
	rs.MoveFirst
	
	'define the dimensions of the array
	ReDim resArr(loopCounter,rs.fields.count-1)
	
	'Loop and store the query result into the array
	'first row of the array will contain the field names
	'from second row we will have the field values
	Dim counter           
	Do until rs.EOF               
		 counter=counter+1
		 Dim var
		 For var=0 to rs.fields.count-1       
		   If counter=1 Then                                                                                             
				   resArr(counter-1,var) =rs.fields(var).name
				   resArr(counter,var) =rs.fields(var).value                                                                                                                                        
		   else
				  resArr(counter,var) =rs.fields(var).value           '"'"&                                                                                                                                                                    
		   end If
		Next
		rs.MoveNext  
	Loop  

	QueryDB=resArr ' return the result array
End Function

'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:ClearDataTable
'Description:Cleares the values in datatable
'Argument List: SheetName,FieldName
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
Function ClearDataTable(SheetName,FieldName)
     iRowCount = Datatable.getSheet(SheetName).getRowCount
	For i = 1 to iRowCount
		DataTable.Value (FieldName, SheetName)=""
		DataTable.Value (FieldName,SheetName)=""
		Datatable.getSheet(SheetName).setCurrentRow(i+1)
	Next

End Function


'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:ReadWriteLineTextFile
'Description:if Read0Write1=0 returns the 1st line in the file , if Read0Write1=1 writes 1 line Content into file; Assumption: The file already exists.
'Argument List: FilePath,Read0Write1,Content
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----

Function ReadWriteLineTextFile(FilePath,Read0Write1,Content) 'if Read0Write1=0 returns the 1st line in the file , if Read0Write1=1 writes 1 line Content into file; Assumption: The file already exists.
	Err.Clear
   Const ForReading = 1, ForWriting = 2
   Dim fso, MyFile
   Set fso = CreateObject("Scripting.FileSystemObject")
   
   If Read0Write1=1 and Content <> "" Then
	   Set MyFile = fso.OpenTextFile(FilePath, ForWriting, True)
	   MyFile.WriteLine Content
	   MyFile.Close
	   ReadWriteLineTextFile=1
   ElseIf Read0Write1=0 Then
	   Set MyFile = fso.OpenTextFile(FilePath, ForReading)
	   ResultFilePath = MyFile.ReadLine    
	   MyFile.Close
	   ReadWriteLineTextFile=ResultFilePath
	ElseIf  Read0Write1=1 and Content = "" Then
		Reporter.ReportEvent micWarning,"No contents passed",FilePath
		ReadWriteLineTextFile=1
      End If
	  If Err>0 Then
		  Reporter.ReportEvent micWarning,Err.Description,"Error during file operation" & ",File Path : "  & FilePath
		  ReadWriteLineTextFile=0
'	  Else
'		  Reporter.ReportEvent micDone,"File Operation done","File Path : "  & FilePath
'		  ReadWriteLineTextFile=1
	  End If
End Function
' ' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:RandomString
'Description:Generates a random alphanumeric string of given length, passed as parameter
'Argument List: strLen    
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----

'Generates a random alphanumeric string of given length, passed as parameter
Function RandomString( ByVal strLen )    
    Dim str    
	Const LETTERS = "abcdefghijklmnopqrstuvwxyz0123456789"     
	For i = 1 to strLen        
		str = str & Mid( LETTERS, RandomNumber( 1, Len( LETTERS ) ), 1 )    
    Next    
	RandomString = str
	'msgbox RandomString
End Function

 ' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:GenerateDateTimeStamp
'Description:Function GenerateDateTimeStamp, creates a  date - time stamp without delimiters based on current system date-time& format
'Argument List: 
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'Function GenerateDateTimeStamp, creates a  date - time stamp without delimiters based on current system date-time& format
Function GenerateDateTimeStamp

	array3=split(time,":")
	array4=split(date,"/")
	
	For i = 0 to ubound(array4)
		array1=array1 & array4(i)
	Next
	
	For i = 0 to ubound(array3)
		array1=array1 & array3(i)
	Next
	
	GenerateDateTimeStamp= array1

End Function
 ' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:GenerateDateStamp
'Description:Function GenerateDateStamp, creates a  date  stamp without delimiters based on current system date-time& format
'Argument List: 
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'Function GenerateDateStamp, creates a  date  stamp without delimiters based on current system date-time& format
Function GenerateDateStamp


	array4=split(date,"/")
	
	For i = 0 to ubound(array4)
		array1=array1 & array4(i)
	Next

	GenerateDateStamp= array1

End Function
 ' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:GenerateTimeStamp
'Description:Function GenerateTimeStamp, creates a   - time stamp without delimiters based on current system date-time& format
'Argument List: 
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'Function GenerateTimeStamp, creates a   - time stamp without delimiters based on current system date-time& format
Function GenerateTimeStamp

	array3=split(time,":")

	For i = 0 to ubound(array3)
		array1=array1 & array3(i)
	Next
	
	GenerateTimeStamp= array1

End Function
 ' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:ScreenShot
'Description:Captures screenshot of given object, if parameter is not passed, takes screenshot of desktop, stores in result directory with date & time stamp
'Argument List: ObjectString
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'Captures screenshot of given object, if parameter is not passed, takes screenshot of desktop, stores in result directory with date & time stamp
Sub ScreenShot(ObjectString)
   If IsObject(ObjectString) or ObjectString=""  Then
	   ObjectString=Desktop
   End If
    If WaitforObject(ObjectString)=0  Then
	   Exit Sub
   End If
	ObjectString.CaptureBitmap GenerateDateTimeStamp() & RandomString(2) & ".bmp" , 0
	Reporter.ReportEvent micDone, "Screen Shot captured",Environment.Value("ResultDir") & "\" & temp '&".bmp"
End Sub
 ' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:MinimizeQTPWindow
'Description:Minimizes QTP window during execution
'Argument List: 
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
'' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'Minimizes QTP window during execution
Sub MinimizeQTPWindow ()
    Set     qtApp = getObject("","QuickTest.Application")
    qtApp.WindowState = "Minimized"
    Set qtApp = Nothing
End Sub
 
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
'Test Suite Name: MLB Automation Suite
'Test Script Name:
'Function/Sub Name:CompareValues
'Description:his function compare the 2 values passed, and prints log message & returns a value
'Argument List: ExpectedValue,ActualValue
'Return Value:
'Author: Vikas Joshi
'Creation Date:        
'Calling Functions:
'Called Functions:MinimizeQTPWindow,Start_Execution
'Modified By:
'Modification Date:
'Modification Reason:
'Application Under Test Details:
'Comments:
'Copyrights:VJ, Inc.
' --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----
'This function compare the 2 values passed, and prints log message & returns a value
Function CompareValues(ExpectedValue,ActualValue)
   If ExpectedValue=ActualValue Then
	   Reporter.ReportEvent micPass,"Value as expected","Expected Value=" & ExpectedValue & " , Actual Value=" & ActualValue
	   CompareValues=1
	Else
		Reporter.ReportEvent micFail,"Value not as expected","Expected Value=" & ExpectedValue & " , Actual Value=" & ActualValue
		CompareValues=0
   End If
End Function