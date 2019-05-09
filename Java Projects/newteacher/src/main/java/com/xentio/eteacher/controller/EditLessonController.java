package com.xentio.eteacher.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.xentio.eteacher.cs.CoreStandardsHelper;
import com.xentio.eteacher.domain.LessonImage;
import com.xentio.eteacher.domain.PdfFile;
import com.xentio.eteacher.domain.User;
import com.xentio.eteacher.domain.bean.AnswerBean;
import com.xentio.eteacher.domain.bean.CroppableImage;
import com.xentio.eteacher.domain.bean.QuestionBean;
import com.xentio.eteacher.domain.bean.QuizBean;
import com.xentio.eteacher.service.DraftService;
import com.xentio.eteacher.service.PdfRepoService;
import com.xentio.eteacher.service.QuizService;
import com.xentio.eteacher.service.StudentService;

@Controller
@RequestMapping("/lessonEdit")
@SessionAttributes({"user", "quiz"})
public class EditLessonController {
	
	@Autowired
	private QuizService quizService;

	@Autowired
	private StudentService studentService;
	
	@Autowired
	private DraftService draftService;
	
	@Autowired
	private PdfRepoService pdfRepoService;

	
	@ModelAttribute("user")
	public User createUser() {
		UserDetails userDetails = (UserDetails) SecurityContextHolder
				.getContext().getAuthentication().getPrincipal();
		User user = studentService.searchByUsername(userDetails.getUsername());
		return user;
	}
	
	@RequestMapping(value = "/start", method = RequestMethod.GET)
    public String getCreate(Model model, ModelMap modelMap) {
    	CoreStandardsHelper.setGrades(model);
    	User user = (User)modelMap.get("user");
		
    	//Quiz lastBean = quizService.getLastUserQuiz(user.getId());
    	
    	QuizBean quizBean = new QuizBean();
    	quizBean.setCreateTimeMlls(System.currentTimeMillis());
    	quizBean.setCreatorId(user.getId());
    	
    	/*if(lastBean != null)
    	{
    		quizBean.setGrade(lastBean.getGrade());
    		quizBean.setObjective(lastBean.getObjective());
    		quizBean.setStrand(lastBean.getStrand());
    		quizBean.setSubject(lastBean.getSubject());
    		CoreStandardsHelper.setObjectivePicker(model, quizBean);
    	}
    	*/
    	model.addAttribute("quiz", quizBean);

    	return "quiz/editLesson";
	}
    
    @RequestMapping(value = "/start", method = RequestMethod.POST, params="addQuestion")
   	public String postCreate(@Valid @ModelAttribute("quiz") QuizBean quiz, BindingResult result, Model model) {
    	if(result.hasErrors() || !quiz.validateCreate()) {
        	if(quiz.getEntryType() == QuizBean.IMAGE_TYPE) {
        		model.addAttribute("pdfFileNames", fromListToMap(pdfRepoService.getPdfFiles()));
        	}
    		CoreStandardsHelper.setObjectivePicker(model, quiz);
    		return "quiz/editLesson";
    	}

    	List<Long> pdfImageIds = pdfRepoService.getPdfPages(quiz.getPdfId());
    	quiz.setPdfImageIds(pdfImageIds);

    	if(quiz.getQuestions().isEmpty()) {
    		quiz.getQuestions().add(defaultQuestion(quiz));
    	} else if(quiz.getEntryType() != quiz.getOldEntryType() || quiz.getPdfId() != quiz.getOldfPdfId()) {
			//changed entry type or pdf file -> clear questions till now
			quiz.getQuestions().clear();
			quiz.getQuestions().add(defaultQuestion(quiz));    			
    	}
    	
    	if(quiz.getId() == 0) {
    		draftService.updateDraftQuiz(quiz);
    	}
    	
       	return "quiz/editQuestion";
    }
    
