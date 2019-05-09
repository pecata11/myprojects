package com.xentio.eteacher.domain;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.Table;

@Entity
@Table(name = "lessonimage")
public class LessonImage implements Serializable {
	private static final long serialVersionUID = 2692162110462567054L;

	@Id
	@GeneratedValue
	private Long id;

	@Lob
	@Column(nullable = false)
	private byte[] content;
	
	@Column(name = "pdf_id")
	private Long pdfId;
	
	@Column(name = "page_num")
	private Integer pageNum;
	
	@Column(name = "modify_time", nullable = false)
	private Date modifyTime;

	@Column(name = "is_cropped")
	private Boolean isCropped;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public byte[] getContent() {
		return content;
	}

	public void setContent(byte[] content) {
		this.content = content;
	}

	public Long getPdfId() {
		return pdfId;
	}

	public void setPdfId(Long pdfId) {
		this.pdfId = pdfId;
	}

	public Integer getPageNum() {
		return pageNum;
	}

	public void setPageNum(Integer pageNum) {
		this.pageNum = pageNum;
	}

	public Date getModifyTime() {
		return modifyTime;
	}

	public void setModifyTime(Date modifyTime) {
		this.modifyTime = modifyTime;
	}

	public Boolean getIsCropped() {
		return isCropped;
	}

	public void setIsCropped(Boolean isCropped) {
		this.isCropped = isCropped;
	}
	
}
