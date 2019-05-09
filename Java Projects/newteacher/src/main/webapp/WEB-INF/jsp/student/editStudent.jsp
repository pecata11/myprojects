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

<h1>Edit Student</h1>

	<c:url var="saveUrl" value="/api/classes/editStudent?id=${studentAttribute.id}" />
	<form:form modelAttribute="studentAttribute" method="POST" action="${saveUrl}" class="niceForm">
		<!-- <form:label path="id">Id:</form:label>
		<form:input path="id" disabled="true"/>-->
		
		<form:label path="firstName">First Name:</form:label>
		<form:input path="firstName" class="fullWidth" />
		
		<form:label path="lastName">Last Name</form:label>
		<form:input path="lastName" class="fullWidth" />
		
			<form:label path="classId">Classes:
			<form:select path="classId" cssStyle="width: 250px">
   			    	<form:options items="${classes}" />
			</form:select>
			</form:label>
			<p>
		
		<form:label path="username">Username</form:label>
		<form:input path="username" class="fullWidth" />
		
		<form:label path="password">Password</form:label>
		<form:input path="password" readonly="true" value="pass" class="fullWidth" />
		
		<div class="controls">
			<input type="submit" value="Save" />
		</div>
		
	</form:form>

</div>

</div>

</body>
</html>