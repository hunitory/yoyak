package com.yoyak.yoyak.medicineEnvelop.service;

import static com.yoyak.yoyak.util.exception.CustomExceptionStatus.ACCOUNT_INVALID;

import com.yoyak.yoyak.account.domain.Account;
import com.yoyak.yoyak.account.domain.AccountRepository;
import com.yoyak.yoyak.medicineEnvelop.domain.MedicineEnvelop;
import com.yoyak.yoyak.medicineEnvelop.domain.MedicineEnvelopRepository;
import com.yoyak.yoyak.medicineEnvelop.dto.MedicineEnvelopCreateDto;
import com.yoyak.yoyak.medicineEnvelop.dto.MedicineEnvelopDto;
import com.yoyak.yoyak.medicineEnvelop.dto.MedicineSummaryDto;
import com.yoyak.yoyak.util.dto.BasicResponseDto;
import com.yoyak.yoyak.util.dto.StatusResponseDto;
import com.yoyak.yoyak.util.exception.CustomException;
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

    /**
     * 봉투 정보를 받아 등록
     *
     * @param requestDto
     * @return StatusResponseDto
     */
    public StatusResponseDto addMedicineEnvelop(
        MedicineEnvelopCreateDto requestDto) {

        Account account = accountRepository.
            findById(requestDto.getAccountSeq())
            .orElseThrow(() -> new CustomException(ACCOUNT_INVALID));

        MedicineEnvelop medicineEnvelop = MedicineEnvelop.builder()
            .name(requestDto.getName())
            .color(requestDto.getColor())
            .account(account)
            .build();

        medicineEnvelopRepository.save(medicineEnvelop);
        log.info("medicineEnvelop={}", medicineEnvelop);

        return StatusResponseDto.builder()
            .code(200)
            .message("success")
            .build();
    }

    /**
     * 특정 약 봉투의 약의 간략정보를 조회하는 메소드
     *
     * @param medicineEnvelopSeq
     * @return BasicResponseDto
     */
    public BasicResponseDto findMedicineSummaryList(Long medicineEnvelopSeq) {

        List<MedicineSummaryDto> medicineSummaryDtoList =
            medicineEnvelopRepository.findMedicineSummaryByEnvelopSeq(medicineEnvelopSeq);

        return BasicResponseDto.builder()
            .count(medicineSummaryDtoList.size())
            .result(medicineSummaryDtoList)
            .build();
    }

    /**
     * 지정한 약 봉투의 약 목록을 조회하는 메소드. 선택적으로 특정 약에 대한 포함여부를 조회.
     *
     * @param userSeq
     * @param itemSeq
     * @return BasicResponseDto
     */
    public BasicResponseDto findMedicineEnvelopList(Long userSeq, Long itemSeq) {

        List<MedicineEnvelopDto> medicineEnvelopDtoList =
            medicineEnvelopRepository.findMedicineEnvelopByUserSeq(userSeq, itemSeq);

        return BasicResponseDto.builder()
            .count(medicineEnvelopDtoList.size())
            .result(medicineEnvelopDtoList)
            .build();
    }
}
