<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<c:url var="actionUrl" value="/api/lessonEdit/question" />
<c:set var="currQuestion" value="${quiz.questions[quiz.currentQuestionNumber]}"/>

<form:form method="POST" action="${actionUrl}" modelAttribute="quiz">
	<table>
		<tr>
			<td><label>Question</label></td>
			<td><form:textarea path="questions[${quiz.currentQuestionNumber}].text" class="questionTextarea" /></td>
			<td>
				<input type="submit" value="Delete Question" name="delete" class="button grey left" onclick="return confirm('Are you sure?')"/>
			</td>
			<td style="color:#ff0000; padding: 5px 0 0 10px">${quiz.questions[quiz.currentQuestionNumber].error}</td>
		</tr>
	</table>
	
	<table class="answers">
		<c:forEach	items="${quiz.questions[quiz.currentQuestionNumber].answers}" var="answer" varStatus="aStatus">
			<tr class="answer" id="a_${aStatus.index}">
				<td nowrap="nowrap"><label>Answer ${aStatus.index + 1}</label></td>
				<td><form:textarea id="answerTextArea" path="questions[${quiz.currentQuestionNumber}].answers[${aStatus.index}].text" class="answerTextarea" /></td>
				<td class="vbottom"><form:checkbox	path="questions[${quiz.currentQuestionNumber}].answers[${aStatus.index}].selected" cssClass="chb" /></td>
				<td class="vbottom" style="color:#808080;"><label for="questions${quiz.currentQuestionNumber}.answers${aStatus.index}.selected1">(correct answer)</label></td>
				<td class="vbottom">
					<a id="deleteBtn" href="javascript:deleteAnswer(${aStatus.index})">
		 				<img title="Delete Answer" src="../../images/delete.png" height="12px" />
		 				<!--  style="padding-left:8px; float:right; margin-top:25px"  />-->
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
		<a href="javascript:addAnswer(${quiz.currentQuestionNumber})" class="button grey small">Add Answer</a>
		<form:checkbox	path="questions[${quiz.currentQuestionNumber}].hasFreeResponse" cssClass="chbFreeResponse" label="Free Response" />
	</div>

	<label>Hint</label><form:textarea path="questions[${quiz.currentQuestionNumber}].hint" class="answerTextarea" />

	<div class="controls">
		<input type="submit" value="${quiz.currentQuestionNumber== 0 ? 'First Page' : 'Previous Question'}"  name="prev" class="button left"/>
	    <input type="submit" value="Finished" name="done" class="button grey right"/>
		<input type="submit" value="Next Question"  name="next" class="button right"/>
	</div>
</form:form>

<script>
function getAnswerHtml(q_num, a_num) {
	return '<tr class="answer" id="a_'+a_num+'"">' +
		'<td nowrap="nowrap"><label>Answer '+(a_num+1)+'</label></td>' +
		'<td><textarea id="questions'+q_num+'.answers'+a_num+'.text" name="questions['+q_num+'].answers['+a_num+'].text" class="answerTextarea" /></td>' +
		'<td class="vbottom"><input id="questions'+q_num+'.answers'+a_num+'.selected1" name="questions['+q_num+'].answers['+a_num+'].selected" type="checkbox" class="chb" value="true"/>' +
		'<input type="hidden" name="_questions['+q_num+'].answers['+a_num+'].selected" value="on"/></td>' +
		'<td class="vbottom" style="color:#808080;" nowrap="nowrap"><label for="questions' + q_num + '.answers' + a_num + '.selected1">(correct answer)</label></td>' +
		'<td><a id="deleteBtn" href="javascript:deleteAnswer(' + a_num + ')"> <img title="Delete Answer" src="../../images/delete.png" height="12px" style="float:right; margin-top:25px"  /></a> </td>' + 
		'</tr>'  +

		'<tr id="a_'+a_num+'_intervention">' +
		'<td style="vertical-align: middle;" height="50px;">Intervention:&nbsp;</td>' +
		'<td nowrap="nowrap" colspan="4" style="vertical-align: middle;"><input type="text" id="questions['+q_num+'].answers['+a_num+'].intervention" name="questions['+q_num+'].answers['+a_num+'].intervention" /></td>' +
		'</tr>' +
	
		'<input id="answerDeleted_' + a_num +' name="questions['+q_num+'].answers['+a_num+'].deleted" type="hidden" value="false"/>';
}

function addAnswer(q_num) {
	a_num = $('table.answers > tbody > tr.answer').size();
	$(getAnswerHtml(q_num, a_num)).fadeIn('slow').appendTo('.answers');
}

</script>

