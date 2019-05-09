<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

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


<%@include file="../header.jsp"%>


<div class="innerWidth">
<div class="page">

<h1>Students</h1>

<c:url var="addUrl" value="/api/classes/addStudent" />
<table class="styledTable">
	<thead style="background:#ccc">
		<tr>
			<th>Student Name</th>
			<th>UserName</th>
			<!--  <th>Password</th>-->
			<th colspan="3"><a href="${addUrl}">Add Student</a></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach items="${students}" var="student" varStatus="current">
			<c:url var="editUrl" value="/api/classes/edit?id=${student.id}" />
			<c:url var="deleteUrl" value="/api/classes/delete?id=${student.id}" />
			<c:url var="assignUrl" value="/api/classes/assign?id_student=${student.id}" />
		<tr class="<c:if test="${current.index % 2 != 0}">even</c:if>">
			<td><c:out value="${student.firstName} ${student.lastName}" /></td>
			<td><c:out value="${student.username}" /></td>
			<!--  <td><c:out value="${student.password}" /></td>-->
			<td><a href="${editUrl}">Edit</a></td>
			<td><a href="${deleteUrl}" onClick="return confirm('Do you want to delete?');">Delete</a></td>
			<td><a href="${assignUrl}">Add To Class</a></td>
		</tr>
	</c:forEach>
	</tbody>
</table>

<c:if test="${empty students}">
	There are currently no students in the list. <a href="${addUrl}">Add Student</a>
</c:if>

</div>

</div>

</body>
</html>