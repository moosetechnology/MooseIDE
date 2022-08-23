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
	inputFile readStreamDo: [ :stream |
		model importFromMSEStream: stream
	]
]
