Extension { #name : #Boolean }

{ #category : #'*JsonToCSV' }
Boolean >> jsonFlattenOn: aJSONFlattener parentName: aString [ 

	^ aJSONFlattener flattenJSONBoolean: self parentName: aString
]
