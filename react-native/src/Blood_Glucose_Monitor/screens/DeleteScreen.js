// screens/DeleteScreen.js
import React, { useState } from 'react';
import { Button, View, Text } from 'react-native';
import DateTimePicker from '@react-native-community/datetimepicker';
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

const DeleteScreen = () => {
  const [startDate, setStartDate] = useState(new Date());
  const [endDate, setEndDate] = useState(new Date());
  const [showStartDatePicker, setShowStartDatePicker] = useState(false);
  const [showEndDatePicker, setShowEndDatePicker] = useState(false);

  const handleDeleteEntries = async () => {
    try {
      const realm = await Realm.open({schema: [EntrySchema]});
      const entriesToDelete = realm.objects('Entry').filtered('date >= $0 AND date <= $1', startDate, endDate);
      
      realm.write(() => {
        realm.delete(entriesToDelete);
      });
      
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <View>
      <Text>Delete Entries</Text>
      <Button title="Select Start Date" onPress={() => setShowStartDatePicker(true)} />
      {showStartDatePicker && (
        <DateTimePicker
          value={startDate}
          mode="date"
          onChange={(event, selectedDate) => {
            setShowStartDatePicker(false);
            setStartDate(selectedDate || new Date());
          }}
        />
      )}
      <Button title="Select End Date" onPress={() => setShowEndDatePicker(true)} />
      {showEndDatePicker && (
        <DateTimePicker
          value={endDate}
          mode="date"
          onChange={(event, selectedDate) => {
            setShowEndDatePicker(false);
            setEndDate(selectedDate || new Date());
          }}
        />
      )}
      <Button title="Delete Entries" onPress={handleDeleteEntries} />
    </View>
  );
};

export default DeleteScreen;