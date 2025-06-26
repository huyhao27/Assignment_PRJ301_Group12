/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author LENOVO
 */
public class Follow {
    private int followerId;
    private int followingId;
    private Timestamp followedAt;

    public Follow() {}

    public Follow(int followerId, int followingId, Timestamp followedAt) {
        this.followerId = followerId;
        this.followingId = followingId;
        this.followedAt = followedAt;
    }

    public int getFollowerId() {
        return followerId;
    }

    public void setFollowerId(int followerId) {
        this.followerId = followerId;
    }

    public int getFollowingId() {
        return followingId;
    }

    public void setFollowingId(int followingId) {
        this.followingId = followingId;
    }

    public Timestamp getFollowedAt() {
        return followedAt;
    }

    public void setFollowedAt(Timestamp followedAt) {
        this.followedAt = followedAt;
    }

    
}
