<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../css/main.css"/>
<title>Quench</title>
</head>
<body>


<%@include file="../header.jsp"%>
	
<div class="innerWidth">
	<div class="page">

		<h1>Creator Leaderboard</h1>
		
		<table class="styledTable">
			<thead style="background:#ccc">
				<tr>
					<th>Rank</th>
					<th>Creator</th>
					<th>Lessons Created</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach items="${ranks}" var="rank" varStatus="current">
	            <tr class="<c:if test="${current.index % 2 != 0}">even</c:if>">
				<td class="smallWidth"><c:out value="${rank.rank}" /></td>
				<td><c:out value="${rank.name}" /></td>
				<td class="smallWidth"><c:out value="${rank.createdLessons} " /></td>
				</tr>
			</c:forEach>
			</tbody>
	</table>
</div>
  
  </div>
	
</body>
</html>