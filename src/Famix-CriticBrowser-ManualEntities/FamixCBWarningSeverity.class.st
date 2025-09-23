"
I represent an Warning severity in MooseCritics.
"
Class {
	#name : #FamixCBWarningSeverity,
	#superclass : #FamixCBAbstractSeverity,
	#category : #'Famix-CriticBrowser-ManualEntities-Severities'
}

{ #category : #accessing }
FamixCBWarningSeverity class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'smallWarning'
]

{ #category : #accessing }
FamixCBWarningSeverity class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 2
]

{ #category : #accessing }
FamixCBWarningSeverity class >> title [
"name of the severity (to print in UI)"
	^ 'Warning'
]
