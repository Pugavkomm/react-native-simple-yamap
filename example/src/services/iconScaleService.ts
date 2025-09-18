import { Platform } from 'react-native';

const iconScaleService = (scale: number): number => {
  if (Platform.OS === 'android' && !__DEV__) {
    return scale / 2;
  }
  return scale;
};

export default iconScaleService;
