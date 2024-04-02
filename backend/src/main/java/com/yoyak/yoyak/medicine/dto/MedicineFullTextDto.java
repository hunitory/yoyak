package com.yoyak.yoyak.medicine.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

@Getter
@AllArgsConstructor
@NoArgsConstructor
@ToString
public class MedicineFullTextDto {

    @JsonProperty("seq")
    private Long medicineSeq;

    @JsonProperty("img_path")
    private String imgPath;

    @JsonProperty("item_name")
    private String itemName;

    @JsonProperty("entp_name")
    private String entpName;
}
