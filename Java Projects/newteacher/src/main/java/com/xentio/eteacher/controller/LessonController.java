package com.xentio.eteacher.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
@RequestMapping("/lesson")
public class LessonController {

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String goToLEssonPage() {

    	return "lessonScreen";
    }
}
