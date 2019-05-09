<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.Date" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../../css/main.css"/>
<title>Quench</title>
</head>
<body>

<%@include file="../header.jsp" %>

<div class="innerWidth">

<div class="page">

<h1>Quiz Results</h1>
<c:url var="listQuizzesUrl" value="/api/quizzes/list" />
<p> You made: <b>${percentCorrect} %</b> correct answers!</p> 
<!-- <p>You made <b>${yourCorrect}</b> of <b>${allCorrect}</b> correct answers!</a></p>-->
<p>Go to  list of <a href="${listQuizzesUrl}">lessons</a></p>

</div>

</div>

</body>
</html>