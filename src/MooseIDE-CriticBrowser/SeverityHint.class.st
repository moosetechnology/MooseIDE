"
I represent an Hint severity in MooseCritics.
"
Class {
	#name : #SeverityHint,
	#superclass : #AbstractSeverity,
	#category : #'MooseIDE-CriticBrowser-Severities'
}

{ #category : #accessing }
SeverityHint class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'help'
]

{ #category : #accessing }
SeverityHint class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 1
]

{ #category : #accessing }
SeverityHint class >> title [
"name of the severity (to print in UI)"
	^ 'Hint'
]
