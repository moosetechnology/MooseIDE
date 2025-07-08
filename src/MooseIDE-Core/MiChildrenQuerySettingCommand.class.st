Class {
	#name : #MiChildrenQuerySettingCommand,
	#superclass : #MiQuerySettingCommand,
	#category : #'MooseIDE-Core-Settings'
}

{ #category : #default }
MiChildrenQuerySettingCommand class >> defaultDescription [

	^ 'Query used to get the children of an entity'
]

{ #category : #default }
MiChildrenQuerySettingCommand class >> defaultName [

	^ 'Children query'
]

{ #category : #accessing }
MiChildrenQuerySettingCommand >> currentValue [

	^ self context childrenQuery
]

{ #category : #defaults }
MiChildrenQuerySettingCommand >> defaultQuery [

	^ self application defaultChildrenQuery
]

{ #category : #execution }
MiChildrenQuerySettingCommand >> execute: aQuery [

	self context childrenQuery: aQuery
]
