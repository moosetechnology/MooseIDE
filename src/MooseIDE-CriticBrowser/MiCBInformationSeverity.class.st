"
I represent an Information severity in MooseCritics.
"
Class {
	#name : #MiCBInformationSeverity,
	#superclass : #MiCBAbstractSeverity,
	#category : #'MooseIDE-CriticBrowser-Severities'
}

{ #category : #accessing }
MiCBInformationSeverity class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'smallInfo'
]

{ #category : #accessing }
MiCBInformationSeverity class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 4
]

{ #category : #accessing }
MiCBInformationSeverity class >> title [
"name of the severity (to print in UI)"
	^ 'Information'
]
