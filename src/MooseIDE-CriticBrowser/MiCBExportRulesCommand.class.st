Class {
	#name : #MiCBExportRulesCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #default }
MiCBExportRulesCommand class >> defaultIconName [

	^ #smallSave
]

{ #category : #default }
MiCBExportRulesCommand class >> defaultName [

	^ 'Export rules'
]

{ #category : #executing }
MiCBExportRulesCommand >> execute [

	self context exportRules
]
