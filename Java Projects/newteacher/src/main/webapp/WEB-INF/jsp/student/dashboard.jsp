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
  
  <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" />
  <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
  <script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
<title>Quench</title>
  <style>
  #progressbar .ui-progressbar-value {
    background-color: #ccc;
  }
  </style>
</head>
<body>

<%@include file="../header.jsp"%>

<div class="page">
My time online this week: <b>${timeSpent} </b> <br>
Lessons completed: <b>${completedCount} </b>

<br><br>
<div style="position:relative;background:#fff">
   <c:if test="${!empty statList}">
		<c:forEach items="${statList}" var="stat" varStatus="current">
			<table class="feedbackTable">
			<tr>
				<td>
					<div style="float:left;width:70px;"><c:out value="${stat.goalName}" /></div>
				</td>	
				<td>
					<div style="float:left;width:150px;" id="progressbar${current.index}" >
						<span style="position:absolute; margin-left:10px; margin-top:2px">
						<c:out value="${stat.studentAverageCompletedLessons}" /></span>
					</div>
					<div style="float:left;width:100px;margin-top:5px">&nbsp;&nbsp;<b><c:out value="${stat.goalTarget}" /></b></div>
				</td>
			</tr>
			</table>
			</c:forEach>
	</c:if>
</div>	
</div>
<script>
$(document).ready(function() {
		<c:forEach items="${statList}" var="stat" varStatus="current">
		$("#progressbar${current.index}").progressbar({
			value: ${stat.studentAverageCompletedLessons},
			max:${stat.goalTarget},
		    });
		$("#progressbar${current.index} > div").css({"background": '${stat.color}' });
		</c:forEach>
	});	
</script>

</body>
</html>