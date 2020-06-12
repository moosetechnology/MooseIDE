Class {
	#name : #MiTypeQueryCreationCommand,
	#superclass : #CmCommand,
	#category : #'Midas-FamixQueries-Tools'
}

{ #category : #default }
MiTypeQueryCreationCommand class >> defaultName [
	^ 'Create new type query'
]

{ #category : #testing }
MiTypeQueryCreationCommand >> canBeExecuted [
	^ self context class == MiQueriesBrowser
]

{ #category : #executing }
MiTypeQueryCreationCommand >> execute [
	self canBeExecuted
		ifFalse: [ ^ self ].
	self context createTypeQuery
]
