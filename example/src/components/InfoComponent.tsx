import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { MAP_UI_Z_INDEX } from '../const';

interface TextInfoBlockProps {
  lon?: number;
  lat?: number;
  zoom?: number;
  tilt?: number;
  azimuth?: number;
}

interface TextInfoProps {
  text: string;
}

const TextInfo: React.FC<TextInfoProps> = (props) => {
  return <Text style={styles.textInfo}>{props.text}</Text>;
};

const InfoComponent: React.FC<TextInfoBlockProps> = (props) => {
  return (
    <View style={styles.textInfoBlock}>
      <TextInfo text={`lon: ${props.lon}`} />
      <TextInfo text={`lat: ${props.lat}`} />
      <TextInfo text={`zoom: ${props.zoom}`} />
      <TextInfo text={`tilt: ${props.tilt}`} />
      <TextInfo text={`azimuth: ${props.azimuth}`} />
    </View>
  );
};

const styles = StyleSheet.create({
  textInfoBlock: {
    position: 'absolute',
    bottom: 64,
    justifyContent: 'flex-start',
    backgroundColor: 'rgba(30,0,0,0.8)',
    borderRadius: 8,
    padding: 16,
    borderWidth: 2,
    borderColor: 'rgba(110,0,0,0.8)',
    zIndex: MAP_UI_Z_INDEX,
  },
  textInfo: {
    fontSize: 11,
    color: '#fff',
  },
});

export default InfoComponent;
