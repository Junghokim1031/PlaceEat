package com.placeeat.dao;

public class MemberVO {
    private String userid;
    private String password;
    private String name;
    private String birth;
    private String gender;
    private String email;
    private String grade;
    private String resetToken;

    public String getUserid() { return userid; }
    public void setUserid(String userid) { this.userid = userid; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getBirth() { return birth; }
    public void setBirth(String birth) { this.birth = birth; }
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }
    public String getResetToken() { return resetToken; }
    public void setResetToken(String resetToken) { this.resetToken = resetToken; }
}
