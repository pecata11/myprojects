package com.xentio.eteacher.domain.bean;

public class CroppableImage {
	private long pdfImageId;
	private long imageId;
	private double cropLeft;
	private double cropTop;
	private double cropWidth;
	private double cropHeight;

	public CroppableImage() {}
	
	public CroppableImage(long imageId, long pdfImageId) {
		this.imageId = imageId;
		this.pdfImageId = pdfImageId;
	}
	
	public long getCroppedImageIdIfExists() {
    	return imageId > 0 ? imageId : pdfImageId;

	}
	
	public long getPdfImageId() {
		return pdfImageId;
	}

	public void setPdfImageId(long pdfImageId) {
		this.pdfImageId = pdfImageId;
	}

	public long getImageId() {
		return imageId;
	}

	public void setImageId(long imageId) {
		this.imageId = imageId;
	}

	public double getCropLeft() {
		return cropLeft;
	}

	public void setCropLeft(double cropLeft) {
		this.cropLeft = cropLeft;
	}

	public double getCropTop() {
		return cropTop;
	}

	public void setCropTop(double cropTop) {
		this.cropTop = cropTop;
	}

	public double getCropWidth() {
		return cropWidth;
	}

	public void setCropWidth(double cropWidth) {
		this.cropWidth = cropWidth;
	}

	public double getCropHeight() {
		return cropHeight;
	}

	public void setCropHeight(double cropHeight) {
		this.cropHeight = cropHeight;
	}

}
