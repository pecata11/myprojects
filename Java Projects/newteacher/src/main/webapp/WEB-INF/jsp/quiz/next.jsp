<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="../../css/main.css"/>
<script type="text/javascript" src="../../script/jquery.js" ></script>
<script type="text/javascript" src="../../script/jqueryui.js" ></script>
<script type="text/javascript" src="../../script/jquery.mousewheel.min.js" ></script>
<script type="text/javascript" src="../../script/jquery.iviewer.js" ></script>
<script type="text/javascript" src="../../script/jquery.simplemodal-1.4.4.js" ></script>

<link rel="stylesheet" href="../../script/jquery.iviewer.css" />


<style>
input[type="checkbox"] {
    -webkit-appearance: radio;
    -moz-appearance: radio;
    -ms-appearance: radio;   
    -o-appearance: radio;  
      vertical-align: top;
}

.quizQuestion {
  font-size: 16px;
  margin-bottom: 12px;
}

.quizQuestion:first-letter {
  text-transform: uppercase;
}

.quizAnswer + .quizAnswer {

}

.viewer 
{ 
   width:520px;
   height:400px;
   border: 1px black;
   position: relative;
}
            
.wrapper
{
   overflow: hidden;
}

</style>
<title>Quench</title>
</head>
<body>

<%@include file="../header.jsp" %>

<div class="innerWidth">

<c:url var="nextUrl" value="/api/perform/iterate" />
<c:url var="imageUrl" value="/api/pdfRepo" />

<c:set var="currQuestion" value="${performQuiz.questions[performQuiz.currentQuestionNumber]}" />
<c:set var="currQuestionNumber" value="${performQuiz.currentQuestionNumber}" />
<c:set var="nextBtnName" value="Next Question" />
<c:if test="${currQuestionNumber == (fn:length(performQuiz.questions) - 1)}">
	<c:set var="nextBtnName" value="See Result" />
</c:if>

<div class="page">

<h1>Question ${currQuestionNumber+1}</h1>
<form:form method="POST" action="${nextUrl}" modelAttribute="performQuiz">

	<div class="quizQuestion">${performQuiz.description}</div>
	<c:if test="${performQuiz.instructionImage && performQuiz.instrImage.imageId > 0}">
	  <img id="isntrImage" src="${imageUrl}/${performQuiz.instrImage.imageId}"
				onload="tuneSizes(${performQuiz.instrImage.imageId})"/>
	</c:if>
	
	<c:choose>
		<c:when test="${currQuestion.image.imageId == 0}">
			<div class="quizQuestion">${currQuestion.text}</div>
		</c:when>
		<c:otherwise>
			 <div id="viewer" class="viewer">
				<c:set var = "imageId" value="${currQuestion.image.imageId}"/>
				<!--  <img id="dbImage" src="${imageUrl}/${imageId}"  
				onload="tuneSizes(${imageId})"/>-->
				
			</div>

		</c:otherwise>
	</c:choose>
	
	<c:forEach items="${currQuestion.answers}" var="answer" varStatus="status">
		<div style="${currQuestion.hasFreeResponse ? 'display:true' : 'display:none'}">	
			${answer.intervention}
		</div>
	</c:forEach>
	
	<c:forEach items="${currQuestion.answers}" var="answer" varStatus="status">
      <div class="quizAnswer">
			<c:choose>
				<c:when test="${not answer.freeResponse}">
					 <label class="vbottom-nowrap" for="checkbox${status.index}">
						 <form:checkbox path="questions[${currQuestionNumber}].answers[${status.index}].selected" id="checkbox${status.index}" cssClass="chb"/>
						 ${answer.text}
					 </label>
				</c:when>
				<c:otherwise>
					<br><label class="vbottom-nowrap"> ${answer.text} </label><br>
				 	<form:textarea path="questions[${currQuestionNumber}].answers[${status.index}].studentFreeResponse" class="questionTextarea" />
				</c:otherwise>
			</c:choose>
      </div>
	</c:forEach>
