import Image from "next/image";
import * as styled from "./_style";
import * as Comp from "@/components";

export default function Home() {
  return (
    <styled.Main>
      {/* <styled.LogoWrapper>
        <Image
          src={"/image/logo.png"}
          alt=""
          width={70}
          height={70}
          quality={100}
        ></Image>
      </styled.LogoWrapper> */}
      <styled.BannerContainer>
        <styled.leftWrapper>
          <Image
            src={"/image/yoyak.png"}
            alt=""
            width={400}
            height={450}
            quality={100}
          />
        </styled.leftWrapper>
        <styled.RightWrapper>
          <styled.phoneWrapper>
            <Image
              src={"/image/phone1.png"}
              alt=""
              width={280}
              height={440}
              quality={100}
            />
            <Image
              src={"/image/phone2.png"}
              alt=""
              width={290}
              height={440}
              quality={100}
            />
          </styled.phoneWrapper>
          <styled.ButtonWrapper>
            <Comp.downloadButton></Comp.downloadButton>
          </styled.ButtonWrapper>
        </styled.RightWrapper>
      </styled.BannerContainer>
    </styled.Main>
  );
}
