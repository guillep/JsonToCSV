"
I transform a Json to a CSV, first flattening the Json object using JSONFlattener.
Examples:

(JsonToCSV transformStream: (FileLocator documents / 'nlp4j.json') readStream) lines size.

fileRef := FileLocator documents / 'nlp4j.json'.
csvRef := fileRef withoutExtension , 'csv'.
csvRef writeStreamDo: [ :writeStream |
  fileRef readStreamDo: [ :readStream |
    JsonToCSV new
      inputStream: readStream;
      outputStream: writeStream;
      transform ] ].

fileRef := FileLocator documents / 'joda-time.json'.
csvRef := fileRef withoutExtension , 'csv'.
csvRef writeStreamDo: [ :writeStream |
  fileRef readStreamDo: [ :readStream |
    JsonToCSV new
      inputStream: readStream;
      outputStream: writeStream;
      transform ] ].
"
Class {
	#name : #JsonToCSV,
	#superclass : #Object,
	#instVars : [
		'inputStream',
		'outputStream',
		'fields',
		'json',
		'normalization'
	],
	#category : #JsonToCSV
}

{ #category : #transforming }
JsonToCSV class >> transformStream: aReadStream [
	
	^ String streamContents: [ :writeStream |
		self new
			inputStream: aReadStream;
			outputStream: writeStream;
			transform ]
]

{ #category : #transforming }
JsonToCSV class >> transformString: aString [
	
	^ aString readStreamDo: [ :stream |
		self transformStream: stream ]
]

{ #category : #fields }
JsonToCSV >> computeFieldNames [
	
	^ (self flattenedJson flatCollect: [ :e | e keys ] as: Set) asArray
]

{ #category : #fields }
JsonToCSV >> computeFieldNames: aCollection [ 
	
	^ (aCollection flatCollect: [ :e | e keys ] as: Set) asArray
]

{ #category : #transforming }
JsonToCSV >> fieldNames [

	^ fields ifNil: [ fields := self computeFieldNames ]
]

{ #category : #transforming }
JsonToCSV >> flattenedJson [

	^ json ifNil: [
		json := JSONFlattener new
			denormalizeArrays: normalization not;
			flatten: (NeoJSONReader on: inputStream) next ]
]

{ #category : #initialization }
JsonToCSV >> initialize [
	super initialize.
	outputStream := String new writeStream.
	normalization := false
]

{ #category : #accessing }
JsonToCSV >> inputStream: aZnCharacterReadStream [ 
	
	inputStream := aZnCharacterReadStream 
]

{ #category : #configuration }
JsonToCSV >> normalizeArraysIntoFields [

	normalization := true
]

{ #category : #accessing }
JsonToCSV >> outputStream: aZnCharacterWriteStream [ 

	outputStream := aZnCharacterWriteStream 
]

{ #category : #transforming }
JsonToCSV >> transform [

	| writer |
	writer := NeoCSVWriter on: outputStream.
	writer
		fieldWriter: #raw.
	self fieldNames do: [ :each |
		writer addFieldAccessor: [ :object |
		writer writeOptionalQuotedField: (object at: each ifAbsent: [ nil ]) ] ].

	writer
		writeHeader: self fieldNames;
		nextPutAll: self flattenedJson;
		flush
]
