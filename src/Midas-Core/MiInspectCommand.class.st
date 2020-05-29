"
Use me to inspect the selected entities
"
Class {
	#name : #MiInspectCommand,
	#superclass : #CmCommand,
	#category : #'Midas-Core-Command'
}

{ #category : #default }
MiInspectCommand class >> defaultName [
	^ 'Inspect'
]

{ #category : #default }
MiInspectCommand class >> forSpecContext: anObject [
	^ (self forSpecWithIconNamed: #mooseIcon) beHiddenWhenCantBeRun
]

{ #category : #testing }
MiInspectCommand >> canBeExecuted [
	^ self context miSelectedItem isMooseEntity
]

{ #category : #testing }
MiInspectCommand >> execute [
	^ self context miSelectedItem inspect
]
