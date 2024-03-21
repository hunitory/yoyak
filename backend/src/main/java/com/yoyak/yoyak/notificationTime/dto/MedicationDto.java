package com.yoyak.yoyak.notificationTime.dto;

import java.time.LocalTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MedicationDto {

    private Long notiTimeSeq;
    private LocalTime takenTime;
}
