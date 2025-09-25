import React from 'react';
import { Button, StyleSheet, Text, View } from 'react-native';
import { MAP_UI_Z_INDEX } from '../const';

interface ButtonBlockProps {
  left?: () => void;
  right?: () => void;
  up?: () => void;
  down?: () => void;
  zoomIn?: () => void;
  zoomOut?: () => void;
  random?: () => void;
  nightModeToggle?: () => void;
  tiltUp?: () => void;
  tiltDown?: () => void;
  azimuthIncrease?: () => void;
  azimuthDecrease?: () => void;
  setCenter?: () => void;
}

const MapNavigBtnsComponent: React.FC<ButtonBlockProps> = (props) => {
  return (
    <View style={styles.buttonBlock}>
      <Button title={'up'} onPress={props.up} />
      <View style={styles.buttonRow}>
        <Button title={'left'} onPress={props.left} />
        <Button title={'right'} onPress={props.right} />
      </View>
      <Button title={'down'} onPress={props.down} />
      <Text style={styles.buttonHeader}>Zoom</Text>
      <View style={styles.buttonRow}>
        <Button title={'+'} onPress={props.zoomIn} />
        <Button title={'-'} onPress={props.zoomOut} />
      </View>
      <Button title={'Random'} onPress={props.random} />
      <Button title={'Night toggle'} onPress={props.nightModeToggle} />
      <Text style={styles.buttonHeader}>Tilt</Text>
      <View style={styles.buttonRow}>
        <Button title={'+'} onPress={props.tiltUp} />
        <Button title={'-'} onPress={props.tiltDown} />
      </View>
      <Text style={styles.buttonHeader}>Azimuth</Text>
      <View style={styles.buttonRow}>
        <Button title={'+'} onPress={props.azimuthIncrease} />
        <Button title={'-'} onPress={props.azimuthDecrease} />
      </View>
      <Button title={'37.62, 55.75'} onPress={props.setCenter} />
    </View>
  );
};

const styles = StyleSheet.create({
  buttonBlock: {
    flex: 1,
    marginTop: 128,
    position: 'absolute',
    alignItems: 'center',
    justifyContent: 'flex-start',
    backgroundColor: 'rgba(30,0,0,0.8)',
    borderRadius: 8,
    padding: 4,
    borderWidth: 2,
    borderColor: 'rgba(110,0,0,0.8)',
    bottom: 190,
    zIndex: MAP_UI_Z_INDEX,
  },
  buttonRow: {
    flexDirection: 'row',
    gap: 8,
  },
  buttonHeader: {
    fontSize: 16,
    color: '#fff',
    fontWeight: 'bold',
  },
});

export default MapNavigBtnsComponent;
