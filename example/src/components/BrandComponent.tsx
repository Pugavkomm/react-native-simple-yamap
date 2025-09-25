import { StyleSheet, Text } from 'react-native';
import { MAP_UI_Z_INDEX } from '../const';
import React from 'react';

const BrandComponent: React.FC = () => {
  return (
    <Text style={styles.brandText}>
      SimpleYamap <Text style={styles.subBrandText}>Demo</Text>
    </Text>
  );
};

const styles = StyleSheet.create({
  brandText: {
    position: 'absolute',
    bottom: 32,
    right: 16,
    backgroundColor: 'rgba(30,0,0,0.8)',
    borderWidth: 2,
    borderColor: 'rgba(110,0,0,0.8)',
    padding: 16,
    borderRadius: 4,
    color: '#fff',
    fontWeight: 'bold',
    fontSize: 18,
    lineHeight: 24,
    zIndex: MAP_UI_Z_INDEX,
  },
  subBrandText: {
    fontSize: 10,
  },
});

export default BrandComponent;
