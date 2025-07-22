"
I am the class defining severity of a condition in MooseCritics.

I am defined by a level, a unique integer for each of my subclasses, and with a name and an iconName used by the user interface.
"
Class {
	#name : 'FamixCBAbstractSeverity',
	#superclass : 'Object',
	#category : 'Famix-CriticBrowser-ManualEntities-Severities',
	#package : 'Famix-CriticBrowser-ManualEntities',
	#tag : 'Severities'
}

{ #category : 'accessing' }
FamixCBAbstractSeverity class >> iconName [
"name of the icon to use for violation printing in the UI (optional)"
	^ 'blank'
]

{ #category : 'accessing' }
FamixCBAbstractSeverity class >> level [
"an Int (unique to each subclass) to define the level of severity"
	^ self subclassResponsibility 
]

{ #category : 'accessing' }
FamixCBAbstractSeverity class >> title [
"name of the severity (to print in UI)"
	^ self subclassResponsibility 
]
