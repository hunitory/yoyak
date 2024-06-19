import type { Metadata } from "next";

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
    <html>
      <link rel="icon" href={"/image/logo.png"} />
      <body>{children}</body>
    </html>
  );
}
