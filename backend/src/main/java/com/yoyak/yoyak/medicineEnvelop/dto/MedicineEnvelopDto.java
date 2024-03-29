package com.yoyak.yoyak.medicineEnvelop.dto;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MedicineEnvelopDto {

    private Long medicineEnvelopSeq;
    private String EnvelopName;
    private String color;
    private Long accountSeq;
    private String nickname;
    private Boolean isSavedMedicine;

    public MedicineEnvelopDto(Long medicineEnvelopSeq, String envelopName, String color,
        Long accountSeq, String nickname, Boolean isSavedMedicine) {
        this.medicineEnvelopSeq = medicineEnvelopSeq;
        EnvelopName = envelopName;
        this.color = color;
        this.accountSeq = accountSeq;
        this.nickname = nickname;
        this.isSavedMedicine = isSavedMedicine;
    }

    public MedicineEnvelopDto(Long medicineEnvelopSeq, String envelopName, String color,
        Long accountSeq, String nickname) {
        this.medicineEnvelopSeq = medicineEnvelopSeq;
        EnvelopName = envelopName;
        this.color = color;
        this.accountSeq = accountSeq;
        this.nickname = nickname;
    }
}
