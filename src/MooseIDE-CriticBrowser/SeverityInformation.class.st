"
I represent an Information severity in MooseCritics.
"
Class {
	#name : #SeverityInformation,
	#superclass : #AbstractSeverity,
	#category : #'MooseIDE-CriticBrowser-Severities'
}

{ #category : #accessing }
SeverityInformation >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'smallInfo'
]

{ #category : #accessing }
SeverityInformation >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 4
]

{ #category : #accessing }
SeverityInformation >> name [
"name of the severity (to print in UI)"
	^ 'Information'
]
