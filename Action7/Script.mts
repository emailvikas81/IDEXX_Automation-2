'Initialize variables with test data
Call ReadDataTable("Global")
LinkID=Values(4)

'Verify link with the specified ID exists , if yes then click it, else fail

	If Browser("name:=.*").Page("title:=IDEXX.*").Link("html id:=" & LinkID).Exist(15) Then 
	Browser("name:=.*").Page("title:=IDEXX.*").Link("html id:=" & LinkID).click
		TaskResponse ="Completed"
		Report.LogReport micPass, "Intermediate page found, link clicked","Link ID = " & LinkID
	Else
		TaskResponse ="Fail"
		Report.LogReport micFail, "Intermediate page no found","Link ID = " & LinkID
		ExitTest	'End Test
	End If