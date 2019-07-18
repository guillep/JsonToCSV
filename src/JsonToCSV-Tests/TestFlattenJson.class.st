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

{ #category : #'tests-array-denormalized' }
TestFlattenJson >> testDoNotInlineNestedJSONArrayGeneratesOneElementPerArrayElement [

	| json flattened |
	json := { 
		'y' -> { 4. 5. 6. }.
	} asDictionary.
	
	flattened := JSONFlattener new
		denormalizeArrays: true;
		flatten: json.
	
	self assert: flattened size equals: 3
]

{ #category : #'tests-array-denormalized' }
TestFlattenJson >> testDoNotInlineNestedJSONArrayPreservesValues [

	| json flattened |
	json := { 
		'y' -> { 4. 5. 6. }.
	} asDictionary.
	
	flattened := JSONFlattener new
		denormalizeArrays: true;
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

{ #category : #'tests-objects' }
TestFlattenJson >> testFlattenEmptyJSONArrayIsEmpty [

	| json flattened |
	json := #().
	
	flattened := JSONFlattener flatten: json.
	
	self assert: flattened isEmpty.
]

{ #category : #'tests-objects' }
TestFlattenJson >> testFlattenJSONArrayWithSingleElementHasSingleElement [

	| json flattened |
	json := { { 'x' -> 1 } asDictionary }.
	
	flattened := JSONFlattener flatten: json.
	
	self assert: flattened size equals: 1.
]

{ #category : #'tests-arrays-normalized' }
TestFlattenJson >> testFlattenNestedJSONArrayFlattensPropertiesUsingIndex [

	| json flattened |
	json := { 
		'y' -> { 4. 5. 6. }.
	} asDictionary.
	
	flattened := JSONFlattener new
		denormalizeArrays: false;
		flatten: json.
	
	self assertProperty: 'y_1' of: flattened first equals: 4.
	self assertProperty: 'y_2' of: flattened first equals: 5.
	self assertProperty: 'y_3' of: flattened first equals: 6.
]

{ #category : #'tests-arrays-normalized' }
TestFlattenJson >> testFlattenNestedJSONArrayGeneratesSingleRecord [

	| json flattened |
	json := { 
		'y' -> { 4. 5. 6. }.
	} asDictionary.
	
	flattened := JSONFlattener new
		denormalizeArrays: false;
		flatten: json.
	
	self assert: flattened size equals: 1
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
TestFlattenJson >> testFlattenSiblingArraysCombinesThem [

	| json flattened |
	json := {
		'x' -> {1. 2. 3}.
		'y' -> {4. 5. 6}.
	} asDictionary.
	
	flattened := JSONFlattener new
		denormalizeArrays: true;
		flatten: json.
	
	self assert: (flattened at: 1) equals: { 'x' -> 1 . 'y' -> 4 } asDictionary.
	self assert: (flattened at: 2) equals: { 'x' -> 1 . 'y' -> 5 } asDictionary.
	self assert: (flattened at: 3) equals: { 'x' -> 1 . 'y' -> 6 } asDictionary.
	self assert: (flattened at: 4) equals: { 'x' -> 2 . 'y' -> 4 } asDictionary.
	self assert: (flattened at: 5) equals: { 'x' -> 2 . 'y' -> 5 } asDictionary.
	self assert: (flattened at: 6) equals: { 'x' -> 2 . 'y' -> 6 } asDictionary.
	self assert: (flattened at: 7) equals: { 'x' -> 3 . 'y' -> 4 } asDictionary.
	self assert: (flattened at: 8) equals: { 'x' -> 3 . 'y' -> 5 } asDictionary.
	self assert: (flattened at: 9) equals: { 'x' -> 3 . 'y' -> 6 } asDictionary.

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

{ #category : #'tests-objects' }
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