    @RequestMapping(value = "/question", method = RequestMethod.POST, params="prev")
    public String postPrev(@ModelAttribute("quiz") QuizBean quiz, Model model) {
    	//if this is first question, go to start create page
    	if(quiz.getCurrentQuestionNumber() == 0) {
       		CoreStandardsHelper.setObjectivePicker(model, quiz);

       		if(quiz.getEntryType() == QuizBean.IMAGE_TYPE) {
       			model.addAttribute("pdfFileNames", fromListToMap(pdfRepoService.getPdfFiles()));
        	}
       		quiz.setOldEntryType(quiz.getEntryType());
       		quiz.setOldfPdfId(quiz.getPdfId());

       		return "quiz/editLesson";
    	}
    	
    	quiz.setCurrentQuestionNumber(quiz.getCurrentQuestionNumber() - 1);
    	return "quiz/editQuestion";
	}

    @RequestMapping(value = "/question", method = RequestMethod.POST, params="next")
    public String postNext(@ModelAttribute("quiz") QuizBean quiz, Model model) {
    	QuestionBean question = quiz.getQuestions().get(quiz.getCurrentQuestionNumber());
    	//validate input data
    	if(!question.validateCreate(quiz.getEntryType())) {

    		return "quiz/editQuestion";
    	}
		
		//set next question 
		if(quiz.getCurrentQuestionNumber() >= quiz.getQuestions().size() - 1) {
			quiz.getQuestions().add(defaultQuestion(quiz));
		}
		
		quiz.setCurrentQuestionNumber(quiz.getCurrentQuestionNumber() + 1);
		
		if(quiz.getId() == 0) {
			draftService.updateDraftQuiz(quiz);
		}
    	return "quiz/editQuestion";
	}
    
    @RequestMapping(value = "/question", method = RequestMethod.POST, params="done")
    public String postDone(@ModelAttribute("quiz") QuizBean quiz, Model model) {
    	QuestionBean question = quiz.getQuestions().get(quiz.getCurrentQuestionNumber());
    	
    	//validate input data
    	if(!question.validateCreate(quiz.getEntryType())) {
    		return "quiz/editQuestion";
    	}
    	
    	//set free responses
    	for(QuestionBean questionBean : quiz.getQuestions()) {
    		if(questionBean.isHasFreeResponse()) {
    			AnswerBean freeResponseAnswer = new AnswerBean();
    			freeResponseAnswer.setText(questionBean.getFreeResponsePrompt());
    			freeResponseAnswer.setFreeResponse(true);
    			freeResponseAnswer.setSelected(false);
    			questionBean.getAnswers().add(freeResponseAnswer);
    		}
    	}
    	
		quizService.updateQuiz(quiz);
		
		if(quiz.getId() == 0) {
			draftService.deleteDraft(quiz.getCreateTimeMlls());
		}
    	return "quiz/addedQuiz";
	}
    
    @RequestMapping(value = "/question", method = RequestMethod.POST, params="delete")
    public String deleteQuestion(Model model, @ModelAttribute("quiz") QuizBean quiz) {
		List<QuestionBean> questions = quiz.getQuestions();
		if(questions.size() > quiz.getCurrentQuestionNumber()) {
			questions.remove(quiz.getCurrentQuestionNumber());

			if(quiz.getId() == 0) {
				draftService.updateDraftQuiz(quiz);
			}
		}
		
		if(quiz.getCurrentQuestionNumber() == 0) {
       		CoreStandardsHelper.setObjectivePicker(model, quiz);
       		quiz.setOldEntryType(quiz.getEntryType());
       		quiz.setOldfPdfId(quiz.getPdfId());

       		return "quiz/editLesson";
		} else {
			quiz.setCurrentQuestionNumber(quiz.getCurrentQuestionNumber() - 1);
	    	return "quiz/editQuestion";
		}
	}

