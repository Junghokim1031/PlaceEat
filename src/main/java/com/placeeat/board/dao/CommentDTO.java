package com.placeeat.board.dao;

import java.util.Date;

public class CommentDTO {
    private int commentId;
    private String content;
    private Date createdAt;
    private String userId;
    private int boardId;

    // getter/setter
    public int getCommentId() { return commentId; }
    public void setCommentId(int commentId) { this.commentId = commentId; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public int getBoardId() { return boardId; }
    public void setBoardId(int boardId) { this.boardId = boardId; }
}
