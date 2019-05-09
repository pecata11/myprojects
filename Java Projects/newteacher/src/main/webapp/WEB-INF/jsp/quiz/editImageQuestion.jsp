<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<style>
.chb {
    -webkit-appearance: radio;
    -moz-appearance: radio;
    -ms-appearance: radio;   
    -o-appearance: radio;  
      vertical-align: top;
}
</style>
<c:url var="actionUrl" value="/api/lessonEdit/question" />
<c:set var="currQuestion" value="${quiz.questions[quiz.currentQuestionNumber]}"/>

<form:form method="POST" action="${actionUrl}" modelAttribute="quiz">

<table>
	<tr>
		<td>      
			<c:import url = "../pdfImage.jsp">
				<c:param name = "prefix" value = "questions[${quiz.currentQuestionNumber}].image"/>
				<c:param name = "error" value = "${quiz.questions[quiz.currentQuestionNumber].error}"/>
				<c:param name = "imageId" value = "${quiz.questions[quiz.currentQuestionNumber].image.imageId}"/>
				<c:param name = "pdfImageId" value = "${quiz.questions[quiz.currentQuestionNumber].image.pdfImageId}"/>
				<c:param name = "cropBtnLabel" value = "Create Question from Selection"/>
				<c:param name = "imageWidth" value = "500"/>
			</c:import>
		</td>
	</tr>
	<tr>
		<td>
				<table class="answers">
				<tr><td style="color:#ff0000; padding: 5px 0 0 10px">${question.error}</td></tr>
				<tr><td><input type="submit" value="Delete Question" name="delete" class="button grey left" onclick="return confirm('Are you sure?')"/></td></tr>
				<c:forEach	items="${quiz.questions[quiz.currentQuestionNumber].answers}" var="answer" varStatus="aStatus">
					<tr class="answer" id="a_${aStatus.index}">
						<td class="vbottom"><form:checkbox	path="questions[${quiz.currentQuestionNumber}].answers[${aStatus.index}].selected" cssClass="chb" /></td>
						<td><form:textarea	path="questions[${quiz.currentQuestionNumber}].answers[${aStatus.index}].text" class="imageAnswerTextarea" /></td>
						<td>
							<a id="deleteBtn" href="javascript:deleteAnswer(${aStatus.index})">
				 				<img title="Delete Answer" src="../../images/delete.png" height="12px" style="padding-left:8px; float:right; "  />
				  			</a>
						</td>
					</tr>
					<tr id="a_${aStatus.index}_intervention">
						<td style="vertical-align: middle;" height="50px;">Explanation:&nbsp;</td>
						<td nowrap="nowrap" colspan="4" style="vertical-align: middle;"><form:input path="questions[${quiz.currentQuestionNumber}].answers[${aStatus.index}].intervention" cssClass="fullWidth"/></td>
					</tr>
					<form:hidden id="answerDeleted_${aStatus.index}" path="questions[${quiz.currentQuestionNumber}].answers[${aStatus.index}].deleted"/>
				</c:forEach>
				</table>
				
				<div id="freeResponse" style="${currQuestion.hasFreeResponse ? 'display:true' : 'display:none'}">	
					<table class="freeResponse">
						<tr class="freeResponse">
							<td nowrap="nowrap"><label>Response Prompt</label></td>
							<td><form:textarea path="questions[${quiz.currentQuestionNumber}].freeResponsePrompt" class="questionTextarea" /></td>
						</tr>
					</table>
				</div>
				
				
				<div class="row mt15">
					<a id="addBtn" href="javascript:addAnswer(${quiz.currentQuestionNumber})"><img title="Add Answer" src="../../images/add.png" height="18px" /></a>
					<form:checkbox	path="questions[${quiz.currentQuestionNumber}].hasFreeResponse" cssClass="chbFreeResponse" label="Free Response" />
				</div>
				
				<label>Hint</label><form:textarea path="questions[${quiz.currentQuestionNumber}].hint" class="answerTextarea" />
				
				<div class="controls">
					<input type="submit" value="${quiz.currentQuestionNumber == 0 ? 'First Page' : 'Previous Question'}"  name="prev" class="button left"/>
				    <input type="submit" value="Finished" name="done" class="button grey right"/>
					<input type="submit" value="Next Question"  name="next" class="button right"/>
				</div>
		</td>
	</tr>		
</table>
</form:form>

<script>
function getImageAnswerHtml(q_num, a_num) {
	return	'<tr class="answer" id="a_'+ a_num + '">' +
		'<td class="vbottom"><input id="questions'+q_num+'.answers'+a_num+'.selected1" name="questions['+q_num+'].answers['+a_num+'].selected" type="checkbox" class="chb" value="true"/>' +
		'<input type="hidden" name="_questions['+q_num+'].answers['+a_num+'].selected" value="on"/></td>' +
		'<td nowrap="nowrap"><textarea id="questions'+q_num+'.answers'+a_num+'.text" name="questions['+q_num+'].answers['+a_num+'].text" class="imageAnswerTextarea"></textarea></td>' +
		'<td><a id="deleteBtn" href="javascript:deleteAnswer(' + q_num + ', ' + a_num + ')"> <img title="Delete Answer" src="../../images/delete.png" height="12px" style="padding-left:8px; float:right;"  /></a> </td>' + 
	'</tr>' +

	'<tr id="a_'+a_num+'_intervention">' +
	'<td style="vertical-align: middle;" height="50px;">Intervention:&nbsp;</td>' +
	'<td nowrap="nowrap" colspan="4" style="vertical-align: middle;"><input type="text" id="questions['+q_num+'].answers['+a_num+'].intervention" name="questions['+q_num+'].answers['+a_num+'].intervention" /></td>' +
	'</tr>' +

	'<input id="answerDeleted_' + a_num +' name="questions['+q_num+'].answers['+a_num+'].deleted" type="hidden" value="false"/>';
}

function addAnswer(q_num) {
	a_num = $('table.answers > tbody > tr.answer').size();
	$(getImageAnswerHtml(q_num, a_num)).fadeIn('slow').appendTo('.answers');
}
</script>
