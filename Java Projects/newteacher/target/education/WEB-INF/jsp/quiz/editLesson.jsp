<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<link rel="stylesheet" type="text/css" href="../../css/main.css" />
	<link rel="stylesheet" type="text/css" href="../../css/buttons.css" />
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<script src="http://code.jquery.com/jquery-1.8.1.min.js"></script>
	<title>Quench</title>
</head>

<c:url var="saveUrl" value="/api/lessonEdit/start" />
<c:url var="ajaxPickPdfFileNames" value="/api/pdfRepo/pdfFileNames" />
<c:url var="ajaxPickPdfPages" value="/api/pdfRepo/pdfPages" />
<body>
	<%@include file="../header.jsp"%>
	<div class="innerWidth">
		<div class="page">
			<h1>
				<c:if test="${quiz.id <= 0}">Create </c:if>
				<c:if test="${quiz.id > 0}">Edit </c:if>
				Lesson
			</h1>
			<form:form method="POST" action="${saveUrl}" modelAttribute="quiz" enctype="multipart/form-data">

				<form:hidden path="id" />
				<form:hidden path="createTimeMlls" />
				
           		<div class="error" style="color:#ff0000; padding: 5px 0 0 10px">${quiz.error['grade']}</div>
           		<div class="error" style="color:#ff0000; padding: 5px 0 0 10px">${quiz.error['subject']}</div>
           		<div class="error" style="color:#ff0000; padding: 5px 0 0 10px">${quiz.error['strand']}</div>
           		<div class="error" style="color:#ff0000; padding: 5px 0 0 10px">${quiz.error['objective']}</div>
           		
				<%@include file="../quiz/objectivePicker.jsp"%>

				<table>
					<tr>
						<td><label>Lesson Name</label></td>
						<td><form:input path="quizName" class="lessonInput" /></td>
						<td><form:errors path="quizName" cssClass="error" element="div"/></td>
					</tr>
				</table>

				</br></br>


				<table>
					<tr>
						<td>
							<label>Instructions</label><br><br>
							<form:checkbox	path="instructionImage" cssClass="chbInstructionImage" label="As Image" />
						</td>
						<td>
							<div id="manualInstr" style="${quiz.instructionImage ? 'display:none' : 'display:true'}">
								<form:textarea path="description" class="questionTextarea" />
							</div>
							
							<div id="imageInstr" style="${quiz.instructionImage ? 'display:true' : 'display:none'}">
								<div id="imageInstrImage">									
									<c:import url = "../pdfImage.jsp">
										<c:param name = "prefix" value = "instrImage"/>
										<c:param name = "imageId" value = "${quiz.instrImage.imageId}"/>
										<c:param name = "pdfImageId" value = "${quiz.instrImage.pdfImageId}"/>
										<c:param name = "cropBtnLabel" value = "Create Instruction from Selection"/>
										<c:param name = "imageWidth" value = "400"/>
									</c:import>			
								</div>
								
								<div id="imageInstrText" style="${quiz.instructionImage ? 'display:none' : 'display:true'}">
									Please select a PDF file at bottom.
								</div>
												
							</div>
							
						</td>
					</tr>
				</table>
				
				
				</br></br>

				<table class="entryTypeTable">
					<tr>
						<td><label>Lesson Type</label></td>
						<td>
							<form:select path="entryType"  itemValue="entryType" style="width: 100px">
								<form:option value="0" label="Text" />
								<form:option value="1" label="Image" />
							</form:select>
						</td>
						<td><div id="pdfErrorId" class="error" style="color:#ff0000; padding: 5px 0 0 10px">${quiz.error['pdfError']}</div></td>
					</tr>
						
					<tr id="pdfTr" style="display:${quiz.entryType==0 ? 'none' : 'true'}">				
						<td><label>PDF File</label></td>
						<td>
							<form:select path="pdfType"  itemValue="pdfType" style="width: 150px">
								<form:option value="pull" label="Pull from Repository" />
								<form:option value="upload" label="Upload" />
							</form:select>
						</td>
						<td id="pullTd" style="display:${quiz.pdfType=='upload' ? 'none' : 'true'}">
							
							<form:select path="pdfId"  itemValue="pdfId"  style="width: 200px">
								<form:option value="0" label="--Select PDF File--" />
								<form:options items="${pdfFileNames}" />
							</form:select>
						</td>
					</tr>
				</table>
				
				<div id="uploadDiv" style="display:${quiz.entryType==0 || quiz.pdfType=='pull' ? 'none' : 'true'}">
					<div class="red mt15">${uploadError}</div>
					<div class="green mt15">${uploadSuccess}</div>
					<label>Upload PDF</label>
					<input type="file" name="file" /> 
					<input type="submit" value="Upload" name="uploadFile"  />
				</div>
				
				<div class="controls">
					<input type="submit" value="Next" name="addQuestion" class="button right" />
				</div>
			
			</form:form>
		</div>
