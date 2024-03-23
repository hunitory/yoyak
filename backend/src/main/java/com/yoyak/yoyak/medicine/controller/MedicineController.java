package com.yoyak.yoyak.medicine.controller;

import com.yoyak.yoyak.medicine.dto.MedicineDto;
import com.yoyak.yoyak.medicine.dto.MedicineSearchParametersDto;
import com.yoyak.yoyak.medicine.service.MedicineService;
import com.yoyak.yoyak.util.dto.BasicResponseDto;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/medicine")
@RequiredArgsConstructor
@Slf4j
public class MedicineController {

    private final MedicineService medicineService;

    @GetMapping("/filter")
    public BasicResponseDto medicineList(@ModelAttribute MedicineSearchParametersDto parameters) {

        log.info("[{}.{}] parmeters = {}", this.getClass().getName(),
            Thread.currentThread().getStackTrace()[1].getMethodName(), parameters);

        List<MedicineDto> medicineList = medicineService.findMedicineByParameters(parameters);

        log.info("[{}.{}] medicineList = {}", this.getClass().getName(),
            Thread.currentThread().getStackTrace()[1].getMethodName(), medicineList);

        return BasicResponseDto.builder()
            .count(medicineList.size())
            .result(medicineList)
            .build();
    }
}
