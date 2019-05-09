package com.xentio.eteacher.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "pdffile")
public class PdfFile implements Serializable {
	private static final long serialVersionUID = 2692162110462567054L;

	@Id
	@GeneratedValue
	private Long id;

	@Column(name = "file_name", nullable = false)
	private String fileName;
	
	@Column(name = "create_time", nullable = false)
	private Date createTime;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	
}
