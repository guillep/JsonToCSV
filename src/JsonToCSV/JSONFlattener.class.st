"
I flatten Json objects into records. Each field in a json object becomes a column in the record, where the field name is the column name. When there are nested objects, the column name is the path to arrive to the field. For example:

{ ""x"": { ""y"": 7 } }

=>

x_y
7

Arrays have two main mapping strategies: 
 - either each element in the array is mapped into a different field

{ ""x"": [ 1,2,3 ] } =>
x_1,x_2,x_3
1,2,3

 - or each element spawns a new record, making permutations

{ ""x"": [ 1,2,3 ] } =>
x
1
2
3
"
Class {
	#name : #JSONFlattener,
	#superclass : #Object,
	#instVars : [
		'denormalizeArrays'
	],
	#category : #JsonToCSV
}

{ #category : #flatten }
JSONFlattener class >> flatten: aJSON [

	^ self new flatten: aJSON
]

{ #category : #accessing }
JSONFlattener >> denormalizeArrays: aBoolean [
	
	denormalizeArrays := aBoolean
]

{ #category : #arrays }
JSONFlattener >> expandJSONArrayAsRecords: anArray withParentName: aName [

	^ anArray flatCollect: [ :each |
		self flatten: each parentName: aName ]
]

{ #category : #flattening }
JSONFlattener >> flatten: aJSON [
	
	^ aJSON jsonFlattenOn: self
]

{ #category : #flattening }
JSONFlattener >> flatten: aJSON parentName: aName [
	
	^ aJSON jsonFlattenOn: self parentName: aName
]

{ #category : #flattening }
JSONFlattener >> flattenJSONArray: anArray [ 
	
	^ anArray flatCollect: [ :each | self flatten: each ]
]

{ #category : #flattening }
JSONFlattener >> flattenJSONArray: anArray parentName: aName [
	
	anArray ifEmpty: [ ^ anArray ].

	denormalizeArrays ifTrue: [ 
		^ self expandJSONArrayAsRecords: anArray withParentName: aName].
	
	^ self inlineJSONArrayAsFields: anArray withParentName: aName
]

{ #category : #flattening }
JSONFlattener >> flattenJSONBoolean: aJSONBoolean parentName: aName [

	^ self flattenJSONSimpleObject: aJSONBoolean parentName: aName
]

{ #category : #flattening }
JSONFlattener >> flattenJSONNumber: aJSONNumber parentName: aName [

	^ self flattenJSONSimpleObject: aJSONNumber parentName: aName
]

{ #category : #flattening }
JSONFlattener >> flattenJSONObject: aJSONObject [

	^ self flattenJSONObject: aJSONObject parentName: ''
]

{ #category : #flattening }
JSONFlattener >> flattenJSONObject: aJSONObject parentName: parentName [

	| result prefix |
	result := { OrderedDictionary new}.
	prefix := parentName ifNotEmpty: [ parentName , '_' ].
	aJSONObject associationsDo: [ :association | | flattenedSubCollection |
		flattenedSubCollection := self flatten: association value parentName: association key.
		result := result flatCollect: [ :previousSubflatten |
			flattenedSubCollection collect: [ :subflatten | | newSubflatten |
				newSubflatten := OrderedDictionary new.
				newSubflatten addAll: previousSubflatten.
				subflatten associationsDo: [ :each |
					newSubflatten at: prefix, each key put: each value ].
				newSubflatten ] ] ].
	^ result
]

{ #category : #flattening }
JSONFlattener >> flattenJSONSimpleObject: anObject parentName: aName [

	^ {{ aName -> anObject } asDictionary}
]

{ #category : #flattening }
JSONFlattener >> flattenJSONString: aJSONString parentName: aName [
	
	^ self flattenJSONSimpleObject: aJSONString parentName: aName
]

{ #category : #initialization }
JSONFlattener >> initialize [
	super initialize.
	denormalizeArrays := true
]

{ #category : #arrays }
JSONFlattener >> inlineJSONArrayAsFields: anArray withParentName: aName [
	
	| result |
	result := OrderedDictionary new.
	anArray withIndexDo: [ :elem :index |
		result at: index asString put: elem.
	].
	^ self flatten: result parentName: aName
]
