package com.xentio.eteacher.domain.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.hibernate.validator.constraints.NotBlank;


public class QuizBean {
	public static final int MANUAL_TYPE = 0;
	public static final int IMAGE_TYPE = 1;

	private int id;
	
	@NotBlank
	private String quizName;
	private int creatorId;
	private String grade;
	private String subject;
	private String strand;
	private String objective;
	private String description;

	private int currentQuestionNumber;
	private long createTimeMlls;
	private int entryType;
	private long pdfId;
	private String pdfType;
	private int oldEntryType;
	private long oldfPdfId;

	
	private List<Long> pdfImageIds = new ArrayList<Long>();
	
	private List<QuestionBean> questions = new ArrayList<QuestionBean>();
	private Map<String, String> error = new HashMap<String, String>();

	private boolean isQuiz;
	private Integer lessonAssignmentId;
	
	private boolean isInstructionImage;
	private CroppableImage instrImage;
	
	private boolean isProofRead = true;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getCreatorId() {
		return creatorId;
	}

	public void setCreatorId(int creatorId) {
		this.creatorId = creatorId;
	}

	public String getQuizName() {
		return quizName;
	}

	public void setQuizName(String quizName) {
		this.quizName = quizName;
	}

	public List<QuestionBean> getQuestions() {
		return questions;
	}

	public void setQuestions(List<QuestionBean> questions) {
		this.questions = questions;
	}

	public List<Long> getPdfImageIds() {
		return pdfImageIds;
	}

	public void setPdfImageIds(List<Long> pdfImageIds) {
		this.pdfImageIds = pdfImageIds;
	}

	public int getCurrentQuestionNumber() {
		return currentQuestionNumber;
	}

	public void setCurrentQuestionNumber(int currentQuestionNumber) {
		this.currentQuestionNumber = currentQuestionNumber;
	}

	public Map<String, String> getError() {
		return error;
	}

	public void setError(Map<String, String> error) {
		this.error = error;
	}

	public String getGrade() {
		return grade;
	}

	public String getSubject() {
		return subject;
	}

	public void setSubject(String subject) {
		this.subject = subject;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getStrand() {
		return strand;
	}

	public void setStrand(String strand) {
		this.strand = strand;
	}

	public String getObjective() {
		return objective;
	}

	public void setObjective(String objective) {
		this.objective = objective;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public long getCreateTimeMlls() {
		return createTimeMlls;
	}

	public void setCreateTimeMlls(long createTimeMlls) {
		this.createTimeMlls = createTimeMlls;
	}

	public int getEntryType() {
		return entryType;
	}

	public void setEntryType(int entryType) {
		this.entryType = entryType;
	}

	public long getPdfId() {
		return pdfId;
	}

	public boolean isQuiz() {
		return isQuiz;
	}

	public void setQuiz(boolean isQuiz) {
		this.isQuiz = isQuiz;
	}

	public boolean isInstructionImage() {
		return isInstructionImage;
	}

	public void setInstructionImage(boolean isInstructionImage) {
		this.isInstructionImage = isInstructionImage;
	}

	public CroppableImage getInstrImage() {
		return instrImage;
	}

	public void setInstrImage(CroppableImage instrImage) {
		this.instrImage = instrImage;
	}

	public void setPdfId(long pdfId) {
		this.pdfId = pdfId;
	}

	public String getPdfType() {
		return pdfType;
	}

	public void setPdfType(String pdfType) {
		this.pdfType = pdfType;
	}

	public int getOldEntryType() {
		return oldEntryType;
	}

	public void setOldEntryType(int oldEntryType) {
		this.oldEntryType = oldEntryType;
	}

	public long getOldfPdfId() {
		return oldfPdfId;
	}

	public void setOldfPdfId(long oldfPdfId) {
		this.oldfPdfId = oldfPdfId;
	}
	
	public boolean isProofRead() {
		return isProofRead;
	}

	public void setProofRead(boolean isProofRead) {
		this.isProofRead = isProofRead;
	}

	public boolean validateCreate() {
		error.clear();
		boolean hasErrors = false;

		if(getEntryType() == QuizBean.IMAGE_TYPE && pdfId == 0) 
		{
			error.put("pdfError","Please Select a PDF file");
			hasErrors = true;
		}
		
		if (StringUtils.isBlank(quizName)) {
			error.put("quizName","Please Enter a Lesson Name");
			hasErrors = true;
		}
		

		int gradeInt = Integer.parseInt(grade);
		if(gradeInt == -1){
			error.put("grade","Please choose a grade.");
			hasErrors = true;
		}
		
		if(subject != null){
			if(subject.equals("-1")){
				error.put("subject","Please choose a subject.");
				hasErrors = true;
			}
		}
		if(strand != null){
			if(strand.equals("-1")){
				error.put("strand","Please choose a strand.");
				hasErrors = true;
			}
		}
		
		if(objective != null){
			if(objective.equals("-1")){
				error.put("objective","Please choose an objective.");
				hasErrors = true;
			}
		}
		
		return !hasErrors;
	}
	
	public String toString() {
		StringBuffer strBuf = new StringBuffer();
		strBuf.append("\ncreateTimeMlls = " + createTimeMlls);
		strBuf.append("\nid = " + id);
		strBuf.append("\nname = " + quizName);
		strBuf.append("\ndescription = " + description);
		strBuf.append("\ncreatorId = " + creatorId);
		
		strBuf.append("\ngrade = " + grade);
		strBuf.append("\nsubject = " + subject);
		strBuf.append("\nstrand = " + strand);
		strBuf.append("\nobjective = " + objective);
		
		int qNum = 0;
		for(QuestionBean question : questions) {
			strBuf.append("\nQuestion" + qNum++);
			strBuf.append("\nquestionId = " + question.getId());
			strBuf.append("\nquestionText = " + question.getText());
			
			int aNum = 0;
			for(AnswerBean answer : question.getAnswers()) {
				strBuf.append("\nAnswer" + qNum + "" + aNum++);
				strBuf.append("\nanswerId = " + answer.getId());
				strBuf.append("\nanswerText = " + answer.getText());
				strBuf.append("\nanswerCorrect = " + answer.isCorrect());
				strBuf.append("\nanswerSelected = " + answer.isSelected());
			}
		}

		return strBuf.toString();
	}

	public Integer getLessonAssignmentId() {
		return lessonAssignmentId;
	}

	public void setLessonAssignmentId(Integer lessonAssignmentId) {
		this.lessonAssignmentId = lessonAssignmentId;
	}
	
}
