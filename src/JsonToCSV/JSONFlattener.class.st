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
	result := {Dictionary new}.
	prefix := parentName ifNotEmpty: [ parentName , '_' ].
	aJSONObject associationsDo: [ :association | | flattenedSubCollection |
		flattenedSubCollection := self flatten: association value parentName: association key.
		result := result flatCollect: [ :previousSubflatten |
			flattenedSubCollection collect: [ :subflatten | | newSubflatten |
				newSubflatten := Dictionary new.
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
	result := Dictionary new.
	anArray withIndexDo: [ :elem :index |
		result at: index asString put: elem.
	].
	^ self flatten: result parentName: aName
]
