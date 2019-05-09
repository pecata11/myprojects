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
	
<div class="innerWidth">
	<div class="page">

		<h1>Lessons</h1>
		<c:forEach items="${quizzes}" var="quiz">
             <div class="row quizRow">
               <div class="left quizName">
 					<a href="${startUrl}?id=${quiz.id}<c:if test="${quiz.assignmentId != null}">&assignmentId=${quiz.assignmentId}</c:if>">${quiz.name}</a>
			</div>
             </div>
		</c:forEach>
			
		<c:if test="${fn:length(autoQuizzes) > 0}">
			<!--Goal Based Lessons - leave comment so we can identify them-->
			<c:forEach items="${autoQuizzes}" var="autoQuiz">
	             <div class="row quizRow">
	               	<div class="left quizName">
	 					<a href="${startUrl}?id=${autoQuiz.id}">${autoQuiz.name}</a>
					</div>
	             </div>
			</c:forEach>
		</c:if>			
			
			
		<br></br>
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