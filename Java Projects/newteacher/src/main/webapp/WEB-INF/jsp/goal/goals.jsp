<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib prefix='fn' uri='http://java.sun.com/jsp/jstl/functions' %>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../../css/main.css" />
	<link rel="stylesheet" type="text/css" href="../../../css/buttons.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script src="http://code.jquery.com/jquery-1.8.1.min.js"></script>
	<title>Quench</title>
</head>

<body>
	<%@include file="../header.jsp"%>
	<div class="innerWidth">
		<div class="page">
			<h1>Goals</h1>
		
		<c:url var="createGoalUrl" value="/api/goal/create" />
		<c:url var="editGoalUrl" value="/api/goal/edit" />
		<c:url var="deleteGoalUrl" value="/api/goal/delete" />
        <a href="${createGoalUrl}"><font size ="3">Create Goal</font></a>
        <p>	
		
		<c:choose>
			<c:when test="${fn:length(goals) == 0}">
				<br><label>You have 0 goals.</label>
			</c:when>
			<c:otherwise>
				<table class="styledTable">
					<thead style="background:#ccc">
						<tr>
							<th>Goal Name</th>
							<th>Objective</th>
							<th>Target</th>
 							<th></th>  
							<th></th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${goals}" var="goal">
						<tr>
							<td>${goal.name}</td>
							<td>${goal.objective}</td>
							<td>${goal.target}</td>
							<td><a href="${editGoalUrl}?id=${goal.id}"><font size ="2">Edit Goal</font></a></td> 
							<td>
								<a id="deleteBtn" href="${deleteGoalUrl}?id=${goal.id}" onClick="return confirm('Delete Goal?');">
					 			<img title="Delete Goal" src="../../../images/delete.png" height="12px" style="margin-top:5px"  /></a>
							</td>				 			
						</tr>
						</c:forEach>				
					</tbody>
				</table>			
			</c:otherwise>
		</c:choose>
		
			
		
		</div>
	</div>
</body>
</html>


