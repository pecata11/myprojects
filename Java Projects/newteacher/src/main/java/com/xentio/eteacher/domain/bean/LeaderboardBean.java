package com.xentio.eteacher.domain.bean;

public class LeaderboardBean {

	private int rank;
	private String name;
	private int createdLessons;
	
	public LeaderboardBean() {

	}
	public LeaderboardBean(int rank, String name, int createdLessons) {
		super();
		this.rank = rank;
		this.name = name;
		this.createdLessons = createdLessons;
	}
	public int getRank() {
		return rank;
	}
	public void setRank(int rank) {
		this.rank = rank;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public int getCreatedLessons() {
		return createdLessons;
	}
	public void setCreatedLessons(int createdLessons) {
		this.createdLessons = createdLessons;
	}
}
