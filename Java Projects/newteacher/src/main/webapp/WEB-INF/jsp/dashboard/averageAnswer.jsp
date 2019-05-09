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

<c:out value="${className}" />
<br>
<c:out value="${headerName.lesonName}" /> <fmt:formatDate value="${headerName.assignmentStart}" type="both" pattern="MM/dd/yyyy"/>

	<table class="styledTable" id="avTable">
	<thead style="background:#ccc">
		<tr>
			<th style="background:#aaa"><a href="javascript:sort('question', '${sortDirection}')" >Question</a></th>
			<th style="background:#aaa"><a href="javascript:sort('average', '${sortDirection}')" >Answer</a></th>
		</tr>
	</thead>
	<tbody>
		<c:forEach items="${answerAverage}" var="bean" varStatus="current">
			<tr>
				<td>
					<c:if test="${bean.question.imageId == null || bean.question.imageId == 0}">
						<a href="averageAnswerByStudent?questionId=${bean.question.id}&classId=${bean.classId}&assignmentId=${bean.assignmentId}">
							<c:out value="${bean.question.text}" />
						</a>
					</c:if>
					<c:if test="${bean.question.imageId != null && bean.question.imageId != 0}">
						<div id="dbImageDiv">
							<a href="averageAnswerByStudent?questionId=${bean.question.id}&classId=${bean.classId}&assignmentId=${bean.assignmentId}">
								<img src="/api/pdfRepo/${bean.question.imageId}"  class="fullWidth"/>
							</a>
						</div>
					</c:if>
				</td>
				<td><c:out value="${bean.answer}" /></td>
			</tr>
		</c:forEach>
	</tbody>
	</table>
	
</div>
</div>

<div id="idMainDiv">
</div>
<c:url var="ajaxLoadAverageAnswerUrl" value="/api/dashboard/averageAnswer" />

<script>

function sort(column,direction) {
	
	var old = '${sortByColumn}';

	if(old != column){
		direction='up';
		window.location = '?classId=${classId}&assignmentId=${assignmentId}&sortByColumn=' + column + '&sortDirection=' + direction;
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
			           
	window.location = '?classId=${classId}&assignmentId=${assignmentId}&sortByColumn=' + column + '&sortDirection=' + direction;
}
</script>

</body>
</html>