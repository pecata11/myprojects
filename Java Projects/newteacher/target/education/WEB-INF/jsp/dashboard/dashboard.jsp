<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../../css/main.css"/>
<script src="http://code.jquery.com/jquery-1.8.1.min.js"></script>
<title>Quench</title>
</head>
<body>


<%@include file="../header.jsp"%>

<div class="innerWidth">
<div class="page">

<!-- <h1>Dashboard</h1>-->

<c:url var="saveUrl" value="/api/dashboard/" />
<c:url var="ajaxPicksGroups" value="/api/dashboard/groups/" />

<form:form modelAttribute="dashboardBean" method="POST" action="${saveUrl}" class="niceForm" id="idFormDashboard">
	<form:hidden path="excludedStudentIds"/>
	<form:hidden path="sortByColumn"/>
	<form:hidden path="sortDirection"/>
	
	<form:select path="classId" cssStyle="width: 130px">
   		<form:options items="${classes}" />
	</form:select>&nbsp;&nbsp;
	<form:select path="subjectId" cssStyle="width: 130px">
   		<form:options items="${subject}" />
	</form:select>&nbsp;&nbsp;
 	
	<form:select path="groupId" cssStyle="width: 130px">
   		<form:options items="${groups}" />
	</form:select>&nbsp;&nbsp;
 	
	
	<br></br>
	
	<select id="lessonsGoals">
		<option value="2">This Week's Lessons</option>
		<option value="1">Goals</option>
	</select>
	
	<br></br>
	
	<div id="loadedContent">
		<table class="styledTable">
		<tbody>
		<c:forEach items="${dashboardBean.assignmentLessons}" var="al" varStatus="current">
			<tr class="<c:if test="${current.index % 2 != 0}">even</c:if>">
				<td><form:checkbox path="assignmentLessonIds" value="${al.assignmentId}" /></td>
				<td><c:out value="${al.lesonName}" /> <fmt:formatDate value="${al.assignmentStart}" type="both" pattern="MM/dd/yyyy"/></td>
			</tr>
		</c:forEach>
		</tbody>
		</table>
	</div>
	
	<br>


	<br>
	<div class="controls" id="controls">
	 <input type="button" name="add" value="See Result" class="button blue left" onclick="javascript:loadDashboard();"/> 
	 <input type="button" name="reset" value="Reset Groups" class="button blue right" onclick="javascript:resetGroups();"/> 
	</div>
	
	
<br>
<div id="cellColorDiv" style="display:none">
	<table>
		<tr>
			<td><form:checkbox path="cellColor" onclick="javascript:reloadDashboard()"/></td>
			<td nowrap="nowrap"> <label for="cellColor1">Color Code Each Column</label></td>
		</tr>
	</table>
</div>

</form:form>

<div id="idMainDiv" class="scrollDashboard">

</div>
	
</div>
</div>

<c:url var="ajaxLoadDashboardUrl" value="/api/dashboard/" />
<c:url var="ajaxResetGroupsUrl" value="/api/dashboard/resetGroup" />

<script>
$(document).ready(function() {
	var dashboardInitParams = localStorage.getItem('dashboardInitParams');
	if(dashboardInitParams){
		var v = JSON.parse(dashboardInitParams)
		$('#classId').val(v.classId);
		$('#subjectId').val(v.subjectId);
		$('#groupId').val(v.groupId);
		$('#lessonsGoals').val(v.lessonsGoals);
		
		ajaxGroups(v.groupId);
	}
	
	var classId = $('#classId').val();
	if(!classId){
		$("input[type=button]").attr("disabled", "disabled");
		$('#subjectId').prop('disabled', 'disabled');
		alert('Class is missing. Create a class.');
	}
});

