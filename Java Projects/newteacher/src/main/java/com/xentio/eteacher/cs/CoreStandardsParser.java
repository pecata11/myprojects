package com.xentio.eteacher.cs;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashSet;
import java.util.TreeMap;
import java.util.TreeSet;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class CoreStandardsParser {

	public static final String STRAND_OBJECTIVE_KEY_PART = "_";
	public static final TreeMap<String, TreeSet<String>> mathGradeStrandMap = new TreeMap<String, TreeSet<String>>();
	public static final TreeMap<String, TreeSet<String>> mathGradeStrandObjectiveMap = new TreeMap<String, TreeSet<String>>();
	public static final TreeMap<String, TreeSet<String>> literacyGradeStrandMap = new TreeMap<String, TreeSet<String>>();
	public static final TreeMap<String, TreeSet<String>> literacyGradeStrandObjectiveMap = new TreeMap<String, TreeSet<String>>();
	
	static {
		loadMaps("math.json", mathGradeStrandMap, mathGradeStrandObjectiveMap, true);
		loadMaps("ela.json", literacyGradeStrandMap, literacyGradeStrandObjectiveMap, false);
	}
	
	private static void loadMaps(String fileName,
			TreeMap<String, TreeSet<String>> gradeStrandMap,
			TreeMap<String, TreeSet<String>> gradeStrandObjectiveMap, boolean isMath) {
		for (int i = 0; i < 13; i++) {
			gradeStrandMap.put("" + i, new TreeSet<String>());
		}

		JSONParser parser = new JSONParser();

		try {

			Object obj = parser.parse(new FileReader(fileName));
			JSONArray array = (JSONArray) obj;
			for (int i = 0; i < array.size(); i++) {
				JSONObject row = (JSONObject) array.get(i);
				String dotNotation = (String) row.get("dotNotation");
				String category = (String) row.get("category");
				category = category.replaceAll("[^A-Za-z0-9\\s&]", " ");//dirty hack for same strange symbols
//				String standard = (String) row.get("standard");
//				String subject = (String) row.get("subject");
				
				HashSet<String> gradesSet = isMath ? mathGrades(dotNotation) : literacyGrades(dotNotation);
				for (String grade : gradesSet) {
					TreeSet<String> strands = gradeStrandMap.get(grade);
					if (strands != null) {
						strands.add(category);
					}

					String key = grade + STRAND_OBJECTIVE_KEY_PART + category;
					TreeSet<String> objectives = gradeStrandObjectiveMap.get(key);
					if (objectives == null) {
						objectives = new TreeSet<String>();
						gradeStrandObjectiveMap.put(key, objectives);
					}
					objectives.add(dotNotation);
				}
			}

		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}

	
	private static HashSet<String> mathGrades(String dotNotation) {
		HashSet<String> gradesSet = new HashSet<String>();
		String gradeStr = dotNotation.substring(0, 1);
		if("K".equals(gradeStr)) {
			gradesSet.add("0");
		} else if ("H".equals(gradeStr)) {
			gradesSet.add("9");
			gradesSet.add("10");
			gradesSet.add("11");
			gradesSet.add("12");
		} else {
			gradesSet.add(gradeStr);
		}
		
		return gradesSet;
	}
	
	private static HashSet<String> literacyGrades(String dotNotation) {
		HashSet<String> gradesSet = new HashSet<String>();
		
		if (dotNotation.startsWith("CCRA")) {
			for(int j = 0; j < 13; j++) {
				gradesSet.add("" + j);
			}
		} else {
			String dotNot = dotNotation.split("\\.")[1]; 
			try {
				Integer.parseInt(dotNot);
				gradesSet.add(dotNot);
			} catch(NumberFormatException nfe) {
				if("K".equals(dotNot)) {
					gradesSet.add("0");
				} else {
					String[] splittedGrades = dotNot.split("-");
					int start = Integer.parseInt(splittedGrades[0]);
					int end = Integer.parseInt(splittedGrades[1]);
					for(int q = start ; q <= end; q++) {
						gradesSet.add("" + q);
					}
				}
				
			}
		}
		
		return gradesSet;
	}

}
