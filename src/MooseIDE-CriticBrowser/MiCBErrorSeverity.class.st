"
I represent an Error severity in MooseCritics.
"
Class {
	#name : #MiCBErrorSeverity,
	#superclass : #MiCBAbstractSeverity,
	#category : #'MooseIDE-CriticBrowser-Severities'
}

{ #category : #accessing }
MiCBErrorSeverity class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'error'
]

{ #category : #accessing }
MiCBErrorSeverity class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 3
]

{ #category : #accessing }
MiCBErrorSeverity class >> title [
"name of the severity (to print in UI)"
	^ 'Error'
]
