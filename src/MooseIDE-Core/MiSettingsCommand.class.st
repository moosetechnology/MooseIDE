"
Access point to configure the settings of a browser
Browsers should implement #hasSetting (to return true) and #settings to open the settings presenter

"
Class {
	#name : #MiSettingsCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-Core-Command'
}

{ #category : #default }
MiSettingsCommand class >> defaultDescription [

	^ 'Configure settings'
]

{ #category : #default }
MiSettingsCommand class >> defaultIconName [

	^ ##smallConfiguration
]

{ #category : #default }
MiSettingsCommand class >> defaultName [

	^ 'Settings'
]

{ #category : #testing }
MiSettingsCommand >> canBeExecuted [

	^ self context hasSettings
]

{ #category : #executing }
MiSettingsCommand >> execute [

	self context settings
]
