Extension { #name : #Number }

{ #category : #'*JsonToCSV' }
Number >> jsonFlattenOn: aJSONFlattener parentName: aName [
	
	^ aJSONFlattener flattenJSONNumber: self parentName: aName
]
