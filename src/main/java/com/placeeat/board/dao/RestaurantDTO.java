package com.placeeat.board.dao;

import java.util.Date;

public class RestaurantDTO {
    private String restId;
    private String restName;
    private String description;
    private String restaddress;
    private String imgOfilename;
    private String imgSfilename;
    private Date createdAt;
    private String phone;
    private String mainmenu;
    private int boardId;

    // Getter / Setter
    public String getRestId() { return restId; }
    public void setRestId(String restId) { this.restId = restId; }

    public String getRestName() { return restName; }
    public void setRestName(String restName) { this.restName = restName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getRestAddress() { return restaddress; }
    public void setRestAddress(String restaddress) { this.restaddress = restaddress; }

    public String getImgOfilename() { return imgOfilename; }
    public void setImgOfilename(String imgOfilename) { this.imgOfilename = imgOfilename; }

    public String getImgSfilename() { return imgSfilename; }
    public void setImgSfilename(String imgSfilename) { this.imgSfilename = imgSfilename; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getMainmenu() { return mainmenu; }
    public void setMainmenu(String mainmenu) { this.mainmenu = mainmenu; }

    public int getBoardId() { return boardId; }
    public void setBoardId(int boardId) { this.boardId = boardId; }
}
