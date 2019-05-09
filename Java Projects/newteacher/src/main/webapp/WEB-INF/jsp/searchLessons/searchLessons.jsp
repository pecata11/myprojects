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
<title>Search Lessons</title>
</head>

<body>
	<%@include file="../header.jsp"%>
<div class="page">
<p>
<h1>Search Lessons</h1>
<c:url var="searchUrl" value="/api/searchLessons/search/" />
<p>

<form:form method="POST" action="${searchUrl}" modelAttribute="searchBean"  id="searchForm">
	<%@include file="../quiz/objectivePicker.jsp"%>
	<label>Lesson Text Contains:</label> <form:input path="searchTerm" class="lessonInput" />
	<div class="controls">
	  <input type="submit" name="search" value="Search" class="button blue left" onclick=""/> 
	</div>
	<c:if test="${noSearchCriteriaSpecified}">
	<div class="error" style="color:#ff0000; padding: 5px 0 0 10px">
		 Please, specify at least one search criteria.
	</div>
	</c:if>
	<p><p>
	<c:if test="${!empty resultBeanList}">
	<div class="tableScrollerWrapper">
			<table class="styledTable">
			<thead style="background:#ccc">
				<tr>
					<th><form:checkbox path="checkall" id="chAll" cssClass="chb"/>Select All</th>
					<th>Lesson</th>
					<th>Creator</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${resultBeanList}" var="lesson" varStatus="current">
				<tr class="<c:if test="${current.index % 2 != 0}">even</c:if>">
					<td><form:checkbox path="lessonIds" class="case" value="${lesson.lessonId}" /></td>
					<td><c:out value="${lesson.quizName}" /></td>
					<td><c:out value="${lesson.creatorName}" /></td>
				</tr>
			</c:forEach>
			</tbody>
		</table>
	</div>
</c:if>

<c:if test="${isEmpty}">
<label>No lessons found.</label>
</c:if>

<c:if test="${!empty resultBeanList}">
	<div class="controls">
	  <input type="button" name="select" value="Select lessons" id="selectLesson" 
	  		 class="button blue left" onclick="javascript:saveToLocalStorage();"/> 
	</div>
	</c:if>
</form:form>
<p>
</div>

<script>
function saveToLocalStorage()
{
	var ifAnyCheckedBox = $("input:checked").length; 
	if(ifAnyCheckedBox == 0)
	{
		alert("No lesson(s) selected.");
		event.preventDefault();
	}	
	else
	{
		var list = $("input:checked[id^='lessonIds']");
		var values="";
		list.each(function(index) {
			if($(this).val()!= 'undefined')
			{
			   values = values + $(this).val();
			   values+=",";
			}
		   })
		 localStorage.setItem('lessonIds', values);
		 var callPageUrl = localStorage.getItem('callPageUrl');
		 window.location = callPageUrl;
 	}
}

$("#chAll").click(function () {
    $('.case').attr('checked', this.checked);
});

$(".case").click(function(){
	  if($(".case").length == $(".case:checked").length) {
	      $("#chAll").attr("checked", "checked");
	  } else {
	      $("#chAll").removeAttr("checked");
	  }
});
</script>
</body>
</html>	