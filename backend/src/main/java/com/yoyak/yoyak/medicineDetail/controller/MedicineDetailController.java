package com.yoyak.yoyak.medicineDetail.controller;

import com.yoyak.yoyak.medicineDetail.dto.MedicineDetailDto;
import com.yoyak.yoyak.medicineDetail.service.MedicineDetailService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/medicineDetail")
@RequiredArgsConstructor
@Slf4j
public class MedicineDetailController {

    private final MedicineDetailService medicineDetailService;

    @GetMapping("/{itemSeq}")
    public ResponseEntity<MedicineDetailDto> orderDetails(@PathVariable("itemSeq") Long itemSeq) {
        log.info("[{}.{}] itemSeq = {}", this.getClass().getName(),
            Thread.currentThread().getStackTrace()[1].getMethodName(), itemSeq);

        MedicineDetailDto medicineDetailDto = medicineDetailService.findMedicineDetail(itemSeq);

        log.info("[{}.{}] MedicineDetailDto = {}", this.getClass().getName(),
            Thread.currentThread().getStackTrace()[1].getMethodName(), itemSeq);
        return ResponseEntity.ok()
            .body(medicineDetailDto);
    }
}
