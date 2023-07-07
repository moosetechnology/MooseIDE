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

{ #category : #'as yet unclassified' }
MiJSONFileImporter >> runAggregating [

	[
	model
		importFrom: (model class
				 importFromJSON: inputStream
				 withMetamodel: model metamodel
				 customizingImporterWith: [ :importer |
				 FMImporterAggregationDecorator on: importer ])
		named: (inputStream localName removeSuffix: '.json') ] ensure: [
		inputStream close ]
]

{ #category : #running }
MiJSONFileImporter >> runFilteredBy: anImportingContext [

	[ model
		importFromJSONStream: inputStream
		filteredBy: anImportingContext ] ensure: [ inputStream close ]
]
