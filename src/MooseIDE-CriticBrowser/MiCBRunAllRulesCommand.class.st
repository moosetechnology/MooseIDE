Class {
	#name : #MiCBRunAllRulesCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-CriticBrowser-Commands'
}

{ #category : #default }
MiCBRunAllRulesCommand class >> defaultIconName [

	^ #glamorousPlay
]

{ #category : #default }
MiCBRunAllRulesCommand class >> defaultName [

	^ 'Run'
]

{ #category : #executing }
MiCBRunAllRulesCommand >> execute [

	self context runAllRules
]
