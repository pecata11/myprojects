<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<link rel="stylesheet" href="../../css/jquery.Jcrop.css" type="text/css" />
<script src="http://code.jquery.com/jquery-1.8.1.min.js"></script>
<script src="../../script/jquery.Jcrop.min.js"></script>

<c:url var="pdfImageUrl" value="/api/pdfRepo" />
<c:url var="ajaxPickImageRealSize" value="/api/pdfRepo/imageRealSize" />



<div class="red mt15">${param.error}</div>

<form:select id="selectedPdfImageId" path="${param.prefix}.pdfImageId"  itemValue="${param.prefix}.pdfImageId" >
	<c:forEach	items="${quiz.pdfImageIds}" var="pdfImageId" varStatus="status">
		<form:option value="${pdfImageId}" label="Page ${status.index + 1}" />
	</c:forEach>
</form:select>

 
<div id="dbImageDiv">
	<c:set var="imageId" value="${param.imageId > 0 ? param.imageId : param.pdfImageId}"/>
	<img id="dbImage" src="${pdfImageUrl}/${imageId}" onload="tuneSizes(${imageId},${param.imageWidth})"/>
</div>

<form:hidden id="imageId" path="${param.prefix}.imageId"/>
<form:hidden id="pdfImageId" path="${param.prefix}.pdfImageId"/>
<form:hidden id="cropLeft" path="${param.prefix}.cropLeft"/>
<form:hidden id="cropTop" path="${param.prefix}.cropTop"/>
<form:hidden id="cropWidth" path="${param.prefix}.cropWidth"/>
<form:hidden id="cropHeight" path="${param.prefix}.cropHeight"/>

<input type="submit" value="${param.cropBtnLabel}" name="crop" disabled="true" id="cropBtnId" />
	
<script>

$('#selectedPdfImageId').change(function() {
	var pdfImageId = $("#selectedPdfImageId").val();
	$("#dbImageDiv").html('<img id="dbImage" src="${pdfImageUrl}/' + pdfImageId + '" onload="tuneSizes('+ pdfImageId + ',' + ${param.imageWidth} + ')"/>')
	
	$('input[id="pdfImageId"]').attr("value", pdfImageId);
	$('input[id="imageId"]').attr("value", 0);
});


function tuneSizes(imageId, imageWidth) {
	if(!imageWidth) {
		imageWidth=500;
	}
	 $.ajax({
	        url: '${ajaxPickImageRealSize}',
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
	    		if(realImageWidth < imageWidth) {
	    			width = realImageWidth;
	    			height = realImageHeight;
	    		} else {
	    			width = imageWidth;
	    			height = (realImageHeight/realImageWidth) * imageWidth;
	    		}
	    		
	    		$('img[id="dbImage"]').attr("width", width);
	    		$('img[id="dbImage"]').attr("height", height);
	    		
	    		$('#dbImage').Jcrop({
	    			onSelect : changeCoords,
	    			onRelease : released,
	    			trueSize: [realImageWidth,realImageHeight]
	    		});
	        }
	
	      });
}
function changeCoords(c) {
	$('#cropBtnId').attr("disabled", false);
	$('input[id="cropLeft"]').attr("value", c.x);
	$('input[id="cropTop"]').attr("value", c.y);
	$('input[id="cropWidth"]').attr("value", c.w);
	$('input[id="cropHeight"]').attr("value", c.h);

};

function released() {
	$('#cropBtnId').attr("disabled", true);
};

</script>