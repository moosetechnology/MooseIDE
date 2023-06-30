"
I represent an Hint severity in MooseCritics.
"
Class {
	#name : #MiCBHintSeverity,
	#superclass : #MiCBAbstractSeverity,
	#category : #'MooseIDE-CriticBrowser-Severities'
}

{ #category : #accessing }
MiCBHintSeverity class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'help'
]

{ #category : #accessing }
MiCBHintSeverity class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 1
]

{ #category : #accessing }
MiCBHintSeverity class >> title [
"name of the severity (to print in UI)"
	^ 'Hint'
]
