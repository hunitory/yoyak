package com.yoyak.yoyak.medicineSaved.controller;

import com.yoyak.yoyak.medicineSaved.dto.MedicineFromEnvelopeRemovalDto;
import com.yoyak.yoyak.medicineSaved.dto.MedicineToEnvelopRegistrationDto;
import com.yoyak.yoyak.medicineSaved.service.MedicineSavedService;
import com.yoyak.yoyak.util.dto.StatusResponseDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/medicineSaved")
@RequiredArgsConstructor
@Slf4j
public class MedicineSavedController {

    private final MedicineSavedService medicineSavedService;

    /**
     * 약 봉투에 약을 추가하는 메소드
     *
     * @param requestDto
     * @return ResponseEntity<StatusResponseDto>
     */
    @PostMapping()
    public ResponseEntity<StatusResponseDto> addMedicineToEnvelop(
        @RequestBody MedicineToEnvelopRegistrationDto requestDto) {

        log.info("addMedicineToEnvelop={}", requestDto);

        return ResponseEntity.ok().body(
            medicineSavedService.addMedicineToEnvelop(requestDto));
    }

    /**
     * 약 봉투에서 약을 삭제하는 메소드
     *
     * @param requestDto
     * @return ResponseEntity<StatusResponseDto>
     */
    @DeleteMapping
    public ResponseEntity<StatusResponseDto> deleteMedicineToEnvelop(
        @RequestBody MedicineFromEnvelopeRemovalDto requestDto) {

        log.info("deleteMedicineToEnvelop={}", requestDto);

        return ResponseEntity.ok().body(
            medicineSavedService.deleteMedicineToEnvelop(requestDto));
    }
}