<!-- 
		<c:if test="${currQuestionNumber > 0}">
			<input type="submit" value="Previous" name="prev" />
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		</c:if>
 -->
 	<c:if test="${!performQuiz.quiz}">
	  <c:if test="${not empty currQuestion.hint}">
	  	<input type="button" name="add" value="See Hint" class="button blue left" onclick="javascript:seeHint();"/> 
	  </c:if>
  	</c:if>
  
  <div class="red mt15">${error}</div>
 		
    <div class="controls">
		<input id="nextButton" type="submit" value="${nextBtnName}" name="next" class="button blue right"/>
    </div>
    </form:form>
	</div>
</div>
    
<c:if test="${!performQuiz.quiz}"> 
	<div id="idInterventionContent" style="display: none;background: #fff; padding: 20px 20px 40px; border: 1px solid #aaa;">
	<h1></h1>
		${intervention}
		<div>
			<a href="javascript:sendClose();" class="right button blue">Ok</a>
		</div>
	</div>
	
	<div id="idInterventionForm" style="display: none;">
		<form:form method="POST" action="${nextUrl}" modelAttribute="performQuiz">
		    <div class="controls">
				<input id="hiddenButton" type="submit" value="${nextBtnName}" name="leaveIntervention" class="button blue right"/>
		    </div>
		</form:form>
	</div>
</c:if>

<script>
$(".chb").each(function() {
	$(this).change(function() {
		$(".chb").attr('checked',false);
		$(this).attr('checked',true);
	});
});

function tuneSizes(imageId) {
	 $.ajax({
	        url: '/api/pdfRepo/imageRealSize',
	        type:'GET',
	        data: ({imageId : imageId}),
	    	dataType: "json",
	    	complete: function(transport){
	    		var data = transport.responseText;
	    		data = $.parseJSON(data);
	    		
	    		var realImageWidth = data[0];
	    		var realImageHeight = data[1];
	    		
	    		
	    		var width;
	    		var height;
	    		if(realImageWidth < 500) {
	    			width = realImageWidth;
	    			height = realImageHeight;
	    		
		    	
	    		} else {
	    			width = 500;
	    			height = (realImageHeight/realImageWidth) * 500;
	    			
	    		}
	    		
	    		$("#viewer").attr("width", width);
	    		$("#viewer").attr("height", height);
	    		
	    		$("#viewer").attr("position", "relative");
	    		$("#viewer").attr("border", "1px solid black");
	        }
	      });
}


$(document).ready(function(){
	<c:if test="${performQuiz.entryType == 1}">
		tuneSizes(${imageId});
		
	    var iv1 = $("#viewer").iviewer({
	         src: "${imageUrl}/${imageId}", 
	         update_on_resize: false,
	         zoom_animation: false,
	         mousewheel: false,
	         onMouseMove: function(ev, coords) { },
	         onStartDrag: function(ev, coords) { return true; }, //this image will not be dragged
	         onDrag: function(ev, coords) { }      
	    });
	</c:if>
	
	<c:if test="${!performQuiz.quiz}"> 
		<c:if test="${not empty intervention}">
			openInterventionPopUp();
		</c:if>
	</c:if>
});

function seeHint(){
	alert('${currQuestion.hint}');
	
	 $.ajax({
	        url: '/api/perform/hintSeen',
	        type:'GET',
	        data: ({studentId : ${loggedUser.id}, assignmentId : ${performQuiz.lessonAssignmentId}, quizId : ${performQuiz.id}, questionId : ${currQuestion.id}}),
	    	dataType: "json",
	    	complete: function(transport){
	    		var data = transport.responseText;
	    		data = $.parseJSON(data);
	    		
	        }
	      });
}

function openInterventionPopUp(){
	$('#nextButton').attr('disabled', 'disabled');
	$('#idInterventionContent').modal();
//	$('#idInterventionContent').show();
}

function sendClose(){
	$('#hiddenButton').click();
}
</script>

</body>
</html>