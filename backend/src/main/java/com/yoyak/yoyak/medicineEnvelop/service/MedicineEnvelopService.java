package com.yoyak.yoyak.medicineEnvelop.service;

import com.yoyak.yoyak.account.domain.Account;
import com.yoyak.yoyak.account.domain.AccountRepository;
import com.yoyak.yoyak.medicineEnvelop.domain.MedicineEnvelop;
import com.yoyak.yoyak.medicineEnvelop.domain.MedicineEnvelopRepository;
import com.yoyak.yoyak.medicineEnvelop.dto.MedicineEnvelopCreateDto;
import com.yoyak.yoyak.medicineEnvelop.dto.MedicineSummaryDto;
import com.yoyak.yoyak.util.dto.BasicResponseDto;
import com.yoyak.yoyak.util.dto.StatusResponseDto;
import java.util.List;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class MedicineEnvelopService {

    private final MedicineEnvelopRepository medicineEnvelopRepository;
    private final AccountRepository accountRepository;

    public StatusResponseDto addMedicineEnvelop(
        MedicineEnvelopCreateDto medicineEnvelopeCreateDto) {

        Account account = accountRepository.findById(1L).orElseThrow();
        MedicineEnvelop medicineEnvelop = MedicineEnvelop.builder()
            .name(medicineEnvelopeCreateDto.getName())
            .color(medicineEnvelopeCreateDto.getColor())
            .account(account)
            .build();

        medicineEnvelopRepository.save(medicineEnvelop);
        log.info("medicineEnvelop={}", medicineEnvelop);

        return StatusResponseDto.builder()
            .code(200)
            .message("success")
            .build();
    }

    //    @Transactional(readOnly = true)
    public BasicResponseDto findMedicineSummaryList(Long medicineEnvelopSeq) {

        List<MedicineSummaryDto> medicineSummaryDtoList =
            medicineEnvelopRepository.findMedicineSummaryByEnvelopSeq(medicineEnvelopSeq);

        return BasicResponseDto.builder()
            .count(medicineSummaryDtoList.size())
            .result(medicineSummaryDtoList)
            .build();
    }
}