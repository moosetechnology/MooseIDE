Class {
	#name : #MiExportToJSONCommand,
	#superclass : #MiModelExportCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiExportToJSONCommand class >> defaultDescription [
	^ 'Export this model to JSON'
]

{ #category : #default }
MiExportToJSONCommand class >> defaultIconName [

	^ #mooseExportJson
]

{ #category : #default }
MiExportToJSONCommand class >> defaultName [
	^ 'Export to JSON'
]

{ #category : #executing }
MiExportToJSONCommand >> exportModel: aModel toStream: stream [
	aModel exportToJSONStream: stream
]

{ #category : #executing }
MiExportToJSONCommand >> fileExtension [
	^ #('json')
]
