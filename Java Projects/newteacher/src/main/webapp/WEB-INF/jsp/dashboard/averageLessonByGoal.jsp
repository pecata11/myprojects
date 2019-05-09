<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../../css/main.css"/>
<script src="http://code.jquery.com/jquery-1.8.1.min.js"></script>

<title>GoalAverage</title>
</head>
<body>

<%@include file="../header.jsp"%>

<div class="page">
	<table class="feedbackTable">
		<tr><td>
		Goal: <label><c:out value="${goalName}" /> </label>
		</td></tr>
		<tr><td>
		 Goal Objective: <label><c:out value="${goalObjective}" /> </label>
		</td></tr>
		<tr><td>
		 Goal Target: <label><c:out value="${goalTarget}" />%</label>
		</td></tr>
		<tr><td>
		Student: <label><c:out value="${studentFirstName}" /> <c:out value="${studentLastName}" /></label>
		</td></tr>
	</table>

<br>
	<table class="styledTable">
	<thead style="background:#ccc">
		<tr>
			<th style="background:#aaa"><a href="javascript:sort('lesson', '${sortDirection}')" >Lesson:</a> 
			</th>
			<th style="background:#aaa"><a href="javascript:sort('average', '${sortDirection}')" >Average</a></th>
		</tr>
	</thead>		
	<tbody>
	<c:forEach items="${resultList}" var="ll" varStatus="current">
			<tr>
				<td>
					 <c:out value="${ll.lessonName}" />
				</td>
				<td>
				<a href="answer?studentId=${studentId}&assignmentId=${ll.assignmentId}">
					<c:out value="${ll.averageResult}" /><c:out value="%"/></a>
				</td>
			</tr>
		</c:forEach>
    <tr>
      <td>
         <b>Average</b>
      </td>
      <td>
        <b><c:out value="${averageResult}" /><c:out value="%"/></b>
      </td>
    </tr>
  </tbody>
	</table>
	<p>
	<p>
</div>
<script>
function sort(column,direction) {
	
	var old = '${sortByColumn}';

	if(old != column){
		direction='up';
		window.location = '?studentId=${studentId}&goalId=${goalId}&sortByColumn=' + column + '&sortDirection=' + direction;
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
			           
	window.location = '?studentId=${studentId}&goalId=${goalId}&sortByColumn=' + column + '&sortDirection=' + direction;
}

</script>
</body>
</html>