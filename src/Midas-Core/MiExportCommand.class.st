Class {
	#name : #MiExportCommand,
	#superclass : #CmCommand,
	#category : #'Midas-Core-Command'
}

{ #category : #executing }
MiExportCommand >> execute [
	self exportModel: self context miSelectedItem
]

{ #category : #executing }
MiExportCommand >> exportModel: aModel [
	| fileReference |
	fileReference := UITheme builder
		chooseForSaveFileReference: 'Choose location'
		extensions: self fileExtension
		path: ''.
	fileReference
		ifNotNil: [ fileReference
				writeStreamDo: [ :stream | 
					self exportModel: aModel toStream: stream.
					Notification signal: 'Save successful!' ] ]
]

{ #category : #executing }
MiExportCommand >> exportModel: aModel toStream: stream [
	self subclassResponsibility
]

{ #category : #executing }
MiExportCommand >> fileExtension [
	^ self subclassResponsibility
]
