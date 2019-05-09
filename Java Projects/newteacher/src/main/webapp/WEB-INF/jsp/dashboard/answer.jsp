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
<link rel="stylesheet" type="text/css" href="../../css/main.css"/>
<script src="http://code.jquery.com/jquery-1.8.1.min.js"></script>

<title>Quench</title>
</head>
<body>

<%@include file="../header.jsp"%>

<div class="innerWidth">
<div class="page">

	<c:out value="${student.firstName}" /> <c:out value="${student.lastName}" />

	<table class="styledTable">
	<thead style="background:#ccc">
		<tr>
			<th>Question</th>
			<th>Correct Answer</th>
			<th>Student Answer</th>
			<th>Status</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${questAnsBeans}" var="bean" varStatus="current">
			<tr>
				<td>
					<c:if test="${bean.question.imageId == null || bean.question.imageId == 0}">
						<c:out value="${bean.question.text}" />
					</c:if>
					<c:if test="${bean.question.imageId != null && bean.question.imageId != 0}">
						<div id="dbImageDiv">
							<img src="/api/pdfRepo/${bean.question.imageId}"  class="fullWidth"/>
						</div>
					</c:if>
				</td>
				<td><c:out value="${bean.correctAnswerOfQuestion.text}" />
				<td><c:out value="${bean.answer.text}" />
				<td>
					<c:if test="${bean.stAnswer.isCorrect}">Correct</c:if>
					<c:if test="${!bean.stAnswer.isCorrect}">Incorrect</c:if>
				</td>
			</tr>
		</c:forEach>
	</tbody>
	</table>
	
</div>
</div>

</body>
</html>