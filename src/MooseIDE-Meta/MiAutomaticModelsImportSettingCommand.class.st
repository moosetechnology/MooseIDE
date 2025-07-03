Class {
	#name : #MiAutomaticModelsImportSettingCommand,
	#superclass : #MiBooleanSettingCommand,
	#category : #'MooseIDE-Meta-Settings'
}

{ #category : #default }
MiAutomaticModelsImportSettingCommand class >> defaultDescription [

	^ 'When drag & drop model from file should it be automatically imported if possible or should it just configure the import dialog'
]

{ #category : #default }
MiAutomaticModelsImportSettingCommand class >> defaultName [

	^ 'Automatically import drag&drop files?'
]

{ #category : #accessing }
MiAutomaticModelsImportSettingCommand >> currentValue [

	^ self context modelImportIsAutomatic
]

{ #category : #execution }
MiAutomaticModelsImportSettingCommand >> execute: aBoolean [

	self context modelImportIsAutomatic: aBoolean
]
