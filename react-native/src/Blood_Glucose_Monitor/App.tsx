// App.js
import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import AddEntryScreen from './screens/AddEntryScreen';
import HistoryScreen from './screens/HistoryScreen';
import GraphScreen from './screens/GraphScreen';
import DeleteScreen from './screens/DeleteScreen';

const Tab = createBottomTabNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Tab.Navigator>
        <Tab.Screen name="Add Entry" component={AddEntryScreen} />
        <Tab.Screen name="History" component={HistoryScreen} />
        <Tab.Screen name="Graph" component={GraphScreen} />
        <Tab.Screen name="Delete" component={DeleteScreen} />
      </Tab.Navigator>
    </NavigationContainer>
  );
}