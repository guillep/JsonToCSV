Extension { #name : #OrderedDictionary }

{ #category : #'*JsonToCSV' }
OrderedDictionary >> jsonFlattenOn: aJSONFlattener [ 
	
	^ aJSONFlattener flattenJSONObject: self
]

{ #category : #'*JsonToCSV' }
OrderedDictionary >> jsonFlattenOn: aJSONFlattener parentName: aName [

	^ aJSONFlattener flattenJSONObject: self parentName: aName
]
