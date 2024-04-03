export const PALETTE = {
  MAIN_BLUE: "#5A87FF",
  SUB_BLUE: "#EEF3FF",
  MAIN_BLACK: "#262626",
} as {
  [key: string]: string;
  MAIN_BLUE: "#5A87FF";
  SUB_BLUE: "#EEF3FF";
  MAIN_BLACK: "#262626";
};

type PaletteType = typeof PALETTE;
type ValueOfPalette<PaletteType> = PaletteType[keyof PaletteType];

export type { PaletteType, ValueOfPalette };
