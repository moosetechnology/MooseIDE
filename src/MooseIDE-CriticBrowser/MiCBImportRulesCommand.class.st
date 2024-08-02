Class {
	#name : #MiCBImportRulesCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #default }
MiCBImportRulesCommand class >> defaultIconName [

	^ #smallOpen
]

{ #category : #default }
MiCBImportRulesCommand class >> defaultName [

	^ 'Import rules'
]

{ #category : #executing }
MiCBImportRulesCommand >> execute [

	self context importRules
]
