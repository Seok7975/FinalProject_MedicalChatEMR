package com.emr.www.entity.employeestatus;

public enum Status {
    자리비움("자리 비움"),
    진료중("진료 중"),
    점심시간("점심시간");

    private final String value;

    Status(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}


