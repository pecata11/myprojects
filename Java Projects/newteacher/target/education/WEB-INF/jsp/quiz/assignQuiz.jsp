<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../../css/main.css" />
<link rel="stylesheet"	href="http://code.jquery.com/ui/1.10.0/themes/base/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.8.3.js"></script>
<script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
<title>Quench</title>
</head>
<body>

	<%@include file="../header.jsp"%>

	<c:url var="assignUrl" value="/api/quizzes/assign?id=${quiz.id}"  />

	<div class="innerWidth">
		<div class="page">
			<h1>Set a Start Date</h1>
			<div class="row quizRow">
				<div class="left quizName">
					<form:form method="POST" action="${assignUrl}" >
						<label >Lesson: ${quiz.name}</label></br></br>
						Start Date: <input type="text" id="startDate" name="startDate"/>
						&nbsp;&nbsp;&nbsp;
						<input type="submit" value="Assign" name="next" class="button grey "/>
					</form:form>
				</div>
			</div>
		</div>
	</div>

<script>
$(document).ready(function() {
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
</script>

</body>
</html>