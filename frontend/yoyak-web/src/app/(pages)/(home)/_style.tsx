"use client";

import { PALETTE, notoSansKr } from "@/styles";
import styled from "@emotion/styled";
import { keyframes } from "@emotion/react";

const fadeIn = keyframes`
  from { opacity: 0; }
  to { opacity: 1; }
`;

export const Main = styled.div`
  position: relative;
  width: 100%;
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 50px 0px;
`;

export const BannerContainer = styled.div`
  width: 75%;
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
  padding-left: 30px;

  @media (width < 1000px) {
    flex-wrap: wrap;
  }
`;

export const LogoWrapper = styled.div`
  position: absolute;
  right: 85%;
  top: 5%;
`;

export const leftWrapper = styled.div`
  width: 100%;
  max-width: 450px;
  height: 550px;
  opacity: 0; // 초기 상태에서 보이지 않음
  animation: ${fadeIn} 1.5s ease-in-out forwards;
`;

export const RightWrapper = styled.div`
  width: 600px;
  height: 600px;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10%;
`;

export const phoneWrapper = styled.div`
  display: flex;
  flex-direction: row;
  gap: 12%;
  opacity: 0; // 초기 상태에서 보이지 않음
  animation: ${fadeIn} 1.5s ease-in-out 1s forwards;

  @media (width < 1000px) {
    gap: 5%;
  }
`;

export const ButtonWrapper = styled.div`
  /* opacity: 0; // 초기 상태에서 보이지 않음
  animation: ${fadeIn} 1s ease-in-out 3s forwards; */
`;
