<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


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

<%@include file="../header.jsp" %>

<c:url var="nextUrl" value="/api/perform/iterate" />
<c:set var="nextBtnName" value="Next Question" />
<c:set var="currQuestionNumber" value="${performQuiz.currentQuestionNumber}" />
<c:if test="${currQuestionNumber == (fn:length(performQuiz.questions) - 1)}">
	<c:set var="nextBtnName" value="See Result" />
</c:if>

<div class="innerWidth">
<div class="page">

<h1>Please watch this video</h1>
<form:form method="POST" action="${nextUrl}" modelAttribute="performQuiz">

	${intervention}
	
    <div class="controls">
		<input type="submit" value="${nextBtnName}" name="leaveIntervention" class="button blue right"/>
    </div>
</form:form>
</div>

</div>


</body>
</html>

