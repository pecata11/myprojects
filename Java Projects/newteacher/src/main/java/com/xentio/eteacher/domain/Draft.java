package com.xentio.eteacher.domain;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;

@Entity
@Table(name = "draft")
public class Draft implements Serializable {
	private static final long serialVersionUID = -1675922296446040732L;

	@Id
	@Column(name = "create_time_mlls")
	private Long createTimeMlls;

	@Column(name = "update_time_mlls", nullable = false)
	private Long updateTimeMlls;
	
	@Lob
	@Column(name = "data", nullable = false)
	private String data;


	public Long getCreateTimeMlls() {
		return createTimeMlls;
	}

	public void setCreateTimeMlls(Long createTimeMlls) {
		this.createTimeMlls = createTimeMlls;
	}

	public Long getUpdateTimeMlls() {
		return updateTimeMlls;
	}

	public void setUpdateTimeMlls(Long updateTimeMlls) {
		this.updateTimeMlls = updateTimeMlls;
	}

	public String getData() {
		return data;
	}

	public void setData(String data) {
		this.data = data;
	}

}