function loadDashboard() {
	if($('#classId').val() < 0){
		alert('Choose a Class!');
		return;
	}
	$('#excludedStudentIds').val('');
	$('#sortByColumn').val('');
	$('#sortDirection').val('');
	
	$('#cellColorDiv').removeAttr("style", "display:true");
	
	reloadDashboard();
}
function reloadDashboard() {
	if($('#lessonsGoals').val() == 1){
		$('#loadedContent').hide();
		$('#controls').hide();
    var classId = $('#classId').val();
		var subjectId = $('#subjectId').val();
		var groupId = $('#groupId').val();
    $('#idMainDiv').load('/api/dashboard/ajaxResultGoals?classId=' + classId + '&subjectId=' + subjectId + '&groupId=' + groupId);
	}
	if($('#lessonsGoals').val() == 2){
		$('#loadedContent').show();
		$('#controls').show();
    $.ajax({
		    url: '${ajaxLoadDashboardUrl}',
		    type:'POST',
		    data: $('#idFormDashboard').serializeArray(),
			dataType: "json",
			complete: function(transport){
				var data = transport.responseText;
		   		$('#idMainDiv').html(data);
		    }

		  });
	}
}

function resetGroups() {
	$.ajax({
	    url: '${ajaxResetGroupsUrl}',
	    type:'POST',
	    data: $('#idFormDashboard').serializeArray(),
		dataType: "json",
		complete: function(transport){
			var data = transport.responseText;
			loadDashboard();
	   	}

	  });
}

function saveToLocalStorage() {
	var classId = $('#classId').val();
	var subjectId = $('#subjectId').val();
	var groupId = $('#groupId').val();
	var lessonsGoals = $('#lessonsGoals').val();
	
	var dashboardInitParams = {
			classId: classId,
			subjectId: subjectId,
			groupId: groupId,
			lessonsGoals: lessonsGoals
        }
	localStorage.setItem('dashboardInitParams', JSON.stringify(dashboardInitParams));
}

window.onbeforeunload = function (e) {
	saveToLocalStorage();
};
	
$('#classId').change(function() {
	var classId = $('#classId').val();
	var subjectId = $('#subjectId').val();
	 $.ajax({
	        url: '${ajaxPicksGroups}',
	        type:'GET',
	        data: ({classId : classId,subjectId:subjectId}),
	    	dataType: "json",
	    	complete: function(transport){
	    		var data = transport.responseText;
	    		data = $.parseJSON(data);
	    		var listItems = "";
		   		for (var i = 0; i < data.length; i++){
			      listItems+= "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
			    }
		   		$('#groupId').html(listItems);
				if($('#lessonsGoals').val() == 1) {
					reloadDashboard();
				} else {
			   		ajaxLessons();
			   	}
	        }
	      });
});


$('#subjectId').change(function() {
	ajaxGroups();
});

function ajaxGroups(savedGroupId) {
	
	var subjectId = $('#subjectId').val();
	var classId = $('#classId').val();
	
	 $.ajax({
	        url: '${ajaxPicksGroups}',
	        type:'GET',
	        data: ({subjectId : subjectId,classId:classId}),
	    	dataType: "json",
	    	complete: function(transport){
	    		var data = transport.responseText;
	    		data = $.parseJSON(data);
	    		var listItems = "";
		   		for (var i = 0; i < data.length; i++){
			      listItems+= "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
			    }
		   		$('#groupId').html(listItems);
		   		
		   		if(savedGroupId) {
		   			$('#groupId').val(savedGroupId);
				}
				if($('#lessonsGoals').val() == 1) {
					reloadDashboard();
				} else {
			   		ajaxLessons();
			   	}
	        }
	      });
}
$('#groupId').change(function() {
	if($('#lessonsGoals').val() == 1) {
		reloadDashboard();
	} else {
		ajaxLessons();
	}
});

function ajaxLessons() {
	$('#idMainDiv').html('');
	
	var classId = $('#classId').val();
	var subjectId = $('#subjectId').val();
	var groupId = $('#groupId').val();
	if(groupId)
	{
	 $('#loadedContent').load('/api/dashboard/ajaxLessons?classId=' + classId + '&subjectId=' + subjectId + '&groupId=' + groupId + ' #loadedContent');
	}
}

$('#lessonsGoals').change(function() {
	reloadDashboard();
});

reloadDashboard();
</script>

</body>
</html>