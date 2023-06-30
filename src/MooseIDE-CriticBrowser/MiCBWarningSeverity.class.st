"
I represent an Warning severity in MooseCritics.
"
Class {
	#name : #MiCBWarningSeverity,
	#superclass : #MiCBAbstractSeverity,
	#category : #'MooseIDE-CriticBrowser-Severities'
}

{ #category : #accessing }
MiCBWarningSeverity class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'smallWarning'
]

{ #category : #accessing }
MiCBWarningSeverity class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 2
]

{ #category : #accessing }
MiCBWarningSeverity class >> title [
"name of the severity (to print in UI)"
	^ 'Warning'
]
