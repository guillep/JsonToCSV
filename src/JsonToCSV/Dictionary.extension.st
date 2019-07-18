Extension { #name : #Dictionary }

{ #category : #'*JsonToCSV' }
Dictionary >> jsonFlattenOn: aJSONFlattener [ 
	
	^ aJSONFlattener flattenJSONObject: self
]

{ #category : #'*JsonToCSV' }
Dictionary >> jsonFlattenOn: aJSONFlattener parentName: aName [

	^ aJSONFlattener flattenJSONObject: self parentName: aName
]
