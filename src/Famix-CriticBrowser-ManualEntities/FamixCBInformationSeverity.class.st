"
I represent an Information severity in MooseCritics.
"
Class {
	#name : #FamixCBInformationSeverity,
	#superclass : #FamixCBAbstractSeverity,
	#category : #'Famix-CriticBrowser-ManualEntities-Severities'
}

{ #category : #accessing }
FamixCBInformationSeverity class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'smallInfo'
]

{ #category : #accessing }
FamixCBInformationSeverity class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 4
]

{ #category : #accessing }
FamixCBInformationSeverity class >> title [
"name of the severity (to print in UI)"
	^ 'Information'
]
