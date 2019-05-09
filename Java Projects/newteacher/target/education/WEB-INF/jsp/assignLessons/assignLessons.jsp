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
<link rel="stylesheet" type="text/css" href="../../../css/main.css"/>
<link rel="stylesheet"	href="http://code.jquery.com/ui/1.10.0/themes/base/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.8.3.js"></script>
<script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
<title>Quench</title>
</head>
<body>


	<%@include file="../header.jsp"%>

<c:url var="ajaxPicksGroupsAndStudents" value="/api/assignLessons/groups" />
<c:url var="ajaxclearStudentPlayList" value="/api/assignLessons/clear" />

<div class="innerWidth">
<div class="page">

<c:url var="saveUrl" value="/api/assignLessons/student" />

<form:form modelAttribute="assignBean" method="POST" action="${saveUrl}" class="niceForm" id="idForm">
	
	<form:select path="classId" cssStyle="width: 250px">
   		<form:options items="${classes}" />
	</form:select>
	
	<form:select path="studentId" cssStyle="width: 250px">
   		<form:options items="${students}" />
	</form:select>
	<br>
	<br>
	
	<div class="tableScrollerWrapper">
		<table class="styledTable">
		<tbody>
		<c:forEach items="${lessons}" var="al" varStatus="current">
			<tr class="<c:if test="${current.index % 2 != 0}">even</c:if>">
				<td><form:checkbox path="lessonIds" value="${al.id}" /></td>
				<td><c:out value="${al.name}" /></td>
				<td>
				<c:if test="${al.grade != null && al.grade != '-1'}">
					<c:out value="${al.grade}" />
				</c:if>
				<c:if test="${al.subject != null && al.subject != '-1'}">
					/<c:out value="${al.subject}" />
				</c:if>
				<c:if test="${al.strand != null && al.strand != '-1'}">
					/<c:out value="${al.strand}" />
				</c:if>
				<c:if test="${al.objective != null && al.objective != '-1'}">
					/<c:out value="${al.objective}" />
				</c:if>
				</td>
			</tr>
		</c:forEach>
		</tbody>
		</table>
	</div>
	<br>
	
	<br></br>
	Start Date: <input type="text" id="startDate" name="startDate"/>
	<br></br>
	
	<select id="idMoreOptions" onchange="javascript:recommendMore($(this))">
	  <option value="1">Recommend More</option>
	  <option value="4">Assign Other Lessons</option>
	  <option value="2">Show Currently Assigned Lessons</option>
	  <option value="3">Clear Playlist</option>
	</select>
	
	<br></br>
	<form:checkbox path="isQuiz" cssClass="chb"/>  Quiz (just questions and answers)
	<br></br>
	<input type="submit" id="assignl" value="Assign Selected" name="next" class="button grey"/>
</form:form>

<br>

<div id="idMainDiv">
</div>
	
</div>
</div>
<script>
$(document).ready(function() {
	
	 var searchLessonIds = localStorage.getItem('lessonIds');
	 if(searchLessonIds){
	 	$('.tableScrollerWrapper').load('/api/assignLessons/getSearchLessons?lessonIds=' + searchLessonIds +' #loadedContent');
	 	localStorage.removeItem('lessonIds'); 
	 }
	 $(function() {
		$("#startDate").datepicker({
	        showOn: 'button',
	        buttonImage: '../../images/calendar.png',
	        buttonImageOnly: true, 
	        buttonText: "Choose Date",
	        clickInput:true, 
	        showOn: "both"
	     });
		
		$("#startDate").datepicker('setDate', new Date());
	  });
});


$('#classId').change(function() {
	var classId = $('#classId').val();
	
	 $.ajax({
	        url: '${ajaxPicksGroupsAndStudents}',
	        type:'GET',
	        data: ({classId : classId}),
	    	dataType: "json",
	    	complete: function(transport){
	    		var data = transport.responseText;
	    		data = $.parseJSON(data);
	    		var listItems = "";
		   		for (var i = 0; i < data.length; i++){
			      listItems+= "<option value='" + data[i].id + "'>" + data[i].name + "</option>";
			    }
		   		
		   		$('#studentId').html(listItems);
	        }
	      });
	});
	
function clearStudentPlayList() {
	var classId = $('#classId').val();
	var studentId = $('#studentId').val();
	 $.ajax({
	        url: '${ajaxclearStudentPlayList}',
	        type:'GET',
	        data: ({classId : classId, studentId : studentId}),
	    	dataType: "json",
	    	complete: function(transport){
	    		var data = transport.responseText;
	    		alert(data);
	        }
	      });
}

$("#assignl").click(function(event){
	var n = $("input:checked[id^='lessonIds']").length;  
	if(n == 0){
		alert("Please, select lessons for assignment.");
		event.preventDefault();
	}	
});

function recommendMore(component){
	var classId = $('#classId').val();
	var studentId = $('#studentId').val();
	
	if(component.val() == 1){
		$('.tableScrollerWrapper').load('/api/assignLessons/recommendLesons?classId=' + classId + '&studentId=' + studentId + '&lessonId=${assignBean.lessonId} #loadedContent');
	}
	if(component.val() == 3){
		clearStudentPlayList();
	}
	if(component.val() == 2){
		$('.tableScrollerWrapper').load('/api/assignLessons/currLesons?classId=' + classId + '&studentId=' + studentId + ' #loadedContent');
	}
	if(component.val() == 4){
		 window.location = "/api/searchLessons/search/";
		 localStorage.setItem('callPageUrl', "/api/assignLessons/student");
		 var callPageUrl = localStorage.getItem('callPageUrl');
	}
}

$('#studentId').change(function() {
	recommendMore($('#idMoreOptions'));
});
	
</script>

</body>
</html>