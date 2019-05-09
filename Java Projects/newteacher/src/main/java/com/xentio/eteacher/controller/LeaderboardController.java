package com.xentio.eteacher.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.xentio.eteacher.domain.bean.LeaderboardBean;
import com.xentio.eteacher.service.QuizService;

@Controller
public class LeaderboardController {
	
	@Autowired
	private QuizService quizService;
	
    @RequestMapping(value = "/leaderboard", method = RequestMethod.GET)
    public String getLeaderboard(@RequestParam(value="order") String order, Model model) {
    	List<LeaderboardBean> list = quizService.getLeaderRank(order);
    	model.addAttribute("ranks", list);
    	return "quiz/leaderboard";
	}
}
