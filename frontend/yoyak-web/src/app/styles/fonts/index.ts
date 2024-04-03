import { Noto_Sans_KR } from 'next/font/google';

const black = Noto_Sans_KR({
    weight: '900',
    display: 'fallback',
    subsets: ['latin'],
    style: 'normal',
    variable: '--noto-sans_KR-bold',
    fallback: [
      '-apple-system',
      'Malgun Gothic',
      'Apple SD Gothic Neo',
      'Roboto',
      'Apple Color Emoji',
      'Segoe UI Emoji',
      'Segoe UI Symbol',
      'sans-serif',
    ],
  });
  
  const extraBold = Noto_Sans_KR({
    weight: '800',
    display: 'fallback',
    subsets: ['latin'],
    style: 'normal',
    variable: '--noto-sans_KR-bold',
    fallback: [
      '-apple-system',
      'Malgun Gothic',
      'Apple SD Gothic Neo',
      'Roboto',
      'Apple Color Emoji',
      'Segoe UI Emoji',
      'Segoe UI Symbol',
      'sans-serif',
    ],
  });
  
  const bold = Noto_Sans_KR({
    weight: '700',
    display: 'fallback',
    subsets: ['latin'],
    style: 'normal',
    variable: '--noto-sans_KR-bold',
    fallback: [
      '-apple-system',
      'Malgun Gothic',
      'Apple SD Gothic Neo',
      'Roboto',
      'Apple Color Emoji',
      'Segoe UI Emoji',
      'Segoe UI Symbol',
      'sans-serif',
    ],
  });
  
  const semiBold = Noto_Sans_KR({
    weight: '600',
    display: 'fallback',
    subsets: ['latin'],
    style: 'normal',
    variable: '--noto-sans_KR-medium',
    fallback: [
      '-apple-system',
      'Malgun Gothic',
      'Apple SD Gothic Neo',
      'Roboto',
      'Apple Color Emoji',
      'Segoe UI Emoji',
      'Segoe UI Symbol',
      'sans-serif',
    ],
  });
  
  const medium = Noto_Sans_KR({
    weight: '500',
    display: 'fallback',
    subsets: ['latin'],
    style: 'normal',
    variable: '--noto-sans_KR-medium',
    fallback: [
      '-apple-system',
      'Malgun Gothic',
      'Apple SD Gothic Neo',
      'Roboto',
      'Apple Color Emoji',
      'Segoe UI Emoji',
      'Segoe UI Symbol',
      'sans-serif',
    ],
  });
  
  const regular = Noto_Sans_KR({
    weight: '400',
    display: 'fallback',
    subsets: ['latin'],
    style: 'normal',
    variable: '--noto-sans_KR-bold',
    fallback: [
      '-apple-system',
      'Malgun Gothic',
      'Apple SD Gothic Neo',
      'Roboto',
      'Apple Color Emoji',
      'Segoe UI Emoji',
      'Segoe UI Symbol',
      'sans-serif',
    ],
  });
  
  const light = Noto_Sans_KR({
    weight: '300',
    display: 'fallback',
    subsets: ['latin'],
    style: 'normal',
    variable: '--noto-sans_KR-medium',
    fallback: [
      '-apple-system',
      'Malgun Gothic',
      'Apple SD Gothic Neo',
      'Roboto',
      'Apple Color Emoji',
      'Segoe UI Emoji',
      'Segoe UI Symbol',
      'sans-serif',
    ],
  });
  
  const extraLight = Noto_Sans_KR({
    weight: '200',
    display: 'fallback',
    subsets: ['latin'],
    style: 'normal',
    variable: '--noto-sans_KR-bold',
    fallback: [
      '-apple-system',
      'Malgun Gothic',
      'Apple SD Gothic Neo',
      'Roboto',
      'Apple Color Emoji',
      'Segoe UI Emoji',
      'Segoe UI Symbol',
      'sans-serif',
    ],
  });
  
  const thin = Noto_Sans_KR({
    weight: '100',
    display: 'fallback',
    subsets: ['latin'],
    style: 'normal',
    variable: '--noto-sans_KR-medium',
    fallback: [
      '-apple-system',
      'Malgun Gothic',
      'Apple SD Gothic Neo',
      'Roboto',
      'Apple Color Emoji',
      'Segoe UI Emoji',
      'Segoe UI Symbol',
      'sans-serif',
    ],
  });
  
  export { thin, extraLight, light, regular, medium, semiBold, bold, extraBold, black };
  