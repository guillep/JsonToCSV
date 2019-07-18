Extension { #name : #String }

{ #category : #'*JsonToCSV' }
String >> jsonFlattenOn: aJSONFlattener parentName: aString [ 

	^ aJSONFlattener flattenJSONString: self parentName: aString
]
