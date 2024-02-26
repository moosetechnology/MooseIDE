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
		'inputStream'
	],
	#category : #'MooseIDE-Meta-Import'
}

{ #category : #testing }
MiAbstractFileImporter class >> acceptFile: aFileReference [
	"this FileImporter can deal with the given FileReference"
	^(aFileReference extension = self fileExtension)
]

{ #category : #'model detection' }
MiAbstractFileImporter class >> canImport: inputSample importer: importer metaModel: tmpModel [

	"try import with the metamodel
	 - on FMElementNotFound, some class was not found in the metamodel, it's a failure
	 - on FMSyntaxError, we reached end of the stream (which is an excerpt of a file) so it is a success
	 - on other Error, not sure what it is but assume failure
	 - on no Error, could import the whole stream that was less than default sample size, so it is a success"

	[ 
	importer
		model: tmpModel;
		inputStream: inputSample readStream;
		run ]
		on: Error
		do: [ :err | 
			err class = FMElementNotFound ifTrue: [ ^ false ].
			err class = FMSyntaxError ifTrue: [ ^ true ].
			^ false ].
	^ true
]

{ #category : #executing }
MiAbstractFileImporter class >> fileExtension [
	"file extension for the files that the fileImporter can accept"
	^nil
]

{ #category : #'model detection' }
MiAbstractFileImporter class >> findPossibleModelClassIn: aCollectionOfModels forFile: aFile [
	"I get provided with a collection of Moose models and a file containing a model I can parse and I'll return the first model that does not crash when trying to import the model in it."

	| importer inputSample |
	importer := self new.
	inputSample := self inputSampleFrom: aFile.

	^ aCollectionOfModels
		  detect: [ :mmClass | self canImport: inputSample importer: importer metaModel: mmClass new ]
		  ifNone: [ Error signal: 'No metamodel to import file' ]
]

{ #category : #executing }
MiAbstractFileImporter class >> importerFor: aFileReference [
	^self withAllSubclasses
		detect: [ :clazz | clazz acceptFile: aFileReference ]
		ifNone: [ nil ]
]

{ #category : #'model detection' }
MiAbstractFileImporter class >> inputSampleFrom: aFile [

	^ aFile readStreamDo: [ :inputStream |
		  | firstChar |
		  firstChar := inputStream peek.
		  inputStream size < self class inputSampleLength
			  ifTrue: [ inputStream contents ]
			  ifFalse: [
				  (inputStream next: self class inputSampleLength) , (inputStream upTo: (firstChar = $(
						    ifTrue: [ "mse" $) ]
						    ifFalse: [ "json" $} ])) ] ]
]

{ #category : #executing }
MiAbstractFileImporter class >> knownExtensions [
	^self withAllSubclasses
		collect: [ :clazz | clazz fileExtension ]
		thenReject: [ :ext | ext isNil ]
]

{ #category : #accessing }
MiAbstractFileImporter >> inputFile: aFileReference [

	inputStream := aFileReference readStream
]

{ #category : #accessing }
MiAbstractFileImporter >> inputStream: aStream [
	inputStream := aStream
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

{ #category : #'as yet unclassified' }
MiAbstractFileImporter >> runFilteredBy: anImportingContext [

	self subclassResponsibility
]
