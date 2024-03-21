package com.yoyak.yoyak.medicineEnvelop.controller;

import com.yoyak.yoyak.medicineEnvelop.dto.MedicineEnvelopCreateDto;
import com.yoyak.yoyak.medicineEnvelop.service.MedicineEnvelopService;
import com.yoyak.yoyak.util.dto.BasicResponseDto;
import com.yoyak.yoyak.util.dto.StatusResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/medicineEnvelop")
@RequiredArgsConstructor
@Slf4j
public class MedicineEnvelopController {

    private final MedicineEnvelopService medicineEnvelopService;

    @PostMapping
    public ResponseEntity<StatusResponseDto> medicineEnvelopAdd(
        @RequestBody MedicineEnvelopCreateDto requestDto) {

        log.info("약 봉투 등록 - {}", requestDto);

        return ResponseEntity
            .ok()
            .body(medicineEnvelopService.addMedicineEnvelop(requestDto));
    }

    @GetMapping
    public ResponseEntity<BasicResponseDto> medicineEnvelopList(
        @RequestParam(name = "userSeq", required = true) Long userSeq,
        @RequestParam(name = "medicineSeq", required = false) Long itemSeq
    ) {

        log.info("userSeq({})의 약 봉투 조회 {} -", userSeq, itemSeq);

        return ResponseEntity
            .ok()
            .body(medicineEnvelopService.findMedicineEnvelopList(userSeq, itemSeq));
    }


    @GetMapping("/{medicineEnvelopSeq}")
    public ResponseEntity<BasicResponseDto> medicineEnvelopDetails(
        @PathVariable Long medicineEnvelopSeq) {
        log.info("findMedicineSummaryList - medicineEnvelopSeq={}", medicineEnvelopSeq);

        return ResponseEntity
            .ok()
            .body(medicineEnvelopService.findMedicineSummaryList(medicineEnvelopSeq));
    }
}
