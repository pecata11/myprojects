<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Quench</title>
<link rel="stylesheet" type="text/css" href="../../css/main.css"/>
</head>
<body>
<%@include file="../header.jsp"%>

<div class="innerWidth">

<div class="page">
<h1>Create Lesson</h1>
<c:url var="listQuizzesUrl" value="/api/quizzes/list" />
<c:url var="saveUrl" value="/api/lessonEdit/start" />
<p>Lesson added successfully!</p>
<p>Go to  list of <a href="${listQuizzesUrl}">lessons</a></p>
<p>Create new <a href="${saveUrl}">lesson</a></p>
</div>

</div>

</body>
</html>