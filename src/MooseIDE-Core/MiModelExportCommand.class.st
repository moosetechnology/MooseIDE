Class {
	#name : #MiModelExportCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #converting }
MiModelExportCommand class >> asCommandGroupWith: aPresenter [

	| exportCommandGroup |
	exportCommandGroup := CmCommandGroup forSpec
		                      name: self defaultName;
		                      description: self defaultDescription;
		                      iconName: #smallExport.
	self allSubclassesDo: [ :cmd | 
		exportCommandGroup register: (cmd forSpecContext: aPresenter) ].
	^ exportCommandGroup
]

{ #category : #default }
MiModelExportCommand class >> defaultDescription [
	^ 'Export this model'
]

{ #category : #default }
MiModelExportCommand class >> defaultName [
	^ 'Export'
]

{ #category : #executing }
MiModelExportCommand >> execute [
	self exportModel: self context miSelectedItem
]

{ #category : #executing }
MiModelExportCommand >> exportModel: aModel [
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
MiModelExportCommand >> exportModel: aModel toStream: stream [
	self subclassResponsibility
]

{ #category : #executing }
MiModelExportCommand >> fileExtension [
	^ self subclassResponsibility
]
