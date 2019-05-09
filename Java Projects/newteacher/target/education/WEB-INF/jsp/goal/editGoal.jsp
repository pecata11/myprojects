<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../../css/main.css" />
	<link rel="stylesheet" type="text/css" href="../../../css/buttons.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script src="http://code.jquery.com/jquery-1.8.1.min.js"></script>
	<title>Quench</title>
</head>

<c:url var="saveUrl" value="/api/goal/create" />
<c:url var="ajaxPickGroups" value="/api/goal/ajaxGroups" />

<body>
	<%@include file="../header.jsp"%>
	<div class="innerWidth">
		<div class="page">
			<h1>
				<c:if test="${goal.id <= 0}">Create </c:if>
				<c:if test="${goal.id > 0}">Edit </c:if>
				Goal
			</h1>
			<form:form method="POST" action="${saveUrl}" modelAttribute="goal" >

				<form:hidden path="id" />

				<div style="color:#ff0000; padding: 5px 0 0 10px">${emptyObjectiveError}</div>	
				<br>
				<%@include file="../quiz/objectivePicker.jsp"%>
				<br>				
				
				<table class="goal">
					<tr>
						<td><label class="goalLabel">Name Your Goal:</label></td>
						<td><form:input path="name" class="goalInput" /></td>
						<td><form:errors path="name" cssClass="error" element="div"/></td>
					</tr>
				</table>
				
				<br>
				<table>
					<tr>
						<td nowrap="nowrap"><label class="goalLabel">Choose a Desired Level: </label></td>
						<td><form:input path="target" class="goalTarget"/></td>
						<td><div style="margin-top:6px">&nbsp;% &nbsp;</div></td>
						<td><form:errors path="target" cssClass="error" element="div" style="margin-top:6px"/></td>
					</tr>
				</table>
				<h1></h1>
							
				<br>
				<b>Set Goal for Which Students </b>	<br><br>	
					
				<form:hidden id="classNameHidden" path="currAssignment.className"/>				
				<form:select id ="classSelect" path="currAssignment.classId" cssStyle="width: 130px">
					<form:option value="-1" label="--Class--" />
			   		<form:options items="${classes}" />
				</form:select>&nbsp;&nbsp;
				
				<form:hidden id="groupNameHidden" path="currAssignment.groupName"/>
				<form:select id="groupSelect" path="currAssignment.groupId" cssStyle="width: 130px">
					<form:option value="-1" label="--Group--" />
			   		<form:options items="${groups}" />
				</form:select>&nbsp;&nbsp;
				
				<br><br>
				<table>
					<tr>
						<td><form:checkbox path="currAssignment.auto" /></td>
						<td nowrap="nowrap"> <label for="currAssignment.auto1">Automatically Assign Lessons Based on Goal</label></td>
					</tr>
				</table>	
				<br>
				
				<input id="addAssignment" type="submit" value="Add Assignment" name="addAssignment" class="button" onclick="javascript:beforeAddAssignment()" />
				<br>
				<%@include file="goalAssignments.jsp"%>
							
				<div class="controls">
					<input type="submit" value="Cancel" name="cancel" class="button grey left" />
					<input type="submit" value="Finished" name="done" class="button grey right" />
				</div>
			
			</form:form>
		</div>
</body>
</html>

<script>
$('#grade,#subject').change(function() {
	$('#groupSelect').html("<option value='-1'>--Group--</option>");
	$('#classSelect').val("-1");
	$('#assignmentsTable').remove();
});


function beforeAddAssignment() {
	$('#groupNameHidden').val($('#groupSelect option:selected').text());
	$('#classNameHidden').val($('#classSelect option:selected').text());
}

$('#classSelect').change(function() {
	var classVal = $(this).val();
	var subjectValStr = $('#subject').val();
	var subjectVal = -1;
	if(subjectValStr == 'literacy') {
		subjectVal = 1;
	} else if(subjectValStr == 'math') {
		subjectVal = 2;
	}
	
	if(classVal == -1) {
		$('#groupSelect').html("<option value='-1'>--Group--</option>");
	}
	
	
	if(classVal > 0 && subjectVal > 0) {
		 $.ajax({
		        url: '${ajaxPickGroups}',
		        type:'GET',
		        data: ({classId : classVal, subjectId : subjectVal}),
		    	dataType: "json",
		    	complete: function(transport){
		    		var data = transport.responseText;
		    		data = $.parseJSON(data);
		    		var listItems= "<option value='-1'>--Group--</option>";
			   		for (var i = 0; i < data.length; i++){
				      listItems+= "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
				    }
			   		
			   		$('#groupSelect').html(listItems);
		        }
		      });
	}
});
</script>


