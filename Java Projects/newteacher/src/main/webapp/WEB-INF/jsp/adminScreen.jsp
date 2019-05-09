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
</head>
<body>
<%@include file="header.jsp" %>
  <div class="page">
	<p>
      <sec:authorize ifAnyGranted="ROLE_ADMIN,ROLE_USER">
        <c:url var="createLeaderboardUrl" value="/api/leaderboard?order=rank" />
       	<a href="${createLeaderboardUrl}"><font size="3">Leaderboard</font></a>
       	<p>
      	<p>
       	<c:url var="classesUrl" value="/api/classes/assign" />
       	<a href="${classesUrl}"><font size="3">Roster</font></a>
       	<p>
       	<p>
       	<c:url var="classesUrl" value="/api/classes/create" />
       	<a href="${classesUrl}"><font size="3">Manage Classes</font></a>
       	<p>
        <c:url var="createAdminUrl" value="/api/teachers/add" />
       	<a href="${createAdminUrl}"><font size="3">Create Accounts</font></a>
		<p>
        <c:url var="assignLessonsUrl" value="/api/assignLessons/student" />
       	<a href="${assignLessonsUrl}"><font size="3">Assign Lessons</font></a>       
      </sec:authorize>
  </div>

</body>
</html>