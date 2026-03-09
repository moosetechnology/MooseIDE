"
I represent an Error severity in MooseCritics.
"
Class {
	#name : #FamixCBErrorSeverity,
	#superclass : #FamixCBAbstractSeverity,
	#category : #'Famix-CriticBrowser-ManualEntities-Severities'
}

{ #category : #accessing }
FamixCBErrorSeverity class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'error'
]

{ #category : #accessing }
FamixCBErrorSeverity class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ 3
]

{ #category : #accessing }
FamixCBErrorSeverity class >> title [
"name of the severity (to print in UI)"
	^ 'Error'
]
