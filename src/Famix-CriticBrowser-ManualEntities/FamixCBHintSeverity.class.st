"
I represent an Hint severity in MooseCritics.
"
Class {
	#name : 'FamixCBHintSeverity',
	#superclass : 'FamixCBAbstractSeverity',
	#category : 'Famix-CriticBrowser-ManualEntities-Severities',
	#package : 'Famix-CriticBrowser-ManualEntities',
	#tag : 'Severities'
}

{ #category : 'accessing' }
FamixCBHintSeverity class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'help'
]

{ #category : 'accessing' }
FamixCBHintSeverity class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 1
]

{ #category : 'accessing' }
FamixCBHintSeverity class >> title [
"name of the severity (to print in UI)"
	^ 'Hint'
]
