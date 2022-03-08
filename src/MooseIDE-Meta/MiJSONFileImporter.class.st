"
Importer for JSON file

"
Class {
	#name : #MiJSONFileImporter,
	#superclass : #MiAbstractFileImporter,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #executing }
MiJSONFileImporter class >> fileExtension [
	^'json'
]

{ #category : #running }
MiJSONFileImporter >> run [
	inputFile readStreamDo: [ :stream |
		model importFromJSONStream: stream
	]
]
