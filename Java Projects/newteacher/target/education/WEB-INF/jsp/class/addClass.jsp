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
<script src="http://code.jquery.com/jquery-1.8.3.js"></script>
<script src="http://code.jquery.com/ui/1.10.0/jquery-ui.js"></script>
<title>Classes</title>
</head>
<body>

<%@include file="../header.jsp"%>

<div class="innerWidth">
<div class="page">

  <h1>Manage Classes</h1>
  
<c:if test="${studentClassAttribute.id > 0}">
	<c:url var="saveUrl" value="/api/classes/edit?id=${studentClassAttribute.id}" />
</c:if>
<c:if test="${studentClassAttribute.id == 0}">
	<c:url var="saveUrl" value="/api/classes/create" />
</c:if>

<form:form modelAttribute="studentClassAttribute" method="POST" action="${saveUrl}">
	
	<form:label path="name">Enter class name:</form:label> 
	<form:input id="nameOfClass" path="name" style="margin-left: 50px; width: 200px;"/>
	<input  type="submit" id="createClass" value="Create Class" class="button blue right"/>
    
    <c:if test="${error != ''}">
      <div class="red mt15">${error}</div>
    </c:if>
    
    
    <div class="controls">
	 
	</div>
</form:form>

<div align="center"> 
<table class="styledTable" style="width: 60%;">
	<thead style="background:#ccc">
		<tr>
			<th>Classes</th>
			<th style="width: 20px;"> </th>
		</tr>
	</thead>
	<tbody>
	<c:forEach items="${classes}" var="stClass" varStatus="current">
			<c:url var="deleteUrl" value="/api/classes/delete?id=${stClass.id}" />
		<tr class="<c:if test="${current.index % 2 != 0}">even</c:if>">
			<td ><c:out  value="${stClass.name}" /></td>
			<td><a href="${deleteUrl}"><img title="Delete Question" src="../../images/delete.png" height="12px" style="padding-left:8px; float:right"  /></a></td>
		</tr>
	</c:forEach>
	</tbody>
</table>
</div>

</div>
</div>
<script>


$("#createClass").click(function(event){
	var className = $("#nameOfClass").val();
	if(className.length == 0){
		alert("The class name, can not be empty.");
		event.preventDefault();
	}	
});
</script>
</body>
</html>