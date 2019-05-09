package com.xentio.eteacher.controller;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import com.xentio.eteacher.cs.CoreStandardsHelper;
import com.xentio.eteacher.domain.PdfFile;
import com.xentio.eteacher.domain.bean.QuizBean;
import com.xentio.eteacher.service.DraftService;
import com.xentio.eteacher.service.PdfRepoService;

@Controller
@RequestMapping("/draft")
@SessionAttributes({"quiz"})
public class DraftController {
	
	@Autowired
	private DraftService draftService;

	@Autowired
	private PdfRepoService pdfRepoService;

    @RequestMapping(value = "/autosave", method = RequestMethod.POST)
	public String autoSaveQuiz(@ModelAttribute("quiz") QuizBean quiz) {
    	
    	draftService.updateDraftQuiz(quiz);

    	return "quiz/draftLesson";
    }
    
    
    @RequestMapping(value = "/complete", method = RequestMethod.GET)
    public String complete(@RequestParam(value="id", required=true) Long id, Model model) {
    	
		QuizBean quiz = draftService.getDraftQuiz(id);
   		quiz.setOldEntryType(quiz.getEntryType());
   		quiz.setOldfPdfId(quiz.getPdfId());
   		quiz.setCurrentQuestionNumber(0);
   		
    	if(quiz.getEntryType() == QuizBean.IMAGE_TYPE) {
    		model.addAttribute("pdfFileNames", fromListToMap(pdfRepoService.getPdfFiles()));
    	}
   		
   		CoreStandardsHelper.setObjectivePicker(model, quiz);		
    	model.addAttribute("quiz", quiz);
    	
    	return "quiz/editLesson";
	}
  
	private Map<String, String> fromListToMap(List<PdfFile> list) {
		Map<String, String> classes = new LinkedHashMap<String, String>();
    	for (PdfFile file : list) {
    		classes.put(file.getId().toString(), file.getFileName());
		}
		return classes;
	}
    
    @RequestMapping(value = "/delete", method = RequestMethod.GET)
    public String delete(@RequestParam(value="id", required=true) Long id) {
    	
    	draftService.deleteDraft(id);
    	
    	return "redirect:/api/quizzes/list";
	}

}
