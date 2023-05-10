// screens/GraphScreen.js
import React, { useState, useEffect } from 'react';
import { View } from 'react-native';
import { LineChart } from 'react-native-svg-charts';
import Realm from 'realm';

const EntrySchema = {
  name: 'Entry',
  primaryKey: 'id',
  properties: {
    id: 'int',
    glucoseLevel: 'int',
    date: 'date',
  },
};

const GraphScreen = () => {
  const [glucoseLevels, setGlucoseLevels] = useState([]);

  useEffect(() => {
    const fetchEntries = async () => {
      const realm = await Realm.open({schema: [EntrySchema]});
      const entries = realm.objects('Entry').sorted('date', false);
      setGlucoseLevels(entries.map(entry => entry.glucoseLevel));
    };

    fetchEntries();
  }, []);

  return (
    <View>
      <LineChart
        data={glucoseLevels}
        svg={{ stroke: 'rgb(134, 65, 244)' }}
        style={{ height: 200 }}
      />
    </View>
  );
};

export default GraphScreen;