    @RequestMapping(value = "/question", method = RequestMethod.POST, params="crop")
    public String handleCrop(Model model, @ModelAttribute("quiz") QuizBean quiz) {
    	QuestionBean question = quiz.getQuestions().get(quiz.getCurrentQuestionNumber());
    	
    	long imageId = question.getImage().getCroppedImageIdIfExists();
   		LessonImage image = pdfRepoService.getImage(imageId);
    	
    	try {
			byte[] croppedContent = PdfRepoService.doCrop(image.getContent(),
					question.getImage().getCropLeft(), question.getImage().getCropTop(),
					question.getImage().getCropWidth(), question.getImage().getCropHeight());
			
			LessonImage lessonImage = new LessonImage();
			lessonImage.setContent(croppedContent);
			lessonImage.setModifyTime(new Date());
			lessonImage.setIsCropped(true);
			pdfRepoService.update(lessonImage);
			
	    	question.getImage().setImageId(lessonImage.getId());
	    	
		} catch (IOException e) {
			e.printStackTrace();
		}
    		
    	return "quiz/editQuestion";
    }

    @RequestMapping(value = "/start", method = RequestMethod.POST, params="crop")
    public String handleCropAtStartPage(Model model, @ModelAttribute("quiz") QuizBean quiz) {
    	CroppableImage instrImage = quiz.getInstrImage();
    	long imageId = instrImage.getCroppedImageIdIfExists();
   		LessonImage image = pdfRepoService.getImage(imageId);
    	
    	try {
			byte[] croppedContent = PdfRepoService.doCrop(image.getContent(),
					instrImage.getCropLeft(), instrImage.getCropTop(),
					instrImage.getCropWidth(), instrImage.getCropHeight());
			
			LessonImage lessonImage = new LessonImage();
			lessonImage.setContent(croppedContent);
			lessonImage.setModifyTime(new Date());
			lessonImage.setIsCropped(true);
			pdfRepoService.update(lessonImage);
			
			instrImage.setImageId(lessonImage.getId());
	    	
		} catch (IOException e) {
			e.printStackTrace();
		}
    	
    	//set selected pdfPages
    	List<Long> pdfImageIds = pdfRepoService.getPdfPages(quiz.getPdfId());
    	quiz.setPdfImageIds(pdfImageIds);
    	
    	//need to reaload pdfs
    	model.addAttribute("pdfFileNames", fromListToMap(pdfRepoService.getPdfFiles()));

    	//set objective pickers 
    	CoreStandardsHelper.setObjectivePicker(model, quiz);
    	
    	return "quiz/editLesson";
    }

    
    @RequestMapping(value = "/edit", method = RequestMethod.GET)
    public String getEdit(@RequestParam(value="id", required=true) Integer id, Model model, ModelMap modelMap) {
    	QuizBean quiz = quizService.getQuizBean(id, true);
    	model.addAttribute("quiz", quiz);
    	CoreStandardsHelper.setObjectivePicker(model, quiz);
    	
    	
    	User user = (User)modelMap.get("user");
    	if(quiz.getCreatorId() != user.getId()) {
    		//editing another user's lesson - clone it
    		quiz.setCreatorId(user.getId());
    		quiz.setId(0);
    		for(QuestionBean question : quiz.getQuestions()) {
    			question.setId(0);
    			for(AnswerBean answer : question.getAnswers()) {
    				answer.setId(0);
    			}
    		}
    	}
    	
    	
   		if(quiz.getEntryType() == QuizBean.IMAGE_TYPE) {
        	model.addAttribute("pdfFileNames", fromListToMap(pdfRepoService.getPdfFiles()));
        	//set selected pdfPages
        	List<Long> pdfImageIds = pdfRepoService.getPdfPages(quiz.getPdfId());
        	quiz.setPdfImageIds(pdfImageIds);

    	}

   		quiz.setOldEntryType(quiz.getEntryType());
   		quiz.setOldfPdfId(quiz.getPdfId());
   		
    	return "quiz/editLesson";
	}
	
