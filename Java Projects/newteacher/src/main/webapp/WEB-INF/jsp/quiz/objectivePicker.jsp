<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<c:url var="ajaxPickStrandsUrl" value="/api/cs/strands" />
<c:url var="ajaxPickObjectivesUrl" value="/api/cs/objectives" />
<table class="objectiveTable">
	<tr>
		<td><label>Grade</label></td>
		<td><label>Subject</label></td>
		<td><label>Strand</label></td>
		<td><label>Objective</label></td>
	</tr>
	<tr>
		<td>
			<form:select path="grade" itemValue="grade" cssStyle="width: 100px">
				<form:option value="-1" label="--Grade--" />
				<form:options items="${grades}" />
			</form:select>
		</td>
		<td>
			<form:select path="subject"  itemValue="subject" disabled="${not enableSubject}" cssStyle="width: 100px">
				<form:option value="-1" label="--Subject--" />
				<form:option value="math" label="Math" />
				<form:option value="literacy" label="Literacy" />
			</form:select>
		</td>
		
		<td>
			<form:select path="strand"  itemValue="strand" disabled="${not enableStrand}" cssStyle="width: 200px">
				<form:option value="-1" label="--Strand--" />
				<form:options items="${strands}" />
			</form:select>
		</td>
		<td>
			<form:select path="objective" itemValue="objective" disabled="${not enableObjective}" cssStyle="width: 100px">
				<form:option value="-1" label="--Objective--"/>
				<form:options items="${objectives}" />
			</form:select>
		</td>
	</tr>
</table>


<script>
	$('#grade').change(function() {
		var gradeVal = $('#grade').val();

		$('#objective').html("<option value='-1'>--Objective--</option>");
		$("#objective").attr('disabled',true);
	
		$('#strand').html("<option value='-1'>--Strand--</option>");
		$("#strand").attr('disabled',true);

		$('#subject').val('-1')
		if(gradeVal == -1) {
			$("#subject").attr('disabled',true);
		} else {
            $("#subject").removeAttr('disabled');
		}

		});

	$('#subject').change(function() {
		var subjectVal = $('#subject').val();
		var gradeVal = $('#grade').val();
		
		$('#objective').html("<option value='-1'>--Objective--</option>");
		$("#objective").attr('disabled',true);
	
		if(subjectVal == -1) {
			$('#strand').html("<option value='-1'>--Strand--</option>");
			$("#strand").attr('disabled',true);
			
			return;
		}
		
		 $.ajax({
		        url: '${ajaxPickStrandsUrl}',
		        type:'GET',
		        data: ({grade : gradeVal, subject : subjectVal}),
		    	dataType: "json",
		    	complete: function(transport){
		    		var data = transport.responseText;
		    		data = $.parseJSON(data);
		    		var listItems= "<option value='-1'>--Strand--</option>";
			   		for (var i = 0; i < data.length; i++){
				      listItems+= "<option value='" + data[i] + "'>" + data[i] + "</option>";
				    }
			   		
			   		$('#strand').html(listItems);
		            $("#strand").removeAttr('disabled');
	
		        }
	
		      });
		});
	
	$('#strand').change(function() {
		var subjectVal = $('#subject').val();
		var strandVal = $('#strand').val();
		var gradeVal = $('#grade').val();
	
		if(strandVal == -1) {
			$('#objective').html("<option value='-1'>--Objective--</option>");
			$("#objective").attr('disabled',true);
			return;
		}
		
		 $.ajax({
		        url: '${ajaxPickObjectivesUrl}',
		        type:'GET',
		        data: ({objective : strandVal, grade : gradeVal, subject: subjectVal}),
		    	dataType: "json",
		    	complete: function(transport){
		    		var data = transport.responseText;
		    		data = $.parseJSON(data);
		    		var listItems= "<option value='-1'>--Objective--</option>";
			   		for (var i = 0; i < data.length; i++){
				      listItems+= "<option value='" + data[i] + "'>" + data[i] + "</option>";
				    }
			   		
			   		$('#objective').html(listItems);
		            $("#objective").removeAttr('disabled');
	
		        }
	
		      });
		});
</script>
