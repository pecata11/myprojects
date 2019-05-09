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
<script src="http://code.jquery.com/jquery-1.8.1.min.js"></script>

<title>Quench</title>
</head>
<body>

<%@include file="../header.jsp"%>

<div class="innerWidth">
<div class="page">
<c:url var="saveUrl" value="/api/classes/assign" />

<form:form modelAttribute="assignClassAttribute" method="POST" action="${saveUrl}" class="niceForm">

   <!-- <input type="submit" name="remove"  value="Remove from Class" class="button blue right validation" />-->
			<form:label path="classId"><font size="4">Students</font></form:label>
		<div class="controls">
			<input type="submit" id="addSelectedButton" name="add"  value="Add All Selected Students to a Class" class="button blue left validation"   />
		 	&nbsp;&nbsp;<form:select path="classId"  cssStyle="width: 250px">
   				<form:options items="${classes}" />
			</form:select>
		</div>
	
	<br>
	<c:url var="addUrl" value="/api/classes/addStudent" />
	<table class="styledTable">
	<thead style="background:#ccc">
		<tr>
			<th><form:checkbox path="checkall" id="chAll" cssClass="chb"/>Select All</th>
			<th>Student Name</th>
			<th>User Name</th>
			<th>Class Name</th>
			<th colspan="3" style="background:#999"><a href="${addUrl}">Add Student</a></th>
		</tr>
	</thead>
	<tbody>
	<c:forEach items="${students}" var="student" varStatus="current">
			<c:url var="editUrl" value="/api/classes/editStudent?id=${student.student.id}" />
			<c:url var="deleteUrl" value="/api/classes/deleteStudent?id=${student.student.id}" />
			
		<tr class="<c:if test="${current.index % 2 != 0}">even</c:if>">
			<td><form:checkbox path="studentsIds" class="case" value="${student.student.id}" /></td>
			<td><c:out value="${student.student.firstName} ${student.student.lastName}" /></td>
			<td><c:out value="${student.student.username}" /></td>
			<td><c:out value="${student.studentClass.name}" /></td>
		    <td><a href="${editUrl}">Edit</a></td>
			<td style="border-right: 1px solid #ccc;"><a href="${deleteUrl}" onClick="return confirm('Do you want to delete?');">Delete</a></td>
		</tr>
	</c:forEach>
	</tbody>
	</table>
	
</form:form>

</div>
</div>

<script>

$(".validation").click(function(event){
	 if(!$('#classId').val()){
			alert('No classes presented.');
		 event.stopPropagation();
		 return false;
		}
	return true;
  });

$("#addSelectedButton").click(function(event){
	var n = $("input:checked").length; 
	if(n == 0){
		alert("You must select students to add to the class");
		event.preventDefault();
	}	
});

$("#chAll").click(function () {
    $('.case').attr('checked', this.checked);
});

$(".case").click(function(){
  if($(".case").length == $(".case:checked").length) {
      $("#chAll").attr("checked", "checked");
  } else {
      $("#chAll").removeAttr("checked");
  }

});
</script>
</body>
</html>