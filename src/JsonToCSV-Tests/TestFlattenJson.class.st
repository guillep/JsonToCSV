Class {
	#name : #TestFlattenJson,
	#superclass : #TestCase,
	#category : #'JsonToCSV-Tests'
}

{ #category : #asserting }
TestFlattenJson >> assertProperty: aString of: aCollection equals: aValue [
	
	self
		assert: (aCollection at: aString)
		equals: aValue
]

{ #category : #asserting }
TestFlattenJson >> assertProperty: aString of: aCollection equalsIn: aCollection2 [
	
	self
		assertProperty: aString
		of: aCollection
		equals: (aCollection2 at: aString)
]

{ #category : #tests }
TestFlattenJson >> testDoNotInlineNestedJSONArrayGeneratesOneElementPerArrayElement [

	| json flattened |
	json := { 
		'y' -> { 4. 5. 6. }.
	} asDictionary.
	
	flattened := JSONFlattener new
		inlineArrays: false;
		flatten: json.
	
	self assert: flattened size equals: 3
]

{ #category : #tests }
TestFlattenJson >> testDoNotInlineNestedJSONArrayPreservesValues [

	| json flattened |
	json := { 
		'y' -> { 4. 5. 6. }.
	} asDictionary.
	
	flattened := JSONFlattener new
		inlineArrays: false;
		flatten: json.
	
	self assertProperty: 'y' of: flattened first equals: 4.
	self assertProperty: 'y' of: flattened second equals: 5.
	self assertProperty: 'y' of: flattened third equals: 6.
]

{ #category : #'tests-objects' }
TestFlattenJson >> testFlattenComplexJSONObjectPreservesNonNestedProperties [

	| json flattened |
	json := {
		'x' -> 1.
		'y' -> {
			'z' -> 2
		} asDictionary.
	} asDictionary.
	
	flattened := JSONFlattener flatten: json.
	
	self assertProperty: 'x' of: flattened first equals: 1.
]

{ #category : #'tests-arrays' }
TestFlattenJson >> testFlattenEmptyJSONArrayIsEmpty [

	| json flattened |
	json := #().
	
	flattened := JSONFlattener flatten: json.
	
	self assert: flattened isEmpty.
]

{ #category : #'tests-arrays' }
TestFlattenJson >> testFlattenJSONArrayWithSingleElementHasSingleElement [

	| json flattened |
	json := { { 'x' -> 1 } asDictionary }.
	
	flattened := JSONFlattener flatten: json.
	
	self assert: flattened size equals: 1.
]

{ #category : #tests }
TestFlattenJson >> testFlattenNestedJSONArrayFlattensPropertiesUsingIndex [

	| json flattened |
	json := { 
		'y' -> { 4. 5. 6. }.
	} asDictionary.
	
	flattened := JSONFlattener flatten: json.
	
	self assertProperty: 'y_1' of: flattened first equals: 4.
	self assertProperty: 'y_2' of: flattened first equals: 5.
	self assertProperty: 'y_3' of: flattened first equals: 6.
]

{ #category : #'tests-objects' }
TestFlattenJson >> testFlattenNestedJSONObjectFlattensProperty [

	| json flattened |
	json := { 
		'y' -> {
			'z' -> 1
		} asDictionary.
	} asDictionary.
	
	flattened := JSONFlattener flatten: json.
	
	self assertProperty: 'y_z' of: flattened first equals: 1.
]

{ #category : #'tests-objects' }
TestFlattenJson >> testFlattenNestedJSONObjectReturnsSingleItem [

	| json flattened |
	json := { 
		'y' -> {
			'z' -> 1
		} asDictionary.
	} asDictionary.
	
	flattened := JSONFlattener flatten: json.
	
	self assert: flattened size equals: 1.
]

{ #category : #'tests-objects' }
TestFlattenJson >> testFlattenSimpleJSONObjectReturnsSingleItem [

	| json flattened |
	json := { 
		'x' -> 1.
		'y' -> 2.
	} asDictionary.
	
	flattened := JSONFlattener flatten: json.
	
	self assert: flattened size equals: 1.
]

{ #category : #'tests-arrays' }
TestFlattenJson >> testFlattenedJSONObjectInArrayHasSamePropertiesAsOriginalObject [

	| json flattened |
	json := { { 'x' -> 1 } asDictionary }.

	
	flattened := JSONFlattener flatten: json.

	self assertProperty: 'x' of: flattened first equalsIn: json first
]

{ #category : #'tests-objects' }
TestFlattenJson >> testFlattenedSimpleJSONObjectHasSamePropertiesAsOriginalObject [

	| json flattened |
	json := { 
		'x' -> 1.
		'y' -> 2.
	} asDictionary.
	
	flattened := JSONFlattener flatten: json.

	self assertProperty: 'x' of: flattened first equalsIn: json.
	self assertProperty: 'y' of: flattened first equalsIn: json.
]
