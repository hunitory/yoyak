package com.yoyak.yoyak.medicineSaved.service;

import static com.yoyak.yoyak.util.exception.CustomExceptionStatus.ENVELOP_NOT_EXIST;
import static com.yoyak.yoyak.util.exception.CustomExceptionStatus.MEDICINE_NOT_EXIST;

import com.yoyak.yoyak.medicine.domain.Medicine;
import com.yoyak.yoyak.medicine.domain.MedicineRepository;
import com.yoyak.yoyak.medicineEnvelop.domain.MedicineEnvelop;
import com.yoyak.yoyak.medicineEnvelop.domain.MedicineEnvelopRepository;
import com.yoyak.yoyak.medicineSaved.domain.MedicineSaved;
import com.yoyak.yoyak.medicineSaved.domain.MedicineSavedRepository;
import com.yoyak.yoyak.medicineSaved.dto.MedicineFromEnvelopeRemovalDto;
import com.yoyak.yoyak.medicineSaved.dto.MedicineToEnvelopRegistrationDto;
import com.yoyak.yoyak.util.exception.CustomException;
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

    /**
     * 약 봉투에 약을 추가하는 서비스 메소드입니다.
     *
     * @param requestDto
     */
    @Transactional
    public void addMedicineToEnvelop(
        MedicineToEnvelopRegistrationDto requestDto) {

        Medicine medicine = medicineRepository.
            findBySeq(requestDto.getMedicineSeq())
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

        medicineSavedRepository.deleteByMedicineEnvelopSeqAndMedicineSeq(
            requestDto.getEnvelopeSeq(), requestDto.getMedicineSeq());
    }
}

