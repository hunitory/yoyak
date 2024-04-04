import styled from "@emotion/styled";
import { PALETTE, notoSansKr } from "styles";


export const Button = styled.button`
  width: 240px;
  height: 48px;
  background-color: ${PALETTE.MAIN_BLUE};
  border: 0;
  border-radius: 20px;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 10px 10px;
  cursor: pointer;
`;

export const ButtonText = styled.p`
  font-size: 20px;
  font-family: ${notoSansKr.bold.style.fontFamily};
  font-weight: ${notoSansKr.bold.style.fontWeight};
  color: white;
`;
