Class {
	#name : #BaselineOfJsonToCSV,
	#superclass : #BaselineOf,
	#category : #BaselineOfJsonToCSV
}

{ #category : #baselines }
BaselineOfJsonToCSV >> baseline: spec [
	<baseline>
	spec for: #common do: [
		spec baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON:v17/repository' ].
		spec baseline: 'NeoCSV' with: [ spec repository: 'github://svenvc/NeoCSV:v15/repository' ] ]
]
