Class {
	#name : #MiQueryCreationCommand,
	#superclass : #CmCommand,
	#category : #'Midas-FamixQueries-Tools'
}

{ #category : #default }
MiQueryCreationCommand class >> defaultDescription [
	^ 'Apply this query'
]

{ #category : #default }
MiQueryCreationCommand class >> defaultIconName [
	^ #glamorousGo
]

{ #category : #default }
MiQueryCreationCommand class >> defaultName [
	^ 'Apply'
]

{ #category : #converting }
MiQueryCreationCommand >> asSpecCommand [
	^ super asSpecCommand
		iconName: self class defaultIconName;
		yourself
]

{ #category : #testing }
MiQueryCreationCommand >> canBeExecuted [
	^ self context query isValid
]

{ #category : #executing }
MiQueryCreationCommand >> confirmEmptyResult [
	^ UIManager default
		confirm: 'Do you want to apply this query ?'
		label: 'This query result is empty'
]

{ #category : #executing }
MiQueryCreationCommand >> confirmUnchangedResult [
	^ UIManager default
		confirm: 'Do you want to apply this query ?'
		label: 'Query input is identical to result'
]

{ #category : #executing }
MiQueryCreationCommand >> execute [
	self context query result
		ifEmpty: [ self confirmEmptyResult
				ifFalse: [ ^ self ] ].
	(self context query result
		hasEqualElements: self context parentEntities)
		ifTrue: [ self confirmUnchangedResult
				ifFalse: [ ^ self ] ].
	self context notifyAcceptedQuery.
	self context window close
]
