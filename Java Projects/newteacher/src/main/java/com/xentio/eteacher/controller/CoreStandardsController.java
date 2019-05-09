package com.xentio.eteacher.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xentio.eteacher.cs.CoreStandardsHelper;

@Controller
@RequestMapping("/cs")
public class CoreStandardsController {

    @RequestMapping(value = "/strands", method = RequestMethod.GET)
	public @ResponseBody
	String[] getPickerStrands(
			@RequestParam(value = "grade") String gradeParam,
			@RequestParam(value = "subject") String subjectParam) {
		return CoreStandardsHelper.getPickerStrands(gradeParam, subjectParam);
    }
    
    @RequestMapping(value = "/objectives", method = RequestMethod.GET)
	public @ResponseBody
	String[] getPickerObjectives(
			@RequestParam(value = "grade") String gradeParam,
			@RequestParam(value = "objective") String objectiveParam,
			@RequestParam(value="subject") String subjectParam) {
		return CoreStandardsHelper.getPickerObjectives(gradeParam, objectiveParam, subjectParam);
    }
    
}
