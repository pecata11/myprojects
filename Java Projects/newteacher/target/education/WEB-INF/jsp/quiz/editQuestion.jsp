<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="../../css/main.css"/>
<link rel="stylesheet" type="text/css" href="../../css/buttons.css"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="http://code.jquery.com/jquery-1.8.1.min.js"></script>
<title>Quench</title>

</head>
<body>

<%@include file="../header.jsp" %>

<div class="innerWidth">

<c:url var="ajaxChangeQuestionTypeUrl" value="/api/lessonEdit/questionType" />

<div class="page">
<h1>Question ${quiz.currentQuestionNumber + 1}</h1>

<!-- 
<select id="type" name="type" >
	<option value="0" <c:if test="${question.type == 0}">selected="selected" </c:if> >Manual Entry</option>
	<option value="1" <c:if test="${question.type == 1}">selected="selected" </c:if> >Image</option>
</select>
<br/><br/><br/>
 -->
<div id="questionDiv">
	<c:choose>
		<c:when test="${quiz.entryType == 1}">
			<%@include file="editImageQuestion.jsp" %>
		</c:when>
		<c:otherwise>
			<%@include file="editManualQuestion.jsp" %>
		</c:otherwise>
	</c:choose>
</div>


<script>
	$('input:checkbox[class=chb]').live('click',function(){
		$(this).parent().parent().parent().children().find(".chb").attr('checked',false);
		$(this).attr('checked',true);
	});
	
	$('input:checkbox[class=chbFreeResponse]').live('click',function(){
		var hasFreeResponse = $(this).is(':checked');
		if(hasFreeResponse) {
			$('#freeResponse').attr("style", "display:true");
		} else {
			$('#freeResponse').attr("style", "display:none");
		}
	});
	
	function deleteAnswer(a_num) {
		var hasFreeResponse = $('.chbFreeResponse').is(':checked');
		
		var numAnswers = $('table.answers > tbody > tr.answer').length;
	
		if(!hasFreeResponse && numAnswers < 3) {
			alert("Cannot Delete - at least 2 answers per question required!");
			return;
		} 
		var answerText = $('#a_' + a_num + ' textarea').val();
		if(!answerText || confirm('Delete this answer?')) {
			$('#answerDeleted_' + a_num).val(true);
			$('#a_' + a_num).remove();
			$('#a_' + a_num + '_intervention').remove();
		} 
	
	}
</script>


</body>
</html>