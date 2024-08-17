package com.emr.www.entity;

import jakarta.persistence.MappedSuperclass;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;

@MappedSuperclass
public abstract class StatusEntity {

    @Enumerated(EnumType.STRING)
    private Status activeStatus = Status.자리비움; // 기본값 설정

    // Getter 및 Setter
    public Status getActiveStatus() {
        return activeStatus;
    }

    public void setActiveStatus(Status activeStatus) {
        if (activeStatus == null) {
            this.activeStatus = Status.자리비움; // null일 경우 기본값으로 설정
        } else {
            this.activeStatus = activeStatus;
        }
    }
}
