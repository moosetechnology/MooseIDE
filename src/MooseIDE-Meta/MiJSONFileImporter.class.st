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
	[ model importFromJSONStream: inputStream ]
	ensure: [ inputStream close ]
]

{ #category : #running }
MiJSONFileImporter >> runFilteredBy: anImportingContext [

	[ model
		importFromJSONStream: inputStream
		filteredBy: anImportingContext ] ensure: [ inputStream close ]
]
