package com.placeeat.board.dao;

import java.sql.Date;

public class BoardDTO {

	// 변수 선언 - camel 표기법 이용
	// board_id : 일련번호, created_at : 작성 날짜, updated_at : 수정 날짜, 
	// title : 기사 제목, viewCount : 조회수, content : 기사 내용(상세정보), 
	// img_ofilename : 이미지 파일(원본) 이름, img_sfilename : 이미지 파일(수정본) 이름, 
	// details : 부가정보,  latitude : 위도, longitude : 경도, user_id : 작성자 아이디,
	// hashtagName : 해쉬태그(#)명, locationName : 지역명
	private int boardId;
	private Date createdAt;
	private Date updatedAt;
	private String title;
	private int viewCount;
	private String content;
	private String imgOfilename;
	private String imgSfilename;
	private String details;
	private double latitude;
	private double longitude;
	private String userId;
	private String hashtagName;
	private String locationName;
	
	public int getBoardId() {
		return boardId;
	}
	public void setBoardId(int boardId) {
		this.boardId = boardId;
	}
	public Date getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}
	public Date getUpdatedAt() {
		return updatedAt;
	}
	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getViewCount() {
		return viewCount;
	}
	public void setViewCount(int viewCount) {
		this.viewCount = viewCount;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public String getImgOfilename() {
		return imgOfilename;
	}
	public void setImgOfilename(String imgOfilename) {
		this.imgOfilename = imgOfilename;
	}
	public String getImgSfilename() {
		return imgSfilename;
	}
	public void setImgSfilename(String imgSfilename) {
		this.imgSfilename = imgSfilename;
	}
	public String getDetails() {
		return details;
	}
	public void setDetails(String details) {
		this.details = details;
	}
	public double getLatitude() {
		return latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	public double getLongitude() {
		return longitude;
	}
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getHashtagName() {
		return hashtagName;
	}
	public void setHashtagName(String hashtagName) {
		this.hashtagName = hashtagName;
	}
	public String getLocationName() {
		return locationName;
	}
	public void setLocationName(String locationName) {
		this.locationName = locationName;
	}
}
