Extension { #name : #Array }

{ #category : #'*JsonToCSV' }
Array >> jsonFlattenOn: aJSONFlattener [
	
	^ aJSONFlattener flattenJSONArray: self
]

{ #category : #'*JsonToCSV' }
Array >> jsonFlattenOn: aJSONFlattener parentName: aName [

	^ aJSONFlattener flattenJSONArray: self parentName: aName
]
