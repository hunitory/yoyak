package com.yoyak.yoyak.python.service;

import com.yoyak.yoyak.medicineDetail.domain.MedicineDetail;
import com.yoyak.yoyak.medicineDetail.domain.MedicineDetailRepository;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class PythonServiceTest {

    @Autowired
    private PythonService pythonService;

    @Autowired
    private MedicineDetailRepository medicineDetailRepository;

    @Test
    public void summaryTest() {
        Long itemSeq = 202106092L;

        MedicineDetail medicineDetail = medicineDetailRepository.findBySeq(itemSeq)
            .orElseThrow(() -> new IllegalArgumentException("해당 데이터가 없습니다. itemSeq = " + itemSeq));

        System.out.println(pythonService.getSummary(medicineDetail));
    }

}