    @RequestMapping(value = "/start", method = RequestMethod.POST, params="uploadFile")
   	public String postUpload(@ModelAttribute("quiz") QuizBean quiz, @RequestParam("file") MultipartFile file, Model model) {
		CoreStandardsHelper.setObjectivePicker(model, quiz);
    	
		quiz.getError().clear();
		
    	if(file.isEmpty()) {
    		model.addAttribute("pdfFileNames", fromListToMap(pdfRepoService.getPdfFiles()));
    		model.addAttribute("uploadError", "No file selected!");
    		return "quiz/editLesson";
    	}
    	
        try {
	    	if (file.getContentType() == null || !file.getContentType().startsWith("application/pdf")) {
	    		model.addAttribute("pdfFileNames", fromListToMap(pdfRepoService.getPdfFiles()));
	    		model.addAttribute("uploadError", "Please select a PDF file!");
	    		return "quiz/editLesson";
	    	}

	    	if(file.getBytes().length > 5242880) {
	    		model.addAttribute("pdfFileNames", fromListToMap(pdfRepoService.getPdfFiles()));
	    		model.addAttribute("uploadError", "Please upload an file of size < 5MB.");
	    		return "quiz/editLesson";
	    	}
	    	
	    	long pdfFileId = pdfRepoService.uploadPDF(file.getOriginalFilename(), file.getBytes());
        	quiz.setPdfId(pdfFileId);//set uplloaded pdf file as selected
        	quiz.setPdfType("pull");
        	
        	//set selected pdfPages
        	List<Long> pdfImageIds = pdfRepoService.getPdfPages(quiz.getPdfId());
        	quiz.setPdfImageIds(pdfImageIds);

        	//set default instruction image as first from pdfPages
        	CroppableImage croppable = new CroppableImage();
        	croppable.setPdfImageId(!pdfImageIds.isEmpty() ? pdfImageIds.get(0) : 0);
        	quiz.setInstrImage(croppable);
        	
	    	model.addAttribute("pdfFileNames", fromListToMap(pdfRepoService.getPdfFiles()));//need to reaload pdfs
		} catch (Exception e) {
			e.printStackTrace();
			
			model.addAttribute("uploadError", "An unexpected error has occured. Please try again!");
    		return "quiz/editLesson";
		}
    	
       	return "quiz/editLesson";
    }
    
    private QuestionBean defaultQuestion(QuizBean quizBean) {
		List<AnswerBean> answerBeans = new ArrayList<AnswerBean>();
		for (int i = 0; i < 4; i++) {
			answerBeans.add(new AnswerBean());
		}
		QuestionBean questionBean = new QuestionBean();
		questionBean.setAnswers(answerBeans);
		
		if(quizBean.getEntryType() == QuizBean.IMAGE_TYPE) {
			//set selected pdf page to be the first page
			questionBean.getImage().setPdfImageId(quizBean.getPdfImageIds().get(0));
			if(!quizBean.getQuestions().isEmpty()) {
				QuestionBean currQuestion = quizBean.getQuestions().get(quizBean.getCurrentQuestionNumber());
				if(currQuestion.getImage() != null && currQuestion.getImage().getPdfImageId() > 0) {
					// set selected pdf page to be previous selected pdf page
					questionBean.getImage().setPdfImageId(currQuestion.getImage().getPdfImageId());
				}
			}
		}
		
		return questionBean;
	}
	
	private Map<String, String> fromListToMap(List<PdfFile> list) {
		Map<String, String> classes = new LinkedHashMap<String, String>();
    	for (PdfFile file : list) {
    		classes.put(file.getId().toString(), file.getFileName());
		}
		return classes;
	}
	
    /*    
    @RequestMapping(value = "/questionType", method = RequestMethod.GET)
    public String getQuestionByType(Model model,
    		@RequestParam(value="id", required=true) int id,
    		@RequestParam(value="type", required=true) int type,
    		@RequestParam(value="lessonCreateTimeMlls", required=true) long lessonCreateTimeMlls, 
    		@RequestParam(value="currentNumber", required=true) int currentNumber) {
    	
    	return type == QuizBean.MANUAL_TYPE ? "quiz/editManualQuestion" : "quiz/editImageQuestion";
	}
*/    

}
