Class {
	#name : #MiInspectQueryCommand,
	#superclass : #MiCommand,
	#category : #'MooseIDE-QueriesBrowser-Commands'
}

{ #category : #default }
MiInspectQueryCommand class >> defaultDescription [

	^ 'Inspect this query'
]

{ #category : #accessing }
MiInspectQueryCommand class >> defaultIconName [

	^ #smallInspectIt 
]

{ #category : #default }
MiInspectQueryCommand class >> defaultName [

	^ 'Inspect query'
]

{ #category : #executing }
MiInspectQueryCommand >> execute [

	self context query inspect
]
