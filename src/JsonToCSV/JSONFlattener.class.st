Class {
	#name : #JSONFlattener,
	#superclass : #Object,
	#instVars : [
		'inlineArrays'
	],
	#category : #JsonToCSV
}

{ #category : #flatten }
JSONFlattener class >> flatten: aJSON [

	^ self new flatten: aJSON
]

{ #category : #arrays }
JSONFlattener >> expandJSONArray: anArray withParentName: aName [

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

	inlineArrays ifTrue: [ 
		^ self inlineJSONArray: anArray withParentName: aName ].
	
	^ self expandJSONArray: anArray withParentName: aName
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
		result := flattenedSubCollection flatCollect: [ :subflatten |
			result collect: [ :previousSubflatten | | newSubflatten |
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
	inlineArrays := true
]

{ #category : #accessing }
JSONFlattener >> inlineArrays: aBoolean [
	
	inlineArrays := aBoolean
]

{ #category : #flattening }
JSONFlattener >> inlineJSONArray: anArray withParentName: aName [
	
	| result |
	result := Dictionary new.
	anArray withIndexDo: [ :elem :index |
		result at: index asString put: elem.
	].
	^ self flatten: result parentName: aName
]
