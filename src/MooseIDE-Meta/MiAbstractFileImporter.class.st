"
Abstract class for file importers

Responsabilities:
- able to check that a filename matches an extension that the file importer recognize
- able to import a given readStream into their `model`

"
Class {
	#name : #MiAbstractFileImporter,
	#superclass : #Object,
	#instVars : [
		'model',
		'stream'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #testing }
MiAbstractFileImporter class >> acceptFile: aFileReference [
	"this FileImporter can deal with the given FileReference"
	^(aFileReference extension = self fileExtension)
]

{ #category : #executing }
MiAbstractFileImporter class >> fileExtension [
	"file extension for the files that the fileImporter can accept"
	^nil
]

{ #category : #executing }
MiAbstractFileImporter class >> importerFor: aFileReference [
	^self withAllSubclasses
		detect: [ :clazz | clazz acceptFile: aFileReference ]
		ifNone: [ nil ]
]

{ #category : #accessing }
MiAbstractFileImporter >> model [

	^ model
]

{ #category : #accessing }
MiAbstractFileImporter >> model: anObject [

	model := anObject
]

{ #category : #running }
MiAbstractFileImporter >> run [
	self subclassResponsibility 
]

{ #category : #accessing }
MiAbstractFileImporter >> stream: anObject [

	stream := anObject
]
