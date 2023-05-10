@startuml
!theme sandstone
class MyApp {
  - homeScreen: HomeScreen
  - graphScreen: GraphScreen
  - tableScreen: TableScreen
  - deleteScreen: DeleteScreen
  + main()
}

class HomeScreen {
  - _formKey: GlobalKey<FormState>
  - _glucoseLevelController: TextEditingController
  - _dateController: TextEditingController
  - _timeController: TextEditingController
  - _selectedType: String
  - _selectedFood: String
  + initState()
  + dispose()
  - _onSubmit(): void
  - _showDatePicker(): Future<void>
  - _showTimePicker(): Future<void>
  + build(): Widget
}

class GlucoseReading {
  - id: int
  - date: DateTime
  - time: TimeOfDay
  - type: String
  - glucoseLevel: int
  - food: String
  + toMap(): Map<String, dynamic>
  + GlucoseReading.fromMap(Map<String, dynamic>, String): GlucoseReading
}

class PPReading {
  - id: int
  - readingId: int
  - food: String
  + toMap(): Map<String, dynamic>
  + PPReading.fromMap(Map<String, dynamic>): PPReading
}

class DatabaseHelper {
  - _database: Database
  + DatabaseHelper()
  - _initDatabase(): Future<Database>
  + database: Future<Database>
  + insertReading(GlucoseReading): Future<void>
  + getReadings(): Future<List<GlucoseReading>>
  + deleteReading(int): Future<void>
  + deleteReadingsByDateRange(DateTime, DateTime): Future<void>
}

class GraphScreen {
  - _selectedTabIndex: int
  - _readings: List<GlucoseReading>
  - _seriesList: List<charts.Series<GlucoseReading, DateTime>>
  - _tabs: List<Tab>
  + initState()
  - _loadReadings(): Future<void>
  - _buildSeriesList(List<GlucoseReading>): List<charts.Series<GlucoseReading, DateTime>>
  - _buildSeries(List<GlucoseReading>, String, charts.Color): charts.Series<GlucoseReading, DateTime>
  + build(): Widget
}

class TableScreen {
  - _readings: List<GlucoseReading>
  + initState()
  - _loadReadings(): Future<void>
  + build(): Widget
}

class DeleteScreen {
  - _formKey: GlobalKey<FormState>
  - _idController: TextEditingController
  - _startDateController: TextEditingController
  - _endDateController: TextEditingController
  - _selectedOption: String
  + initState()
  + dispose()
  - _onSubmit(): void
  - _showDatePicker(String): Future<void>
  - _showConfirmationDialog(): Future<void>
  + build(): Widget
}

MyApp --> HomeScreen
MyApp --> GraphScreen
MyApp --> TableScreen
MyApp --> DeleteScreen
HomeScreen --> GlucoseReading
GlucoseReading --> PPReading
DatabaseHelper --> GlucoseReading
DatabaseHelper --> PPReading
GraphScreen --> GlucoseReading
TableScreen --> GlucoseReading
DeleteScreen --> GlucoseReading
@enduml
