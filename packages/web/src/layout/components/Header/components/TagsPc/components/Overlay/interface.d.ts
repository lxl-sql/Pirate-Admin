
export type OverlayType = 'refresh' | 'close' | 'fullScreen' | 'closeOther' | 'closeAll'

export interface OverlayProps {
  disabled?: (type: OverlayType) => boolean
}
