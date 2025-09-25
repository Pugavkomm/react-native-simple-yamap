import { processColor } from 'react-native';

const simpleColorConverter = (color: string): number | undefined => {
  const processed = processColor(color);
  if (typeof processed === 'number') {
    return processed;
  }
  return undefined;
};

export default simpleColorConverter;
