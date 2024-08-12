package com.emr.www.response.doctor;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import com.emr.www.entity.doctor.dto.DrugBody;

@XmlRootElement(name = "response")
public class DrugResponse {

    private DrugBody body;

    @XmlElement(name = "body")
    public DrugBody getBody() {
        return body;
    }

    public void setBody(DrugBody body) {
        this.body = body;
    }
}
