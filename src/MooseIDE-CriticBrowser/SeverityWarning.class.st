"
I represent an Warning severity in MooseCritics.
"
Class {
	#name : #SeverityWarning,
	#superclass : #AbstractSeverity,
	#category : #'MooseIDE-CriticBrowser-Severities'
}

{ #category : #accessing }
SeverityWarning class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'smallWarning'
]

{ #category : #accessing }
SeverityWarning class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 2
]

{ #category : #accessing }
SeverityWarning class >> title [
"name of the severity (to print in UI)"
	^ 'Warning'
]
