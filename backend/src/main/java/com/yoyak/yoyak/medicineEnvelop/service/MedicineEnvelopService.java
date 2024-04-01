package com.yoyak.yoyak.medicineEnvelop.service;

import static com.yoyak.yoyak.util.exception.CustomExceptionStatus.ENVELOP_NOT_EXIST;

import com.yoyak.yoyak.account.domain.Account;
import com.yoyak.yoyak.account.service.AccountService;
import com.yoyak.yoyak.medicineEnvelop.domain.MedicineEnvelop;
import com.yoyak.yoyak.medicineEnvelop.domain.MedicineEnvelopRepository;
import com.yoyak.yoyak.medicineEnvelop.dto.MedicineEnvelopCreateDto;
import com.yoyak.yoyak.medicineEnvelop.dto.MedicineEnvelopDto;
import com.yoyak.yoyak.medicineEnvelop.dto.MedicineSummaryDto;
import com.yoyak.yoyak.util.exception.CustomException;
import com.yoyak.yoyak.util.security.SecurityUtil;
import java.util.ArrayDeque;
import java.util.HashMap;
import java.util.List;
import java.util.Queue;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

@Service
@Slf4j
@RequiredArgsConstructor
public class MedicineEnvelopService {

    private final MedicineEnvelopRepository medicineEnvelopRepository;
    private final AccountService accountService;
    @Value("${cloud.aws.s3.prefix}")
    private String s3Prefix;

    /**
     * 봉투 정보를 받아 등록
     *
     * @param requestDto
     */
    public void addMedicineEnvelop(MedicineEnvelopCreateDto requestDto) {

        // 요청한 User이 소유한 Account인지 검증
        Account account = verifyAccountBelongsToUser(requestDto.getAccountSeq());

        MedicineEnvelop medicineEnvelop = MedicineEnvelop.builder()
            .name(requestDto.getName())
            .color(requestDto.getColor())
            .account(account)
            .build();

        medicineEnvelopRepository.save(medicineEnvelop);
        log.info("medicineEnvelop={}", medicineEnvelop);
    }

    // 요청한 User이 소유한 Account인지 검증체크
    private Account verifyAccountBelongsToUser(Long accountSeq) {
        log.info("userSeq={} account ={}", SecurityUtil.getUserSeq(), accountSeq);
        return accountService.findByIdAndUserSeq(
            SecurityUtil.getUserSeq(),
            accountSeq);
    }

    // 유저가 소유한 약봉투인지 검증
    private void verifyEnvelopeBelongsToUser(Long medicineEnvelopSeq) {

        // 존재하는 약 봉투 인지 검증
        MedicineEnvelop envelop =
            medicineEnvelopRepository.findById(medicineEnvelopSeq)
                .orElseThrow(() -> new CustomException(ENVELOP_NOT_EXIST));

        /**
         * 약봉투의 account_id와 AccessToken의 user_seq를 비교
         * 약봉투의 account가 User소유인지 확인
         */
        verifyAccountBelongsToUser(envelop.getAccount().getSeq());
    }

    /**
     * 요청받은 약 봉투를 삭제
     *
     * @param medicineEnvelopSeq
     */
    public void deleteMedicineEnvelop(Long medicineEnvelopSeq) {

        // 유효한지 검증
        verifyEnvelopeBelongsToUser(medicineEnvelopSeq);

        medicineEnvelopRepository.deleteById(medicineEnvelopSeq);
    }

    /**
     * 특정 약 봉투의 약의 간략정보를 조회하는 메소드
     *
     * @param medicineEnvelopSeq
     * @return List<MedicineSummaryDto>
     */
    public List<MedicineSummaryDto> findMedicineSummaryList(Long medicineEnvelopSeq) {

        // 요청한 User이 소유한 Account인지 검증
        verifyAccountBelongsToUser(
            medicineEnvelopRepository
                .findById(medicineEnvelopSeq)
                .orElseThrow(() -> new CustomException(ENVELOP_NOT_EXIST))
                .getAccount()
                .getSeq());

        List<MedicineSummaryDto> medicineSummaryDtoList =
            medicineEnvelopRepository.findMedicineSummaryByEnvelopSeq(medicineEnvelopSeq);

        medicineSummaryDtoList.stream()
            .forEach(data -> {
                data.setImgPath(s3Prefix + data.getImgPath());
            });

        return medicineSummaryDtoList;
    }

    /**
     * 지정한 약 봉투의 약 목록을 조회하는 메소드. 선택적으로 특정 약에 대한 포함여부를 조회.
     *
     * @param userSeq
     * @param itemSeq
     * @return List<MedicineEnvelopDto>
     */
    public List<MedicineEnvelopDto> findMedicineEnvelopList(Long userSeq, Long itemSeq) {
        Queue<String> colorCode = new ArrayDeque<>();

        // 사용자에게 임의로 지정할 색상 코드 추가 ( 계정은 최대3개)
        colorCode.add("0XffBED1CF");
        colorCode.add("0xffE78895");
        colorCode.add("0xffBBE2EC");

        HashMap<Long, String> colorCodeMap = new HashMap<>();

        List<MedicineEnvelopDto> medicineEnvelopDtoList =

            // stream 돌며 각 유저에 고유 색상코드를 할당합니다
            medicineEnvelopRepository.findMedicineEnvelopByUserSeq(userSeq, itemSeq).stream()
                .map(envelop -> {
                    Long accountSeq = envelop.getAccountSeq();

                    // 고유한 색상 코드를 할당하기 위해
                    // 'accountSeq'로 'colorCodeMap'에 매핑되었는지 확인합니다
                    if (!colorCodeMap.containsKey((Long) accountSeq)) {

                        // colorCode 큐에서 색상 코드를 꺼내 accountSeq에 매핑합니다.
                        colorCodeMap.put(accountSeq, colorCode.poll());
                    }

                    // 할당된 색상 코드를 현재 MedicineEnvelop 객체에 설정합니다.
                    envelop.setColor(colorCodeMap.get(accountSeq));

                    return envelop;
                })
                .collect(Collectors.toList());

        return medicineEnvelopDtoList;
    }
}
