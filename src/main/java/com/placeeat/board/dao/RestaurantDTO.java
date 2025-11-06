package com.placeeat.board.dao;

public class RestaurantDTO {
    private int boardId;
    private String restName;
    private String restAddress;

    public int getBoardId() {
        return boardId;
    }
    public void setBoardId(int boardId) {
        this.boardId = boardId;
    }

    public String getRestName() {
        return restName;
    }
    public void setRestName(String restName) {
        this.restName = restName;
    }

    public String getRestAddress() {
        return restAddress;
    }
    public void setRestAddress(String restAddress) {
        this.restAddress = restAddress;
    }
}