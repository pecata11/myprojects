<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../../../css/main.css"/>
<link rel="stylesheet"	href="http://code.jquery.com/ui/1.10.0/themes/base/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.8.3.js"></script>
<script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
<title>Feedback Form</title>
</head>

<body>
	<%@include file="../header.jsp"%>
<div class="page">
	<p>
	<h1>Feedback Form</h1>
	<c:url var="feedbackUrl" value="/api/feedbackForm/feedback/" />
	<p>
	<form:form method="POST" action="${feedbackUrl}" modelAttribute="feedbackBean"  id="feedbackForm">
		<table class="feedbackTable">
			<tbody>
				<tr>
					<td><b>From:</b></td>
					<td>${feedbackBean.userName}</td>
				</tr>
				<tr>
					<td><b>My Email:</b></td>
					<td><form:input path="userEmail" class="feedbackInput" /></td>
				</tr>
				<tr>
					<td><b>Feedback:</b></td>
					<td><form:textarea path="feedback" class="questionTextarea" /></td>
				</tr>

			</tbody>
		</table>
	
	<div class="controls">
	    <center>
	    <input type="submit" name="feedbackForm" value="Send Feedback" 
	           class="button blue left" onclick=""/> 
	    </center>
	</div>
	<c:if test="${result}">
	<div style="align:center; color:#000000; padding: 5px 0 0 10px">
		 Email sent successfully.
	</div>
	</c:if>
</form:form>
<p>
</div>
</body>
</html>	