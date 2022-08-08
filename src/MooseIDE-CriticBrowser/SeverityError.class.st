"
I represent an Error severity in MooseCritics.
"
Class {
	#name : #SeverityError,
	#superclass : #AbstractSeverity,
	#category : #'MooseIDE-CriticBrowser-Severities'
}

{ #category : #accessing }
SeverityError class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'error'
]

{ #category : #accessing }
SeverityError class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 3
]

{ #category : #accessing }
SeverityError class >> title [
"name of the severity (to print in UI)"
	^ 'Error'
]
