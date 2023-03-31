"
Importer for MSE files
"
Class {
	#name : #MiMSEFileImporter,
	#superclass : #MiAbstractFileImporter,
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #executing }
MiMSEFileImporter class >> fileExtension [
	^'mse'
]

{ #category : #running }
MiMSEFileImporter >> run [
	[ model importFromMSEStream: inputStream ]
	ensure: [ inputStream close ]
]

{ #category : #'as yet unclassified' }
MiMSEFileImporter >> runFilteredBy: anImportingContext [

	[ model importFromMSEStream: inputStream filteredBy: anImportingContext ] 
		ensure: [ inputStream close ]
]
