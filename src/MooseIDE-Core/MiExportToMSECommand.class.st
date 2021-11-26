Class {
	#name : #MiExportToMSECommand,
	#superclass : #MiModelExportCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiExportToMSECommand class >> defaultDescription [
	^ 'Export this model to MSE'
]

{ #category : #default }
MiExportToMSECommand class >> defaultIconName [

	^ #mooseExportMse
]

{ #category : #default }
MiExportToMSECommand class >> defaultName [
	^ 'Export to MSE'
]

{ #category : #executing }
MiExportToMSECommand >> exportModel: aModel toStream: stream [
	aModel exportToMSEStream: stream
]

{ #category : #executing }
MiExportToMSECommand >> fileExtension [
	^ #('mse')
]
