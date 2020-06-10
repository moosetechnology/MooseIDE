Class {
	#name : #MiTypeQueryCreationCommand,
	#superclass : #CmCommand,
	#category : #'Midas-FamixQueries-Tools'
}

{ #category : #default }
MiTypeQueryCreationCommand class >> defaultName [
	^ 'Create new type query'
]

{ #category : #executing }
MiTypeQueryCreationCommand >> canBeExecuted [
	^ self context canCreateQueries
		and: [ self context roots includesAll: self context selectedItems ]
]

{ #category : #executing }
MiTypeQueryCreationCommand >> execute [
	self canBeExecuted
		ifFalse: [ ^ self ].
	self context createTypeQuery
]
