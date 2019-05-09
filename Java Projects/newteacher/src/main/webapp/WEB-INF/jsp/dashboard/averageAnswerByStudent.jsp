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

<div class="page">
<br>
	<table class="styledTable">
	<thead style="background:#ccc">
		<tr>
			<th style="background:#aaa"><a href="javascript:sort('question', '${sortDirection}')" >Question:</a> 
				<c:if test="${question.imageId == null || question.imageId == 0}">"${question.text}"</c:if>
			</th>
			<th style="background:#aaa"><a href="javascript:sort('average', '${sortDirection}')" >Average</a></th>
		</tr>
	</thead>
	
	<c:if test="${question.imageId != null && question.imageId != 0}">
			<tr>
				<td>
					<div id="dbImageDiv">
						<img src="/api/pdfRepo/${question.imageId}"  class="fullWidth"/>
					</div>
				</td>
				<td></td>
			</tr>	
	</c:if>
					
					
	<tbody>
		<c:forEach items="${answerAverageByStudent}" var="bean" varStatus="current">
			<tr>
				<td>
					Answer 	<c:if test="${bean.correct}"><c:out value="(Correct)"/></c:if> : 
					 <c:out value="${bean.answer.text}" />
				</td>
				<td>
					<c:out value="${bean.answerVal}" /><c:out value="%"/>
				</td>
			</tr>
		</c:forEach>
	</tbody>
	</table>
	<p>
	<p>

	<c:if test="${!freeResponseEmpty}" >
		<div>Answers to Free Response Question: <c:out value="${question.text}" />?</div>
		<table class="styledTable">
		<thead style="background:#ccc">
			<tr>
				<th>Name</th>
				<th>Response</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach items="${freeResponseList}" var="bean" varStatus="current">
				<tr>
					<td>
	
						 <c:out value="${bean.firstStudentName}" />
					</td>
					<td>
						<c:out value="${bean.freeResponse}" />
					</td>
				</tr>
			</c:forEach>
		</tbody>
		</table>
	</c:if>
</div>
<script>
function sort(column,direction) {
	
	var old = '${sortByColumn}';

	if(old != column){
		direction='up';
		window.location = '?classId=${classId}&questionId=${questionId}&assignmentId=${assignmentId}&sortByColumn=' + column + '&sortDirection=' + direction;
		return;
	}
	
	var direction = '${sortDirection}';
	if(direction == 'up'){
		direction='down';
	} else if(direction == 'down'){
		direction='up';
	} else {
		direction='up';
	}
			           
	window.location = '?classId=${classId}&questionId=${questionId}&assignmentId=${assignmentId}&sortByColumn=' + column + '&sortDirection=' + direction;
}

</script>
</body>
</html>