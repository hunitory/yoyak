package com.yoyak.yoyak.recognition.dto;

import com.yoyak.yoyak.medicine.dto.MedicineDto;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@Builder
@AllArgsConstructor
public class RecognitionResponseDto {
    private int count;
    private List<MedicineDto> medicineList;

}
