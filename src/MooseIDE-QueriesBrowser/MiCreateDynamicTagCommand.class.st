Class {
	#name : #MiCreateDynamicTagCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #default }
MiCreateDynamicTagCommand class >> defaultDescription [

	^ 'Open the tag browser on the tag creation page associated to this query sequence'
]

{ #category : #accessing }
MiCreateDynamicTagCommand class >> defaultIconName [

	^ #emptyTag
]

{ #category : #default }
MiCreateDynamicTagCommand class >> defaultName [

	^ 'Create a dynamic tag'
]

{ #category : #executing }
MiCreateDynamicTagCommand >> execute [

	self context query inspect
]
