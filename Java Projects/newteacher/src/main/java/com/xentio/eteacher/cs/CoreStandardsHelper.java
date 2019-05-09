package com.xentio.eteacher.cs;

import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.ui.Model;

import com.xentio.eteacher.domain.bean.QuizBean;

public class CoreStandardsHelper {

	public static void setGrades(Model model) {
		Map<String, String> grades = new LinkedHashMap<String, String>();
		grades.put("0", "K");
		for (int i = 1; i < 13; i++) {
			grades.put("" + i, "" + i);
		}
		model.addAttribute("grades", grades);
	}
	
	public static void setObjectivePicker(Model model, QuizBean quizBean) {
		String grade = quizBean.getGrade();
		String subject = quizBean.getSubject();
		String strand = quizBean.getStrand();
		setObjectivePicker(model, grade, subject, strand);
    }
	
	public static void setObjectivePicker(Model model, String grade, String subject, String strand) {
		setGrades(model);

		if(grade != null && !"-1".equals(grade)) {
			model.addAttribute("enableSubject", true);
			if(subject != null && !"-1".equals(subject)) {
				String[] strands = getPickerStrands(grade, subject);
				model.addAttribute("strands", strands);
				model.addAttribute("enableStrand", true);
				
				if(strand != null && !"-1".equals(strand)) {
					String[] objectives = getPickerObjectives(grade, strand, subject);
					model.addAttribute("objectives", objectives);
					model.addAttribute("enableObjective", true);
				}
			}
		}
    }
	
	public static String[] getPickerObjectives(String gradeParam,
			String objectiveParam, String subjectParam) {
		List<String> values = new LinkedList<String>();
		
		if("math".equals(subjectParam)) {
			Set<String> mathObjectives = CoreStandardsParser.mathGradeStrandObjectiveMap
					.get(gradeParam + CoreStandardsParser.STRAND_OBJECTIVE_KEY_PART + objectiveParam);
			if(mathObjectives != null && !mathObjectives.isEmpty()) { 
				for(String objective : mathObjectives) {
					values.add(objective);
				}
			}	
		} else if("literacy".equals(subjectParam)) {		
			
			Set<String> literacyObjectives = CoreStandardsParser.literacyGradeStrandObjectiveMap
					.get(gradeParam + CoreStandardsParser.STRAND_OBJECTIVE_KEY_PART + objectiveParam);
			if(literacyObjectives != null && !literacyObjectives.isEmpty()) { 
				for(String objective : literacyObjectives) {
					values.add(objective);
				}
			}	
		}
		return values.toArray(new String[0]);
    }
	
		public static String[] getPickerStrands(String gradeParam, String subjectParam) {
			List<String> values = new LinkedList<String>();
			
			if("math".equals(subjectParam)) {
				Set<String> mathStrands = CoreStandardsParser.mathGradeStrandMap.get(gradeParam);
				if(mathStrands != null && !mathStrands.isEmpty()) { 
					for(String strand : mathStrands) {
						values.add(strand);
					}
				}		
			} else if("literacy".equals(subjectParam)) {		
				Set<String> literacyStrands = CoreStandardsParser.literacyGradeStrandMap.get(gradeParam);
				if(literacyStrands != null && !literacyStrands.isEmpty()) { 
					for(String strand : literacyStrands) {
						values.add(strand);
					}
				}
			}		
			return values.toArray(new String[0]);
	    }
}
