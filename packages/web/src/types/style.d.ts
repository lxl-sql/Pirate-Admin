type DisplayType = "flex" | "block" | "inline-block" | "inline" | "grid";

export type CSSPropertiesType = {
  [property: string]: string;
  minWidth?: string;
  whiteSpace?: string;
  overflow?: string;
  display?: DisplayType;
  textOverflow?: string;
};

