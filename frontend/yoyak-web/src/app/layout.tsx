import type { Metadata } from "next";
import { notoSansKr } from "styles/styles";

export const metadata: Metadata = {
  title: "요약 - yoyak",
  description: "AI 약 검색 및 복용 알림 app 서비스",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className={notoSansKr.regular.className}>
        {children}
      </body>
    </html>
  );
}
