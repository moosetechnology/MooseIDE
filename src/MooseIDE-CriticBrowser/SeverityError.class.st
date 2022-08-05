"
I represent an Error severity in MooseCritics.
"
Class {
	#name : #SeverityError,
	#superclass : #AbstractSeverity,
	#category : #'MooseIDE-CriticBrowser-Severities'
}

{ #category : #accessing }
SeverityError >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'error'
]

{ #category : #accessing }
SeverityError >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 3
]

{ #category : #accessing }
SeverityError >> name [
"name of the severity (to print in UI)"
	^ 'Error'
]
