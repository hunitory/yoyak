package com.yoyak.yoyak.medicineSaved.service;

import static com.yoyak.yoyak.util.exception.CustomExceptionStatus.ENVELOP_AUTHORITY;
import static com.yoyak.yoyak.util.exception.CustomExceptionStatus.ENVELOP_NOT_EXIST;
import static com.yoyak.yoyak.util.exception.CustomExceptionStatus.MEDICINE_NOT_EXIST;

import com.yoyak.yoyak.account.service.AccountService;
import com.yoyak.yoyak.medicine.domain.Medicine;
import com.yoyak.yoyak.medicine.domain.MedicineRepository;
import com.yoyak.yoyak.medicineEnvelop.domain.MedicineEnvelop;
import com.yoyak.yoyak.medicineEnvelop.domain.MedicineEnvelopRepository;
import com.yoyak.yoyak.medicineSaved.domain.MedicineSaved;
import com.yoyak.yoyak.medicineSaved.domain.MedicineSavedRepository;
import com.yoyak.yoyak.medicineSaved.dto.MedicineFromEnvelopeRemovalDto;
import com.yoyak.yoyak.medicineSaved.dto.MedicineToEnvelopRegistrationDto;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.security.SecurityUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Slf4j
@RequiredArgsConstructor
public class MedicineSavedService {

    private final MedicineSavedRepository medicineSavedRepository;
    private final MedicineEnvelopRepository medicineEnvelopRepository;
    private final MedicineRepository medicineRepository;
    private final AccountService accountService;

    /**
     * 약 봉투에 약을 추가하는 서비스 메소드입니다.
     *
     * @param requestDto
     */
    @Transactional
    public void addMedicineToEnvelop(
        MedicineToEnvelopRegistrationDto requestDto) {

        // 요청한 User이 소유한 Account인지 검증체크
        verifyAccountBelongsToUser(requestDto.getAccountSeq());

        verifyEnvelopBelongsToAccount(
            requestDto.getEnvelopeSeq(),
            requestDto.getAccountSeq());

        Medicine medicine = medicineRepository
            .findBySeq(requestDto.getMedicineSeq())
            .orElseThrow(() -> new CustomException(MEDICINE_NOT_EXIST));
        log.info("seq ={}, medicine ={}", requestDto.getMedicineSeq(), medicine);

        MedicineEnvelop envelop = medicineEnvelopRepository
            .findById(requestDto.getEnvelopeSeq())
            .orElseThrow(() -> new CustomException(ENVELOP_NOT_EXIST));
        log.info("seq ={}, envelop ={}", requestDto.getEnvelopeSeq(), envelop);

        MedicineSaved medicineSaved = MedicineSaved.builder()
            .accountSeq(requestDto.getAccountSeq())
            .medicineEnvelop(envelop)
            .medicine(medicine)
            .build();
        log.info("medicineSaved ={}", medicineSaved);
        medicineSavedRepository.save(medicineSaved);
    }

    /**
     * 약 봉투에서 약을 삭제하는 서비스 메소드입니다.
     *
     * @param requestDto
     */
    public void deleteMedicineToEnvelop(
        MedicineFromEnvelopeRemovalDto requestDto) {

        verifyAccountBelongsToUser(requestDto.getAccountSeq());
        verifyEnvelopBelongsToAccount(
            requestDto.getEnvelopeSeq(),
            requestDto.getAccountSeq());

        medicineSavedRepository.deleteByMedicineEnvelopSeqAndMedicineSeq(
            requestDto.getEnvelopeSeq(),
            requestDto.getMedicineSeq());
    }

    /**
     * 요청한 Account가 소유한 Envelop인지 검증체크
     *
     * @param envelopeSeq
     * @param accountSeq
     */
    private void verifyEnvelopBelongsToAccount(Long envelopeSeq, Long accountSeq) {
        // Envelope의 존재와 권한을 동시에 확인
        boolean isEnvelopeOwnedByAccount = medicineEnvelopRepository
            .findById(envelopeSeq)
            .map(envelope -> envelope.getAccount().getSeq().equals(accountSeq))
            .orElseThrow(() -> new CustomException(ENVELOP_NOT_EXIST)); // Envelope가 존재하지 않으면 예외 발생

        // Envelope 소유권이 없으면 예외 발생
        if (!isEnvelopeOwnedByAccount) {
            throw new CustomException(ENVELOP_AUTHORITY);
        }
    }

    /**
     * 요청한 User이 소유한 Account인지 검증체크
     *
     * @param accountSeq
     */
    private void verifyAccountBelongsToUser(Long accountSeq) {
        accountService.findByIdAndUserSeq(
            SecurityUtil.getUserSeq(),
            accountSeq);
    }
}
