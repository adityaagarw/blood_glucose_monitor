// screens/AddEntryScreen.js
import React, { useState } from 'react';
import { Button, TextInput, View, Text } from 'react-native';
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

const AddEntryScreen = () => {
  const [glucoseLevel, setGlucoseLevel] = useState('');
  const [selectedDate, setSelectedDate] = useState(new Date());
  const [date, setDate] = useState(new Date());
  const [show, setShow] = useState(false);

  const onChange = (event, selectedDate) => {
    const currentDate = selectedDate || date;
    setShow(Platform.OS === 'ios');
    setDate(currentDate);
  };

  const showDatePicker = () => {
    setShow(true);
  };

  const handleAddEntry = async () => {
    try {
      const newEntry = {
        id: Date.now(),
        glucoseLevel: parseInt(glucoseLevel),
        date: selectedDate,
      };

      const realm = await Realm.open({schema: [EntrySchema]});
      realm.write(() => {
        realm.create('Entry', newEntry);
      });

      setGlucoseLevel('');
      setSelectedDate(new Date());
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <View>
      <Text>Add a new glucose reading</Text>
      <TextInput
        placeholder="Glucose level"
        keyboardType="numeric"
        value={glucoseLevel}
        onChangeText={setGlucoseLevel}
      />
      <Button onPress={showDatePicker} title="Show date picker!" />
      {show && (
        <DateTimePicker
          testID="dateTimePicker"
          value={date}
          mode="date"
          display="default"
          onChange={onChange}
        />
      )}
      <Button title="Add Entry" onPress={handleAddEntry} />
      </View>
  );
};

export default AddEntryScreen;