</body>
</html>

<script>
$('input:checkbox[class=chbInstructionImage]').live('click',function(){
	var isImage = $(this).is(':checked');
	if(isImage) {
		$('#imageInstr').attr("style", "display:true");
		if($('#selectedPdfImageId option').size() > 0) {
			$('#imageInstrImage').attr("style", "display:true");
			$('#imageInstrText').attr("style", "display:none");
		} else {
			$('#imageInstrImage').attr("style", "display:none");
			$('#imageInstrText').attr("style", "display:true");
		}
		
		$('#manualInstr').attr("style", "display:none");
	} else {
		$('#imageInstr').attr("style", "display:none");
		$('#manualInstr').attr("style", "display:true");

	}
});

$('#entryType').change(function() {
	$('#pdfErrorId').text('');
	var typeVal = $('#entryType').val();

	if(typeVal == 0) {//text 
		$("#pdfTr").attr('style',"display:none");
		$("#uploadDiv").attr('style',"display:none");
		return;
	}
	
	$("#pdfTr").attr('style',"display:true");
	$('#pdfType').val("pull");
	
	
	 $.ajax({
	        url: '${ajaxPickPdfFileNames}',
	        type:'GET',
	    	dataType: "json",
	    	complete: function(transport){
	    		var data = transport.responseText;
	    		data = $.parseJSON(data);
	    		
	    		var listItems= "<option value='0'>--PDF File--</option>";
		   		for (var i = 0; i < data.length; i++){
			      listItems+= "<option value='" + data[i].id + "'>" + data[i].fileName + "</option>";
			    }
		   		
		   		$('#pdfId').html(listItems);
	        }

	      });
	});
	
$('#pdfType').change(function() {
	$('#pdfErrorId').text('');
	var pdfTypeVal = $('#pdfType').val();
	if(pdfTypeVal == 'upload') {
		$('#uploadDiv').attr("style", "display:true");
		$('#pullTd').attr("style", "display:none");
		$('#pdfId').val("0");
	} else {
		$('#uploadDiv').attr("style", "display:none");
		$('#pullTd').attr("style", "display:true");

	}
});


$('#pdfId').change(function() {
	var pdfIdVal = $('#pdfId').val();
	if(pdfIdVal > 0) {
		 $.ajax({
		        url: '${ajaxPickPdfPages}',
		        type:'GET',
		        data: ({pdfId : pdfIdVal}),
		    	dataType: "json",
		    	complete: function(transport){
		    		var data = transport.responseText;
		    		data = $.parseJSON(data);
		    		var listItems= "";
			   		for (var i = 0; i < data.length; i++){
				      listItems+= "<option value='" + data[i] + "'>Page " + (i + 1) + "</option>";
				    }
			   		
			   		$('#selectedPdfImageId').html(listItems);
			   		$('#dbImageDiv').html('<img id="dbImage" src="/api/pdfRepo/'+ data[0] + '" onload="tuneSizes(' + data[0] + ','+ 400 + ')">')

			   		$('#imageInstrImage').attr("style", "display:true");
					$('#imageInstrText').attr("style", "display:none");

		        }

		      });
	}
});

</script>	
