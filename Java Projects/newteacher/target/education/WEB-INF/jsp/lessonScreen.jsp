<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../../css/main.css"/>
</head>
<body>
<%@include file="header.jsp" %>
  <div class="page"><p>
           <sec:authorize ifAnyGranted="ROLE_ADMIN">
      
      	<c:url var="createQuizUrl" value="/api/lessonEdit/start" />
        <a href="${createQuizUrl}"><font size ="3">Create Lesson</font></a>
        <p>	
        <c:url var="homeUrl" value="/api/quizzes/list" />
         <a href="${homeUrl}"><font size="3">Edit Lessons and Drafts</font></a>
        <p>
       <!-- 
       	 <c:url var="lessonUrl" value="/api/quizzes/list?hideDrafts=true" />
       	 <a href="${lessonUrl}"><font size="3">Assign Lesson</font></a>
       	-->
      <p>
       	<c:url var="pdfFilesUrl" value="/api/pdfRepo/list" />
         <a href="${pdfFilesUrl}"><font size="3">PDF Repository</font></a>
        <p>
       	
      </sec:authorize>
  </div>

</body>
</html>