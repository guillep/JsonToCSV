Class {
	#name : #TestJsonToCSV,
	#superclass : #TestCase,
	#category : #'JsonToCSV-Tests'
}

{ #category : #tests }
TestJsonToCSV >> testConvertNonHomogeneousObjects [

	| csv |
	csv := JsonToCSV transformString: '[{ "x" : 1, "z" : 2}, {"y": true, "z" : "test" }]'.
	self 
		assert: (csv withLineEndings: String lf)
		equals: 
'"x","y","z"
1,,2
,true,test
' withUnixLineEndings 
]

{ #category : #tests }
TestJsonToCSV >> testConvertNormalizedArray [

	| csv |
	csv := String streamContents: [:stream | 
		JsonToCSV new
			normalizeArraysIntoFields;
			inputStream: '{ "y" : [ 1, 2, 3 ] }' readStream;
			outputStream: stream;
			transform ].
	self 
		assert: (csv withLineEndings: String lf)
		equals: 
'"y_1","y_2","y_3"
1,2,3
' withUnixLineEndings 
]

{ #category : #tests }
TestJsonToCSV >> testConvertObject [

	| csv |
	csv := JsonToCSV transformString: '{ "x" : 1 }'.
	self 
		assert: (csv withLineEndings: String lf)
		equals: 
'"x"
1
' withUnixLineEndings 
]

{ #category : #tests }
TestJsonToCSV >> testConvertObjectWithManyFields [

	| csv |
	csv := JsonToCSV transformString: '{ "x" : 1, "y": true }'.
	self 
		assert: (csv withLineEndings: String lf)
		equals: 
'"x","y"
1,true
' withUnixLineEndings 
]

{ #category : #tests }
TestJsonToCSV >> testConvertObjectWithNestedFieldsKeepsOrder [

	| csv |
	csv := JsonToCSV transformString: '{ "x": { "a": 1, "b": 2 }, "y": { "a": 3, "b": 4 } }'.
	self 
		assert: (csv withLineEndings: String lf)
		equals: 
'"x_a","x_b","y_a","y_b"
1,2,3,4
' withUnixLineEndings 
]
