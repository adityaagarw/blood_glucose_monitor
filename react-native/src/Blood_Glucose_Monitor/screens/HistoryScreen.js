// screens/HistoryScreen.js
import React, { useState, useEffect } from 'react';
import { View, Text, FlatList } from 'react-native';
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

const HistoryScreen = () => {
  const [entries, setEntries] = useState([]);

  useEffect(() => {
    const fetchEntries = async () => {
      const realm = await Realm.open({schema: [EntrySchema]});
      const entries = realm.objects('Entry').sorted('date', false);
      setEntries(entries);
    };

    fetchEntries();
  }, []);

  return (
    <View>
      <Text>Glucose Level History</Text>
      <FlatList
        data={entries}
        keyExtractor={item => item.id.toString()}
        renderItem={({ item }) => (
          <View>
            <Text>{`Glucose Level: ${item.glucoseLevel}, Date: ${item.date}`}</Text>
          </View>
        )}
      />
    </View>
  );
};

export default HistoryScreen;
