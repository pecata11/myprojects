<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix='fn' uri='http://java.sun.com/jsp/jstl/functions' %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../../css/main.css"/>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.1/jquery.js"></script>
<title>Quench</title>
</head>
<body>


	<%@include file="../header.jsp"%>

	<c:url var="startUrl" value="/api/perform/start" />
	<c:url var="editUrl" value="/api/lessonEdit/edit" />
	<c:url var="deleteUrl" value="/api/quizzes/delete" />
	<c:url var="assignUrl" value="/api/quizzes/assign" />
	
<div class="innerWidth">
	<div class="page">

		<c:if test="${not empty drafts}">
			<c:url var="colmpleteDraftUrl" value="/api/draft/complete" />
			<c:url var="deleteDraftUrl" value="/api/draft/delete" />
			<h1>Drafts</h1>
			<c:forEach items="${drafts}" var="draft">
				<div class="row quizRow">
	                <div class="left quizName">
	  					<a href="${colmpleteDraftUrl}?id=${draft.createTimeMlls}">DRAFT_${draft.quizName}</a>
					</div>
					
				   	<a id="deleteBtn" href="${deleteDraftUrl}?id=${draft.createTimeMlls}" onClick="return confirm('Discard Draft?');">
				 		<img title="Discard Draft" src="../../images/delete.png" height="12px" style="padding-left:8px; float:right; margin-top:5px"  />
				  	</a>
					<a href="${colmpleteDraftUrl}?id=${draft.createTimeMlls}" class="right button grey small" title="Complete Draft">Complete</a>
					
				</div>
			</c:forEach>
			</br></br>
		</c:if>

		<h1>Lessons</h1>
			<c:forEach items="${quizzes}" var="quiz">
              <div class="row quizRow">
                <div class="left quizName">
  					<a href="${startUrl}?id=${quiz.id}<c:if test="${quiz.assignmentId != null}">&assignmentId=${quiz.assignmentId}</c:if>">${quiz.name}</a>
				</div>
        
                <c:if test="${student != null && student.access == 1}">
				  
				  <a id="deleteBtn" href="${deleteUrl}?id=${quiz.id}" onClick="return confirm('Do you want to delete?');">
				 	<img title="Delete Quiz" src="../../images/delete.png" height="12px" style="padding-left:8px; float:right; margin-top:5px"  />
				  </a>
				  
				</c:if>
				<c:if test="${student != null && student.access == 1}">
						
					<a href="${assignUrl}?id=${quiz.id}" class="right button grey small">Assign</a>
					<c:if test="${not hideEdit}">				  
				 		<a href="${editUrl}?id=${quiz.id}" class="right button grey small">Edit Lesson</a>
				  	</c:if>
				</c:if>
              </div>
			</c:forEach>
		<br></br>
	<sec:authorize ifNotGranted="ROLE_STUDENT">
		<a href="javascript:findOther();" class="button grey small">Find Other Lessons To Edit</a>
	</sec:authorize>
	</div>
  
  </div>

<script>
$(document).ready(function() {
	
	 var searchLessonIds = localStorage.getItem('lessonIds');
	 if(searchLessonIds){
	 	$('.page').load('/api/quizzes/listLessons?lessonIds=' + searchLessonIds);
	 	localStorage.removeItem('lessonIds'); 
	 }
});

function findOther(){
	 window.location = "/api/searchLessons/search/";
	 localStorage.setItem('callPageUrl', "/api/quizzes/list");
	 var callPageUrl = localStorage.getItem('callPageUrl');
}
</script>
</body>
</html>