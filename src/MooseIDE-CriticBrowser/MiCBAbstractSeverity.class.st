"
I am the class defining severity of a condition in MooseCritics.

I am defined by a level, a unique integer for each of my subclasses, and with a name and an iconName used by the user interface.
"
Class {
	#name : #MiCBAbstractSeverity,
	#superclass : #Object,
	#category : #'MooseIDE-CriticBrowser-Severities'
}

{ #category : #accessing }
MiCBAbstractSeverity class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'blank'
]

{ #category : #accessing }
MiCBAbstractSeverity class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ self subclassResponsibility 
]

{ #category : #accessing }
MiCBAbstractSeverity class >> title [
"name of the severity (to print in UI)"
	^ self subclassResponsibility 
]
