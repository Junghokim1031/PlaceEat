package com.placeeat.board.dao;

import java.sql.Date;

public class BoardDTO {
	// ✅ 필드명 camelCase로 변경
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
    
    private int likeCount; // 좋아요 수
    private boolean liked; //좋아요 상태
    
    //기본 생성자
    public BoardDTO() {}
    
    // 간단한 생성자
    public BoardDTO(int boardId, String title, String userId, Date createdAt) {
        this.boardId = boardId;
        this.title = title;
        this.userId = userId;
        this.createdAt = createdAt;
    }
    

    // ✅ Getter / Setter ------------------------------------
    
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

    public int getLikeCount() {
        return likeCount;
    }
    public void setLikeCount(int likeCount) {
        this.likeCount = likeCount;
    }

    public boolean isLiked() {
        return liked;
    }
    public void setLiked(boolean liked) {
        this.liked  = liked ;
    }
   
        
}